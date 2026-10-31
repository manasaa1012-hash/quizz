import { Router } from "express";
import { requireAuth } from "../middleware/auth.js";
import { supabase } from "../config/supabase.js";
import { AppError } from "../utils/http.js";
import { levelProgress } from "../utils/gamificationEngine.js";

export const gamificationRouter=Router();
gamificationRouter.use(requireAuth);

export async function getGamificationSummary(userId:string){
  const [{data:stats,error},{data:levels},{data:badges},{data:earned},{data:transactions},{data:attempts}]=await Promise.all([
    supabase.from("student_stats").select("*").eq("user_id",userId).maybeSingle(),
    supabase.from("levels").select("*").order("xp_required"),
    supabase.from("badges").select("*").eq("is_active",true).order("criteria_value"),
    supabase.from("student_badges").select("badge_id,earned_at").eq("user_id",userId).order("earned_at",{ascending:false}),
    supabase.from("xp_transactions").select("id,amount,reason,source_type,source_id,created_at").eq("user_id",userId).order("created_at",{ascending:false}).limit(20),
    supabase.from("exam_attempts").select("percentage,exams(subject_id)").eq("user_id",userId).eq("status","submitted")
  ]);
  if(error)throw new AppError(500,"Unable to load gamification progress.");
  const safeStats=stats||{total_xp:0,quizzes_completed:0,streak_days:0,longest_streak:0,questions_solved:0,correct_answers:0,total_response_seconds:0,perfect_scores:0,current_level:1};
  const progress=levelProgress(Number(safeStats.total_xp||0),(levels||[]) as any);
  const earnedMap=new Map((earned||[]).map(x=>[x.badge_id,x.earned_at]));
  const totalQuestions=Number(safeStats.questions_solved||0), accuracy=totalQuestions?Number(safeStats.correct_answers||0)/totalQuestions*100:0;
  const averageTime=totalQuestions?Number(safeStats.total_response_seconds||0)/totalQuestions:0;
  const globalRankResult=await supabase.from("student_stats").select("user_id",{count:"exact",head:true}).gt("total_xp",Number(safeStats.total_xp||0));
  const globalRank=(globalRankResult.count||0)+1;
  const subjects=new Map<string,number[]>();for(const a of attempts||[]){const exam:any=Array.isArray(a.exams)?a.exams[0]:a.exams;if(exam?.subject_id)subjects.set(exam.subject_id,[...(subjects.get(exam.subject_id)||[]),Number(a.percentage||0)])}const subjectAccuracy=Math.max(0,...[...subjects.values()].filter(x=>x.length>=3).map(x=>x.reduce((s,v)=>s+v,0)/x.length));
  const metrics:any={total_xp:Number(safeStats.total_xp||0),quizzes_completed:Number(safeStats.quizzes_completed||0),questions_solved:totalQuestions,streak:Number(safeStats.streak_days||0),accuracy,average_response_time:averageTime,perfect_scores:Number(safeStats.perfect_scores||0),global_rank:globalRank,subject_accuracy:subjectAccuracy};
  const badgeRows=(badges||[]).map((b:any)=>{const target=Number(b.criteria_value);let current=metrics[b.criteria_type]||0;let percent=target?current/target*100:0;if(b.criteria_type==="speed_under"){current=averageTime;percent=totalQuestions>=50&&averageTime>0?Math.min(100,target/averageTime*100):Math.min(99,totalQuestions/50*100)}if(b.criteria_type==="global_rank"){current=globalRank;percent=Math.min(100,target/globalRank*100)}return{...b,earned:Boolean(earnedMap.has(b.id)),earned_at:earnedMap.get(b.id)||null,progress:earnedMap.has(b.id)?100:Math.max(0,Math.min(100,percent)),current_value:Number(current.toFixed?.(1)??current)}});
  return {stats:safeStats,level:{current:progress.current,next:progress.next,xp_to_next:progress.xpToNext,progress_percentage:Number(progress.progress.toFixed(1))},global_rank:globalRank,badges:badgeRows,recent_achievement:badgeRows.filter((b:any)=>b.earned).sort((a:any,b:any)=>String(b.earned_at).localeCompare(String(a.earned_at)))[0]||null,recent_transactions:transactions||[]};
}

gamificationRouter.get("/me",async(req,res,next)=>{try{res.json(await getGamificationSummary(req.authUser!.id))}catch(e){next(e)}});
gamificationRouter.get("/achievements",async(req,res,next)=>{try{const data=await getGamificationSummary(req.authUser!.id);res.json({badges:data.badges,summary:{earned:data.badges.filter((b:any)=>b.earned).length,total:data.badges.length,total_xp:data.stats.total_xp,current_level:data.level.current}})}catch(e){next(e)}});
