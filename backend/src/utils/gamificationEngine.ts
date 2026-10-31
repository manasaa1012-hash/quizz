export type XpInput = { correct: number; hardCorrect: number; completed?: boolean; perfect?: boolean; firstActivityToday?: boolean };

export const XP_RULES = { correct: 10, hardBonus: 5, completed: 30, perfect: 100, dailyStreak: 20 } as const;
export const xpTransactionKey = (userId:string,sourceType:string,sourceId:string,reason:string) => `${userId}:${sourceType}:${sourceId}:${reason}`;

export function calculateXp(input: XpInput) {
  const breakdown = [
    { reason: "correct_answers", amount: Math.max(0, input.correct) * XP_RULES.correct },
    { reason: "hard_answer_bonus", amount: Math.max(0, input.hardCorrect) * XP_RULES.hardBonus },
    { reason: "quiz_completed", amount: input.completed === false ? 0 : XP_RULES.completed },
    { reason: "perfect_score", amount: input.perfect ? XP_RULES.perfect : 0 },
    { reason: "daily_streak_bonus", amount: input.firstActivityToday ? XP_RULES.dailyStreak : 0 }
  ].filter(item => item.amount > 0);
  return { total: breakdown.reduce((sum, item) => sum + item.amount, 0), breakdown };
}

export type Level = { level_number: number; name: string; xp_required: number };
export function levelProgress(totalXp: number, levels: Level[]) {
  const ordered = [...levels].sort((a,b)=>a.xp_required-b.xp_required);
  const current = [...ordered].reverse().find(level=>level.xp_required<=totalXp) || ordered[0];
  const next = ordered.find(level=>level.xp_required>totalXp) || null;
  const span = next ? next.xp_required-current.xp_required : 0;
  return { current, next, xpToNext: next ? next.xp_required-totalXp : 0, progress: next && span ? Math.max(0,Math.min(100,(totalXp-current.xp_required)/span*100)) : 100 };
}

export function nextStreak(current: number, longest: number, lastActivity: string | null, activity: string) {
  const today = new Date(`${activity}T00:00:00Z`);
  if (!lastActivity) return { current: 1, longest: Math.max(longest,1), increased: true };
  const previous = new Date(`${lastActivity}T00:00:00Z`);
  const days = Math.round((today.getTime()-previous.getTime())/86400000);
  if (days<=0) return { current, longest: Math.max(longest,current), increased: false };
  const next = days===1 ? current+1 : 1;
  return { current: next, longest: Math.max(longest,next), increased: true };
}

export type BadgeDefinition = { id:string; criteria_type:string; criteria_value:number };
export type BadgeMetrics = Record<string,number>;
export function eligibleBadges(definitions:BadgeDefinition[], earnedIds:Set<string>, metrics:BadgeMetrics) {
  return definitions.filter(b=>!earnedIds.has(b.id) && (
    b.criteria_type==="speed_under" ? (metrics.questions_solved||0)>=50 && (metrics.average_response_time??Infinity)<=b.criteria_value
      : b.criteria_type==="global_rank" ? (metrics.global_rank??Infinity)<=b.criteria_value
      : (metrics[b.criteria_type]||0)>=b.criteria_value
  ));
}

export type RankRow = { user_id:string; xp:number; accuracy:number; quizzes:number; name?:string };
export function rankLeaderboard(rows:RankRow[]) {
  return [...rows].sort((a,b)=>b.xp-a.xp||b.accuracy-a.accuracy||b.quizzes-a.quizzes||(a.name||"").localeCompare(b.name||"")).map((row,index)=>({...row,rank:index+1}));
}

export type ExamRankRow = { user_id:string; score:number; time:number; submitted_at:string };
export function rankExamLeaderboard(rows:ExamRankRow[]) {
  return [...rows].sort((a,b)=>b.score-a.score||a.time-b.time||a.submitted_at.localeCompare(b.submitted_at)).map((row,index)=>({...row,rank:index+1}));
}

export function notificationEvent(userId:string,type:string,sourceId:string,title:string,message:string,link:string) {
  return { user_id:userId,type,title,message,link,event_key:`${type}:${sourceId}` };
}
