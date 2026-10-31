import { useEffect, useState } from "react";
import { BrainCircuit, Sparkles, TrendingDown, TrendingUp } from "lucide-react";
import { api } from "../lib/api";
import { EmptyState } from "../components/EmptyState";
import { PageHeader } from "../components/PageHeader";
import { ProgressRing } from "../components/ProgressRing";
import { StatusBadge } from "../components/StatusBadge";

export default function PredictionsPage() {
  const [items, setItems] = useState<any[]>([]);
  const [error, setError] = useState("");
  const load = () => api.get("/ai/predictions").then((response) => setItems(response.data.predictions)).catch((caught) => setError(caught.message));

  useEffect(() => { void load(); }, []);

  async function generate() {
    try {
      await api.post("/ai/predictions");
      load();
    } catch (caught: any) {
      setError(caught.message);
    }
  }

  const latest = items[0];
  const riskTone = latest?.risk_level === "Low" ? "ok" : latest?.risk_level === "High" ? "danger" : "warn";

  return <>
    <PageHeader
      eyebrow="PERFORMANCE FORECAST"
      title="Prediction History"
      description="Use your next-score forecast to understand momentum and prioritize study time."
      icon={BrainCircuit}
      action={<button className="button" onClick={generate}><Sparkles size={16} /> Generate prediction</button>}
    />
    {error && <div className="alert error">{error}</div>}

    {latest && <section className="prediction-overview">
      <article className="card prediction-highlight">
        <div>
          <span className="eyebrow">LATEST FORECAST</span>
          <h2>Next exam outlook</h2>
          <p className="muted">Generated {new Date(latest.created_at).toLocaleString()} from your verified learning activity.</p>
          <div className="prediction-meta">
            <StatusBadge tone={riskTone}>{latest.risk_level} risk</StatusBadge>
            <span className="inline muted">{latest.trend === "declining" ? <TrendingDown size={15} /> : <TrendingUp size={15} />}{latest.trend}</span>
          </div>
        </div>
        <ProgressRing value={Number(latest.predicted_score)} label="forecast" caption="Predicted score" tone={latest.risk_level === "Low" ? "success" : "primary"} />
      </article>
      <article className="card forecast-stat"><span>Confidence</span><strong>{Math.round(Number(latest.confidence) * 100)}%</strong><small>Based on available attempt history</small></article>
      <article className="card forecast-stat"><span>Actual next score</span><strong>{latest.actual_score === null ? "Pending" : `${latest.actual_score}%`}</strong><small>{latest.actual_score === null ? "Complete an exam to compare" : `Error: ${latest.prediction_error}`}</small></article>
    </section>}

    <section className="card">
      <div className="section-title"><h2><Sparkles size={18} /> Forecast history</h2><span className="muted">Latest 30 forecasts</span></div>
      {items.length ? <div className="table-wrap"><table className="table"><thead><tr><th>Date</th><th>Predicted</th><th>Actual next score</th><th>Error</th><th>Confidence</th><th>Trend</th><th>Risk</th></tr></thead><tbody>{items.map((item) => <tr key={item.id}><td>{new Date(item.created_at).toLocaleString()}</td><td><strong>{item.predicted_score}%</strong></td><td>{item.actual_score === null ? "Pending" : `${item.actual_score}%`}</td><td>{item.prediction_error === null ? "-" : item.prediction_error}</td><td>{Math.round(item.confidence * 100)}%</td><td><span className="inline">{item.trend === "declining" ? <TrendingDown size={14} /> : <TrendingUp size={14} />}{item.trend}</span></td><td><StatusBadge tone={item.risk_level === "Low" ? "ok" : item.risk_level === "High" ? "danger" : "warn"}>{item.risk_level}</StatusBadge></td></tr>)}</tbody></table></div> : <EmptyState icon={Sparkles} title="No forecast yet" description="Generate a prediction after completing quizzes to compare your expected and actual next score." action={<button className="button small" onClick={generate}>Generate prediction</button>} />}
    </section>
  </>;
}
