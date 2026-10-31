import { Router } from "express";
import { requireAuth } from "../middleware/auth.js";
import { supabase } from "../config/supabase.js";
import { AppError } from "../utils/http.js";
import { calculateAbility, improvementRate, type LearningObservation } from "../utils/learningEngine.js";

export const analyticsRouter = Router();
analyticsRouter.use(requireAuth);
const avg = (v: number[]) => v.length ? v.reduce((a,b)=>a+b,0)/v.length : 0;
const round = (v: number) => Number(v.toFixed(2));

export async function buildAnalytics(userId: string) {
  const { data: attempts, error } = await supabase.from("exam_attempts")
    .select("id,percentage,accuracy,average_response_time_seconds,correct_count,incorrect_count,submitted_at,exams(title,subject_id)")
    .eq("user_id", userId).eq("status", "submitted").order("submitted_at");
  if (error) throw new AppError(500, "Unable to load analytics.");
  const ids = (attempts||[]).map(a=>a.id);
  const { data: answers, error: answerError } = ids.length
    ? await supabase.from("student_answers").select("attempt_id,is_correct,selected_answer,time_taken_seconds,question_snapshot").in("attempt_id",ids)
    : { data: [] as any[], error: null };
  if (answerError) throw new AppError(500, "Unable to load answer analytics.");
  const topicIds = [...new Set((answers||[]).map((a:any)=>a.question_snapshot?.topic_id).filter(Boolean))];
  const subjectIds = [...new Set((attempts||[]).map((a:any)=>(Array.isArray(a.exams)?a.exams[0]:a.exams)?.subject_id).filter(Boolean))];
  const [{data:topics},{data:subjects}] = await Promise.all([
    topicIds.length ? supabase.from("topics").select("id,name,subject_id").in("id",topicIds) : Promise.resolve({data:[] as any[]}),
    subjectIds.length ? supabase.from("subjects").select("id,name").in("id",subjectIds) : Promise.resolve({data:[] as any[]})
  ]);
  const topicNames = new Map((topics||[]).map(t=>[t.id,t]));
  const subjectNames = new Map((subjects||[]).map(s=>[s.id,s.name]));
  const attemptDates = new Map((attempts||[]).map(a=>[a.id,a.submitted_at]));
  const topicGroups = new Map<string,LearningObservation[]>();
  const difficulty = new Map<string,{attempted:number;correct:number;time:number}>();
  for (const answer of answers||[]) {
    if (answer.selected_answer === null) continue;
    const snap:any = answer.question_snapshot||{};
    const level = snap.difficulty||"medium";
    const dg=difficulty.get(level)||{attempted:0,correct:0,time:0};
    dg.attempted++; if(answer.is_correct) dg.correct++; dg.time+=Number(answer.time_taken_seconds||0); difficulty.set(level,dg);
    if(snap.topic_id) topicGroups.set(snap.topic_id,[...(topicGroups.get(snap.topic_id)||[]),{correct:Boolean(answer.is_correct),difficulty:level,responseTimeSeconds:Number(answer.time_taken_seconds||0),occurredAt:attemptDates.get(answer.attempt_id)||undefined}]);
  }
  const topicPerformance:any[]=[];
  for(const [topicId,obs] of topicGroups){
    const ability=calculateAbility(obs); const correct=obs.filter(o=>o.correct).length;
    const diffAcc=(d:string)=>{const rows=obs.filter(o=>o.difficulty===d);return rows.length?round(rows.filter(o=>o.correct).length/rows.length*100):0};
    const topic=topicNames.get(topicId); const row={topic_id:topicId,topic_name:topic?.name||"Topic",subject_id:topic?.subject_id,attempted:obs.length,correct,incorrect:obs.length-correct,accuracy:round(correct/obs.length*100),average_time:round(avg(obs.map(o=>o.responseTimeSeconds))),easy_accuracy:diffAcc("easy"),medium_accuracy:diffAcc("medium"),hard_accuracy:diffAcc("hard"),recent_trend:ability.trend,ability_score:ability.ability,status:ability.status};
    topicPerformance.push(row);
    await supabase.from("student_topic_ability").upsert({user_id:userId,topic_id:topicId,ability_score:ability.ability,status:ability.status,attempted:obs.length,accuracy:row.accuracy,recent_trend:ability.trend,updated_at:new Date().toISOString()},{onConflict:"user_id,topic_id"});
  }
  const scores=(attempts||[]).map(a=>Number(a.percentage||0));
  const timeline=(attempts||[]).map((a:any,i)=>({label:`Quiz ${i+1}`,date:a.submitted_at,score:Number(a.percentage||0),accuracy:Number(a.accuracy||0),response_time:Number(a.average_response_time_seconds||0),exam:(Array.isArray(a.exams)?a.exams[0]:a.exams)?.title||"Exam"}));
  const periods=(mode:"week"|"month")=>{const m=new Map<string,number[]>();for(const x of timeline){const d=new Date(x.date);const key=mode==="month"?d.toISOString().slice(0,7):`${d.getUTCFullYear()}-W${Math.ceil((((d.getTime()-Date.UTC(d.getUTCFullYear(),0,1))/86400000)+new Date(Date.UTC(d.getUTCFullYear(),0,1)).getUTCDay()+1)/7)}`;m.set(key,[...(m.get(key)||[]),x.score])}return[...m].map(([period,v])=>({period,score:round(avg(v)),attempts:v.length}))};
  const sg=new Map<string,number[]>(); for(const a of attempts||[]){const exam:any=Array.isArray((a as any).exams)?(a as any).exams[0]:(a as any).exams;const id=exam?.subject_id||"general";sg.set(id,[...(sg.get(id)||[]),Number(a.percentage||0)])}
  const attempted=(answers||[]).filter(a=>a.selected_answer!==null).length; const correct=(answers||[]).filter(a=>a.is_correct).length;
  const answeredRows=(answers||[]).filter(a=>a.selected_answer!==null);
  return {summary:{average_score:round(avg(scores)),best_score:scores.length?Math.max(...scores):0,overall_accuracy:attempted?round(correct/attempted*100):0,questions_attempted:attempted,correct_answers:correct,incorrect_answers:attempted-correct,average_response_time:round(avg(answeredRows.map(a=>Number(a.time_taken_seconds||0)))),quizzes_completed:scores.length,improvement_rate:improvementRate(scores)},score_over_time:timeline,accuracy_over_time:timeline.map(x=>({label:x.label,date:x.date,accuracy:x.accuracy})),response_time_trend:timeline.map(x=>({label:x.label,date:x.date,response_time:x.response_time})),exam_performance:timeline,subject_performance:[...sg].map(([id,v])=>({subject_id:id,subject:subjectNames.get(id)||"General",score:round(avg(v)),attempts:v.length})),topic_performance:topicPerformance.sort((a,b)=>a.ability_score-b.ability_score),difficulty_performance:[...difficulty].map(([level,v])=>({difficulty:level,accuracy:v.attempted?round(v.correct/v.attempted*100):0,average_time:v.attempted?round(v.time/v.attempted):0})),weekly_progress:periods("week"),monthly_progress:periods("month")};
}

analyticsRouter.get("/me",async(req,res,next)=>{try{res.json(await buildAnalytics(req.authUser!.id))}catch(e){next(e)}});
