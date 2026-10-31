import { useEffect, useState } from "react";
import { CalendarDays, CheckCircle2, CircleDashed, SkipForward } from "lucide-react";
import { api } from "../lib/api";
import { EmptyState } from "../components/EmptyState";
import { PageHeader } from "../components/PageHeader";
import { StatusBadge } from "../components/StatusBadge";

export default function RevisionPlanPage() {
  const [data, setData] = useState<any>(null);
  const [days, setDays] = useState<7 | 14 | 30>(7);
  const [error, setError] = useState("");
  const load = () => api.get("/ai/revision-plan").then((response) => setData(response.data)).catch((caught) => setError(caught.message));

  useEffect(() => { void load(); }, []);

  async function generate() {
    try {
      const response = await api.post("/ai/revision-plan", { days });
      setData(response.data);
    } catch (caught: any) {
      setError(caught.message);
    }
  }

  async function patch(id: string, body: any) {
    await api.patch(`/ai/revision-plan/tasks/${id}`, body);
    load();
  }

  const tasks = data?.tasks || [];
  const toneFor = (status: string) => status === "completed" ? "ok" : status === "skipped" ? "warn" : "neutral" as const;
  const IconFor = (status: string) => status === "completed" ? CheckCircle2 : status === "skipped" ? SkipForward : CircleDashed;

  return <>
    <PageHeader eyebrow="STUDY SCHEDULE" title="Revision Plan" icon={CalendarDays} description="A focused day-by-day plan built from your weakest topics and completed learning activity." action={<div className="plan-header-actions"><select value={days} onChange={(event) => setDays(Number(event.target.value) as 7 | 14 | 30)}><option value={7}>7 days</option><option value={14}>14 days</option><option value={30}>30 days</option></select><button className="button" onClick={generate}>Generate plan</button></div>} />
    {error && <div className="alert error">{error}</div>}
    <section className="card revision-plan-card">
      <div className="section-title"><h2><CalendarDays size={18} /> Plan progress</h2><strong>{data?.completion_percentage ?? 0}% complete</strong></div>
      <div className="progress"><span style={{ width: `${data?.completion_percentage ?? 0}%` }} /></div>
      {tasks.length ? <div className="revision-timeline">{tasks.map((task: any) => {
        const topic = Array.isArray(task.topics) ? task.topics[0]?.name : task.topics?.name || "Mixed revision";
        const Icon = IconFor(task.status);
        return <article className="revision-task" key={task.id}><span className="revision-day">Day {task.day_number}</span><div className="revision-task-main"><div className="list-row"><div><strong>{topic}</strong><small>{new Date(`${task.scheduled_date}T00:00:00`).toLocaleDateString()} · {task.target_questions} questions</small></div><StatusBadge tone={toneFor(task.status)} icon={Icon}>{task.status}</StatusBadge></div><p>{task.activity}</p><div className="button-row"><button className="button small" onClick={() => patch(task.id, { status: "completed" })}>Complete</button><button className="button small secondary" onClick={() => patch(task.id, { status: "skipped" })}>Skip</button><label className="revision-date">Reschedule<input type="date" value={task.scheduled_date} onChange={(event) => patch(task.id, { scheduled_date: event.target.value, status: "pending" })} /></label></div></div></article>;
      })}</div> : <EmptyState icon={CalendarDays} title="No revision plan yet" description="Generate a plan to create saved daily tasks based on your learning performance." action={<button className="button small" onClick={generate}>Generate plan</button>} />}
    </section>
  </>;
}
