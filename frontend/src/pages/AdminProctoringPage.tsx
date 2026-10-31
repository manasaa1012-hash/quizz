import { FormEvent, useEffect, useState } from "react";
import { Link } from "react-router-dom";
import { api } from "../lib/api";
import { supabase } from "../lib/supabase";

const levels = ["Low", "Moderate", "Suspicious", "High Risk"];
const count = (report: any, ...keys: string[]) => keys.reduce((sum, key) => sum + Number(report.event_counts?.[key] || 0), 0);

export default function AdminProctoringPage() {
  const [reports, setReports] = useState<any[]>([]);
  const [exams, setExams] = useState<any[]>([]);
  const [users, setUsers] = useState<any[]>([]);
  const [filters, setFilters] = useState({ exam_id: "", user_id: "", risk_level: "", date_from: "", date_to: "" });
  const [page, setPage] = useState(1);
  const [totalPages, setTotalPages] = useState(1);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  async function load(nextPage = page) {
    setLoading(true); setError("");
    try {
      const params: any = { page: nextPage, pageSize: 20 };
      Object.entries(filters).forEach(([key, value]) => { if (value) params[key] = key.startsWith("date_") ? new Date(key === "date_to" ? `${value}T23:59:59.999` : `${value}T00:00:00`).toISOString() : value; });
      const response = await api.get("/proctoring/reports", { params });
      setReports(response.data.reports); setTotalPages(Math.max(1, response.data.pagination.totalPages)); setPage(nextPage);
    } catch (caught: any) { setError(caught.message); }
    finally { setLoading(false); }
  }

  useEffect(() => {
    Promise.all([api.get("/admin/exams"), api.get("/admin/users")]).then(([examResponse, userResponse]) => {
      setExams(examResponse.data.exams); setUsers(userResponse.data.users);
    }).catch(() => undefined);
    void load(1);
  }, []);

  useEffect(() => {
    const channel = supabase.channel("admin-proctoring-alerts").on("postgres_changes", { event: "*", schema: "public", table: "proctoring_reports" }, () => void load(1)).subscribe();
    return () => { void supabase.removeChannel(channel); };
  }, []);

  function apply(event: FormEvent) { event.preventDefault(); void load(1); }
  return <>
    <div className="page-header"><div><span className="eyebrow">EXAM INTEGRITY</span><h1>Proctoring Reports</h1><p>Review server-calculated risk summaries and event evidence.</p></div></div>
    <form className="card filter-grid" onSubmit={apply}>
      <label>Exam<select value={filters.exam_id} onChange={e => setFilters({ ...filters, exam_id: e.target.value })}><option value="">All exams</option>{exams.map(x => <option key={x.id} value={x.id}>{x.title}</option>)}</select></label>
      <label>Student<select value={filters.user_id} onChange={e => setFilters({ ...filters, user_id: e.target.value })}><option value="">All students</option>{users.filter(x => x.role === "student").map(x => <option key={x.id} value={x.id}>{x.full_name}</option>)}</select></label>
      <label>Risk level<select value={filters.risk_level} onChange={e => setFilters({ ...filters, risk_level: e.target.value })}><option value="">All levels</option>{levels.map(x => <option key={x}>{x}</option>)}</select></label>
      <label>From<input type="date" value={filters.date_from} onChange={e => setFilters({ ...filters, date_from: e.target.value })} /></label>
      <label>To<input type="date" value={filters.date_to} onChange={e => setFilters({ ...filters, date_to: e.target.value })} /></label>
      <button className="button">Apply filters</button>
    </form>
    {error && <div className="alert error">{error}</div>}
    <section className="card"><div className="table-wrap"><table className="table"><thead><tr><th>Exam</th><th>Student</th><th>Violation</th><th>Status</th><th>Risk</th><th>Level</th><th>Head turns</th><th>Tab switches</th><th>Face alerts</th><th>Date</th></tr></thead><tbody>{reports.map(report => <tr key={report.attempt_id}><td><Link to={`/admin/proctoring/${report.attempt_id}`}>{report.exams?.title || "Exam"}</Link></td><td>{report.profiles?.full_name || report.profiles?.email || "Student"}</td><td>{report.exam_attempts?.paused_reason || "Monitored events"}</td><td>{report.exam_attempts?.status || "—"}</td><td>{report.risk_score}</td><td><span className={`status-badge ${report.risk_level === "Low" ? "ok" : "warn"}`}>{report.risk_level}</span></td><td>{count(report, "head_turn_sustained")}</td><td>{count(report, "tab_switch")}</td><td>{count(report, "face_missing", "multiple_faces")}</td><td>{new Date(report.calculated_at).toLocaleString()}</td></tr>)}</tbody></table></div>{loading && <div className="empty">Loading reports...</div>}{!loading && !reports.length && <div className="empty">No proctoring reports match these filters.</div>}<div className="pagination"><button className="button secondary" disabled={page <= 1} onClick={() => void load(page - 1)}>Previous</button><span>Page {page} of {totalPages}</span><button className="button secondary" disabled={page >= totalPages} onClick={() => void load(page + 1)}>Next</button></div></section>
  </>;
}
