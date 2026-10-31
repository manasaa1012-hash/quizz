import { Router } from "express";
import { z } from "zod";
import { requireAuth } from "../middleware/auth.js";
import { supabase } from "../config/supabase.js";
import { AppError } from "../utils/http.js";
import { rankExamLeaderboard, rankLeaderboard } from "../utils/gamificationEngine.js";

export const leaderboardRouter=Router(); leaderboardRouter.use(requireAuth);
const querySchema=z.object({scope:z.enum(["global","daily","weekly","monthly","subject","exam"]).default("global"),subject_id:z.string().uuid().optional(),exam_id:z.string().uuid().optional()});
const startFor=(scope:string)=>{const d=new Date();if(scope==="daily")d.setUTCHours(0,0,0,0);if(scope==="weekly"){d.setUTCHours(0,0,0,0);d.setUTCDate(d.getUTCDate()-((d.getUTCDay()+6)%7))}if(scope==="monthly"){d.setUTCHours(0,0,0,0);d.setUTCDate(1)}return d.toISOString()};

async function decorate(raw:any[]){
  const ids=[...new Set(raw.map(r=>r.user_id))];
  const [{data:profiles},{data:stats}]=await Promise.all([ids.length?supabase.from("profiles").select("id,full_name,avatar_url").in("id",ids):Promise.resolve({data:[] as any[]}),ids.length?supabase.from("student_stats").select("*").in("user_id",ids):Promise.resolve({data:[] as any[]})]);
  const names=new Map((profiles||[]).map(p=>[p.id,p])), statMap=new Map((stats||[]).map(s=>[s.user_id,s]));
  return raw.map(r=>{const s:any=statMap.get(r.user_id)||{};const p:any=names.get(r.user_id)||{};const solved=Number(s.questions_solved||0);return{...r,full_name:p.full_name||"Student",avatar_url:p.avatar_url||null,total_xp:Number(s.total_xp||0),quizzes_completed:Number(s.quizzes_completed||0),streak_days:Number(s.streak_days||0),level:Number(s.current_level||1),accuracy:r.accuracy??(solved?Number(s.correct_answers||0)/solved*100:0)}});
}

leaderboardRouter.get("/options",async(_req,res,next)=>{try{const[{data:subjects},{data:exams}]=await Promise.all([supabase.from("subjects").select("id,name").eq("is_active",true).order("name"),supabase.from("exams").select("id,title,subject_id").eq("status","published").order("title")]);res.json({subjects:subjects||[],exams:exams||[]})}catch(e){next(e)}});
leaderboardRouter.get("/",async(req,res,next)=>{try{
  const q=querySchema.parse(req.query);let rows:any[]=[];
  if(q.scope==="global"){
    const{data,error}=await supabase.from("student_stats").select("*").order("total_xp",{ascending:false}).limit(100);if(error)throw new AppError(500,"Unable to load leaderboard.");
    const decorated=await decorate((data||[]).map(s=>({user_id:s.user_id,xp:Number(s.total_xp||0),accuracy:Number(s.questions_solved||0)?Number(s.correct_answers||0)/Number(s.questions_solved)*100:0,quizzes:Number(s.quizzes_completed||0)})));
    rows=rankLeaderboard(decorated.map(r=>({...r,name:r.full_name}))).map(r=>({...r,score:null,period_xp:r.xp}));
  }else if(["daily","weekly","monthly"].includes(q.scope)){
    const{data,error}=await supabase.from("xp_transactions").select("user_id,amount").gte("created_at",startFor(q.scope));if(error)throw new AppError(500,"Unable to load period leaderboard.");
    const sums=new Map<string,number>();for(const x of data||[])sums.set(x.user_id,(sums.get(x.user_id)||0)+Number(x.amount));
    const decorated=await decorate([...sums].map(([user_id,xp])=>({user_id,xp,accuracy:undefined,quizzes:0})));
    rows=rankLeaderboard(decorated.map(r=>({...r,accuracy:r.accuracy,quizzes:r.quizzes_completed,name:r.full_name}))).map(r=>({...r,score:null,period_xp:r.xp}));
  }else if(q.scope==="subject"){
    if(!q.subject_id)throw new AppError(400,"Select a subject.");
    const{data,error}=await supabase.from("exam_attempts").select("user_id,percentage,correct_count,incorrect_count,total_time_seconds,submitted_at,exams!inner(subject_id)").eq("status","submitted").eq("exams.subject_id",q.subject_id);if(error)throw new AppError(500,"Unable to load subject leaderboard.");
    const grouped=new Map<string,any[]>();for(const a of data||[])grouped.set(a.user_id,[...(grouped.get(a.user_id)||[]),a]);
    const base=[...grouped].map(([user_id,a])=>({user_id,score:a.reduce((s,x)=>s+Number(x.percentage),0)/a.length,accuracy:a.reduce((s,x)=>s+Number(x.correct_count),0)/Math.max(1,a.reduce((s,x)=>s+Number(x.correct_count)+Number(x.incorrect_count),0))*100,quizzes:a.length,time:a.reduce((s,x)=>s+Number(x.total_time_seconds||0),0)}));
    rows=(await decorate(base)).sort((a,b)=>b.score-a.score||b.accuracy-a.accuracy||b.quizzes-a.quizzes).map((r,i)=>({...r,rank:i+1,period_xp:r.total_xp}));
  }else{
    if(!q.exam_id)throw new AppError(400,"Select an exam.");
    const{data,error}=await supabase.from("exam_attempts").select("user_id,percentage,accuracy,total_time_seconds,submitted_at").eq("status","submitted").eq("exam_id",q.exam_id);if(error)throw new AppError(500,"Unable to load exam leaderboard.");
    const best=new Map<string,any>();for(const a of data||[]){const old=best.get(a.user_id);if(!old||Number(a.percentage)>Number(old.percentage)||Number(a.percentage)===Number(old.percentage)&&(Number(a.total_time_seconds)<Number(old.total_time_seconds)||Number(a.total_time_seconds)===Number(old.total_time_seconds)&&String(a.submitted_at).localeCompare(String(old.submitted_at))<0))best.set(a.user_id,a)}
    const ranked=rankExamLeaderboard([...best.values()].map(a=>({user_id:a.user_id,score:Number(a.percentage),time:Number(a.total_time_seconds||0),submitted_at:a.submitted_at,accuracy:Number(a.accuracy||0)})));rows=(await decorate(ranked)).map(r=>({...r,period_xp:r.total_xp}));
  }
  res.json({scope:q.scope,leaderboard:rows.slice(0,100),ranking_rules:q.scope==="exam"?"Best score descending, then completion time ascending, then earliest submission.":q.scope==="subject"?"Average subject score, accuracy, then quizzes completed.":"XP descending, then accuracy, quizzes completed, and name."});
}catch(e){next(e)}});
