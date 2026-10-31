import { useEffect, useState } from "react";
import { BrainCircuit, CheckCircle2, RefreshCw, Target } from "lucide-react";
import { api } from "../lib/api";
import { EmptyState } from "../components/EmptyState";
import { PageHeader } from "../components/PageHeader";
import { StatusBadge } from "../components/StatusBadge";

export default function RecommendationsPage() {
  const [items, setItems] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  async function load() {
    setLoading(true);
    try {
      const response = await api.get("/ai/recommendations");
      const recommendations = response.data.recommendations || [];
      if (!recommendations.length) {
        const generated = await api.post("/ai/recommendations/regenerate");
        setItems(generated.data.recommendations || []);
      } else {
        setItems(recommendations);
      }
      setError("");
    } catch (caught: any) {
      setError(caught.message);
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => { void load(); }, []);

  async function regenerate() {
    setLoading(true);
    try {
      const response = await api.post("/ai/recommendations/regenerate");
      setItems(response.data.recommendations || []);
      setError("");
    } catch (caught: any) {
      setError(caught.message);
    } finally {
      setLoading(false);
    }
  }

  async function update(id: string, status: string) {
    await api.patch(`/ai/recommendations/${id}`, { status });
    void load();
  }

  const activeItems = items.filter((item) => item.status === "active");
  const priorityTone = (priority: string) => priority === "high" ? "danger" : priority === "medium" ? "warn" : "ok" as const;

  return <>
    <PageHeader eyebrow="PERSONALIZED LEARNING" title="AI Coach" icon={BrainCircuit} description="Focused actions based on your latest verified performance and topic accuracy." action={<button className="button" onClick={regenerate} disabled={loading}><RefreshCw size={16} /> Regenerate</button>} />
    {error && <div className="alert error">{error}</div>}
    {loading ? <div className="center-screen"><div className="loading-copy"><BrainCircuit size={22} /> Analyzing your learning activity...</div></div> : <section className="card coach-workspace">
      <div className="section-title"><h2><Target size={18} /> Your priorities</h2><span className="muted">{activeItems.length} active action{activeItems.length === 1 ? "" : "s"}</span></div>
      {activeItems.length ? <div className="recommendation-grid">{activeItems.map((recommendation) => {
        const topic = Array.isArray(recommendation.topics) ? recommendation.topics[0]?.name : recommendation.topics?.name || "General practice";
        return <article className="recommendation-card" key={recommendation.id}>
          <div className="recommendation-card-top"><span className={`priority ${recommendation.priority}`}>{recommendation.priority}</span><StatusBadge tone={priorityTone(recommendation.priority)}>{recommendation.accuracy}% accuracy</StatusBadge></div>
          <h3>{topic}</h3>
          <p>{recommendation.reason}</p>
          <div className="recommendation-action"><Target size={16} /><span><b>Next action</b>{recommendation.recommendation}</span></div>
          <small>Suggested practice: {recommendation.suggested_questions} questions</small>
          <div className="button-row"><button className="button small" onClick={() => update(recommendation.id, "completed")}><CheckCircle2 size={14} /> Mark completed</button><button className="button small secondary" onClick={() => update(recommendation.id, "dismissed")}>Dismiss</button></div>
        </article>;
      })}</div> : <EmptyState icon={BrainCircuit} title="No active recommendations" description="Complete a quiz or adaptive session, then regenerate tailored learning actions." action={<button className="button small" onClick={regenerate}>Generate recommendations</button>} />}
    </section>}
  </>;
}
