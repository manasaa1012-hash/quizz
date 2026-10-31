import { useEffect, useState } from "react";
import { Link, useParams } from "react-router-dom";
import { api } from "../lib/api";

export default function AdminProctoringDetailPage() {
  const { attemptId } = useParams();
  const [data, setData] = useState<any>(null); const [error, setError] = useState("");
  const load = () => { if (attemptId) api.get(`/proctoring/reports/${attemptId}`).then(response => setData(response.data)).catch(caught => setError(caught.message)); };
  useEffect(() => { load(); }, [attemptId]);
  async function review(action: "resume" | "terminate") { if (!attemptId || !window.confirm(`${action === "resume" ? "Resume" : "Terminate"} this paused attempt?`)) return; try { await api.post(`/proctoring/reports/${attemptId}/${action}`); await load(); } catch (caught: any) { setError(caught.message); } }
  if (error) return <div className="card"><div className="alert error">{error}</div><Link to="/admin/proctoring">Back to reports</Link></div>;
  if (!data) return <div className="center-screen">Loading proctoring report...</div>;
  const { report, events } = data;
  return <>
    <div className="page-header"><div><span className="eyebrow">PROCTORING DETAIL</span><h1>{report.exams?.title || "Exam"}</h1><p>{report.profiles?.full_name || report.profiles?.email} · attempt {report.attempt_id}</p></div><Link className="button secondary" to="/admin/proctoring">All reports</Link></div>
    <div className="metrics"><div className="card"><span>Risk score</span><h2>{report.risk_score}/100</h2></div><div className="card"><span>Risk level</span><h2>{report.risk_level}</h2></div><div className="card"><span>Total events</span><h2>{events.length}</h2></div></div>
    {report.exam_attempts?.status === "paused" && <section className="card"><h2>Paused attempt review</h2><p className="muted">Resuming preserves the remaining time captured when the alert occurred. Terminating prevents this attempt from being resumed.</p><div className="button-row"><button className="button" onClick={() => void review("resume")}>Resume attempt</button><button className="button danger" onClick={() => void review("terminate")}>Terminate attempt</button></div></section>}
    <section className="card"><h2>Risk calculation</h2><div className="stat-list">{Object.entries(report.calculation?.contributions || {}).map(([event, points]) => <div key={event}><span>{event.replace(/_/g, " ")}</span><strong>{String(points)} points</strong></div>)}</div><small>Repeated events escalate by 25% per recurrence up to 2×. The displayed score is clamped to 100.</small></section>
    <section className="card"><h2>Chronological event timeline</h2>{!events.length ? <div className="empty">No events recorded.</div> : <div className="timeline">{events.map((event: any) => <article key={event.id} className="timeline-item"><time>{new Date(event.created_at).toLocaleString()}</time><div><strong>{event.event_type.replace(/_/g, " ")}</strong> <span className="status-badge neutral">{event.severity}</span><pre>{JSON.stringify(event.details || {}, null, 2)}</pre></div></article>)}</div>}</section>
  </>;
}
