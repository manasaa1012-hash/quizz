import { useEffect, useState } from "react";
import { CalendarDays, ExternalLink, Filter, Trophy } from "lucide-react";
import { Link } from "react-router-dom";
import { api } from "../lib/api";
import type { AttemptHistoryItem, Subject } from "../types";

type AttemptResponse = {
  attempts: AttemptHistoryItem[];
  subjects: Subject[];
  pagination: {
    page: number;
    pageSize: number;
    total: number;
    totalPages: number;
  };
};

function formatDuration(totalSeconds?: number) {
  if (!totalSeconds) return "0m";
  const hours = Math.floor(totalSeconds / 3600);
  const minutes = Math.floor((totalSeconds % 3600) / 60);
  if (hours > 0) return `${hours}h ${minutes}m`;
  return `${minutes}m`;
}

export default function AttemptsPage() {
  const [data, setData] = useState<AttemptResponse | null>(null);
  const [filters, setFilters] = useState({ result: "", subject_id: "", date_from: "", date_to: "", min_score: "", max_score: "" });
  const [page, setPage] = useState(1);
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    setLoading(true);
    api.get("/attempts", { params: { page, pageSize: 8, ...Object.fromEntries(Object.entries(filters).filter(([, value]) => value)) } })
      .then((response) => {
        setData(response.data);
        setError("");
      })
      .catch((err) => setError(err.message))
      .finally(() => setLoading(false));
  }, [filters, page]);

  function updateFilter(name: keyof typeof filters, value: string) {
    setPage(1);
    setFilters((current) => ({ ...current, [name]: value }));
  }

  return (
    <>
      <div className="page-header">
        <div>
          <span className="eyebrow">ATTEMPT HISTORY</span>
          <h1>Completed Exams</h1>
          <p>Review previous attempts, results, and time spent.</p>
        </div>
      </div>

      <section className="card">
        <div className="attempt-filters">
          <div className="inline muted">
            <Filter size={16} />
            Filter attempts
          </div>
          <label>Subject<select value={filters.subject_id} onChange={(event) => updateFilter("subject_id", event.target.value)}>
            <option value="">All subjects</option>
            {(data?.subjects || []).map((subject) => <option key={subject.id} value={subject.id}>{subject.name}</option>)}
          </select></label>
          <label>Result<select value={filters.result} onChange={(event) => updateFilter("result", event.target.value)}>
            <option value="">All attempts</option>
            <option value="pass">Pass</option>
            <option value="fail">Fail</option>
          </select></label>
          <label>From<input type="date" value={filters.date_from} onChange={(event) => updateFilter("date_from", event.target.value)} /></label>
          <label>To<input type="date" value={filters.date_to} onChange={(event) => updateFilter("date_to", event.target.value)} /></label>
          <label>Minimum %<input type="number" min="0" max="100" value={filters.min_score} onChange={(event) => updateFilter("min_score", event.target.value)} /></label>
          <label>Maximum %<input type="number" min="0" max="100" value={filters.max_score} onChange={(event) => updateFilter("max_score", event.target.value)} /></label>
          <button className="button secondary" onClick={() => { setFilters({ result: "", subject_id: "", date_from: "", date_to: "", min_score: "", max_score: "" }); setPage(1); }}>Clear filters</button>
        </div>

        {error && <div className="alert error">{error}</div>}

        {loading && <div className="empty">Loading attempts...</div>}
        {!loading && !error && !data?.attempts.length && (
          <div className="empty">No submitted attempts yet. Complete an exam to see it here.</div>
        )}

        <div className="stack-list">
          {(data?.attempts || []).map((attempt) => (
            <article className="card-lite attempt-history-card" key={attempt.id}>
              <div className="list-row">
                <div>
                  <strong>{attempt.exam_title}</strong>
                  <small>{attempt.subject_name || "General"} • {new Date(attempt.submitted_at || attempt.started_at).toLocaleString()}</small>
                </div>
                <span className={`status-badge ${attempt.pass_fail === "Pass" ? "ok" : "danger"}`}>
                  <Trophy size={14} />
                  {attempt.pass_fail}
                </span>
              </div>
              <div className="attempt-history-meta">
                <span><CalendarDays size={15} /> {formatDuration(attempt.total_time_seconds)}</span>
                <span>Score: {Math.round(attempt.score)}</span>
                <span>Percentage: {Math.round(attempt.percentage)}%</span>
              </div>
              <div className="actions-cell">
                <Link className="button secondary small" to={`/app/result/${attempt.id}`}>
                  <ExternalLink size={15} />
                  View Review
                </Link>
              </div>
            </article>
          ))}
        </div>
        {!!data?.pagination.totalPages && data.pagination.totalPages > 1 && (
          <div className="pagination-bar">
            <button className="button small secondary" disabled={page <= 1 || loading} onClick={() => setPage((value) => value - 1)}>Previous</button>
            <span>Page {data.pagination.page} of {data.pagination.totalPages} · {data.pagination.total} attempts</span>
            <button className="button small secondary" disabled={page >= data.pagination.totalPages || loading} onClick={() => setPage((value) => value + 1)}>Next</button>
          </div>
        )}
      </section>
    </>
  );
}
