import { useCallback, useEffect, useState } from "react";
import { Crown, Flame, Medal, Radio, Trophy, Users } from "lucide-react";
import { api } from "../lib/api";
import { supabase } from "../lib/supabase";
import { EmptyState } from "../components/EmptyState";

const scopes = ["global", "daily", "weekly", "monthly", "subject", "exam"] as const;

export default function LeaderboardPage() {
  const [scope, setScope] = useState<(typeof scopes)[number]>("global");
  const [rows, setRows] = useState<any[]>([]);
  const [options, setOptions] = useState<any>({ subjects: [], exams: [] });
  const [subject, setSubject] = useState("");
  const [exam, setExam] = useState("");
  const [rules, setRules] = useState("");
  const [error, setError] = useState("");
  const load = useCallback(() => {
    const params: any = { scope };
    if (scope === "subject" && subject) params.subject_id = subject;
    if (scope === "exam" && exam) params.exam_id = exam;
    if ((scope === "subject" && !subject) || (scope === "exam" && !exam)) { setRows([]); return Promise.resolve(); }
    return api.get("/leaderboard", { params }).then((response) => { setRows(response.data.leaderboard); setRules(response.data.ranking_rules); setError(""); }).catch((caught) => setError(caught.message));
  }, [scope, subject, exam]);

  useEffect(() => { api.get("/leaderboard/options").then((response) => { setOptions(response.data); setSubject(response.data.subjects[0]?.id || ""); setExam(response.data.exams[0]?.id || ""); }); }, []);
  useEffect(() => { void load(); const channel = supabase.channel(`leaderboard-${scope}`).on("postgres_changes", { event: "*", schema: "public", table: "student_stats" }, load).subscribe(); return () => { void supabase.removeChannel(channel); }; }, [load, scope]);

  const topLearners = rows.slice(0, 3);
  const points = (row: any) => scope === "exam" || scope === "subject" ? `${Number(row.score || 0).toFixed(1)}%` : `${row.period_xp ?? row.total_xp ?? 0} XP`;

  return <>
    <section className="leaderboard-hero"><Crown size={38} /><span className="leaderboard-hero-kicker">LIVE RANKINGS</span><h1>Leaderboard</h1><p><Radio size={14} /> See how you rank as verified rewards arrive.</p></section>
    <div className="leaderboard-tabs">{scopes.map((item) => <button key={item} className={scope === item ? "active" : ""} onClick={() => setScope(item)}>{item}</button>)}</div>
    {scope === "subject" && <select className="leaderboard-filter" value={subject} onChange={(event) => setSubject(event.target.value)}>{options.subjects.map((item: any) => <option value={item.id} key={item.id}>{item.name}</option>)}</select>}
    {scope === "exam" && <select className="leaderboard-filter" value={exam} onChange={(event) => setExam(event.target.value)}>{options.exams.map((item: any) => <option value={item.id} key={item.id}>{item.title}</option>)}</select>}
    {error && <div className="alert error">{error}</div>}
    {!!topLearners.length && <section className="leaderboard-podium">{topLearners.map((row) => <article className={`podium-summary rank-${row.rank}`} key={row.user_id}><span className="podium-rank">#{row.rank}</span>{row.rank === 1 ? <Crown size={22} /> : <Medal size={22} />}<strong>{row.full_name}</strong><small>{points(row)}</small><span><Flame size={14} /> {row.streak_days || 0} day streak</span></article>)}</section>}
    <section className="card"><div className="section-title"><h2><Trophy size={18} /> Learner rankings</h2><span className="muted"><Users size={14} /> {rows.length} ranked learner{rows.length === 1 ? "" : "s"}</span></div>
      {rows.length ? <div className="table-wrap"><table className="table"><thead><tr><th>Rank</th><th>Student</th><th>{scope === "exam" || scope === "subject" ? "Score" : "XP"}</th><th>Accuracy</th><th>Quizzes</th><th>Streak</th><th>Level</th>{scope === "exam" && <th>Time</th>}</tr></thead><tbody>{rows.map((row) => <tr key={row.user_id}><td>{row.rank === 1 ? <Crown size={20} /> : row.rank <= 3 ? <Medal size={20} /> : `#${row.rank}`}</td><td><strong>{row.full_name}</strong></td><td><b>{points(row)}</b></td><td>{Number(row.accuracy || 0).toFixed(1)}%</td><td>{row.quizzes_completed}</td><td><span className="inline"><Flame size={15} />{row.streak_days}</span></td><td>{row.level}</td>{scope === "exam" && <td>{row.time}s</td>}</tr>)}</tbody></table></div> : <EmptyState icon={Trophy} title="No verified rankings yet" description="Complete learning activities to appear on this leaderboard." />}
      {rules && <p className="ranking-rules"><strong>Ranking rule:</strong> {rules}</p>}
    </section>
  </>;
}
