import { useEffect, useState } from "react";
import { AlertTriangle, ArrowLeft, CheckCircle2, Clock3, FileQuestion, Play, ShieldCheck } from "lucide-react";
import { Link, useLocation, useParams } from "react-router-dom";
import { api } from "../lib/api";
import type { Exam } from "../types";

export default function ExamDetailPage() {
  const { id } = useParams();
  const location = useLocation();
  const [exam, setExam] = useState<Exam | null>(null);
  const [error, setError] = useState("");

  useEffect(() => {
    if (!id) return;
    api.get(`/exams/${id}`)
      .then((response) => setExam(response.data.exam))
      .catch((err) => setError(err.message));
  }, [id]);

  if (error) {
    return (
      <div className="card">
        <div className="alert error">{error}</div>
        <Link className="button secondary" to="/app/exams">
          <ArrowLeft size={16} />
          Back to Exams
        </Link>
      </div>
    );
  }

  if (!exam) return <div className="center-screen">Loading exam details...</div>;

  const availability = exam.availability || {
    can_start: true,
    status: "available",
    message: "Available now"
  };

  return (
    <div className="detail-page">
      <div className="page-header">
        <div>
          <span className="eyebrow">EXAM OVERVIEW</span>
          <h1>{exam.title}</h1>
          <p>{exam.description || "Review the rules below before starting your attempt."}</p>
        </div>
        <Link className="button secondary" to="/app/exams">
          <ArrowLeft size={16} />
          All Exams
        </Link>
      </div>
      {(location.state as any)?.proctoringPaused && <div className="alert error">Exam paused due to a proctoring alert. Awaiting admin review.</div>}

      <div className="grid-2 detail-grid">
        <section className="card">
          <div className="detail-badges">
            <span className={`status-badge ${availability.can_start ? "ok" : "warn"}`}>
              {availability.can_start ? <CheckCircle2 size={14} /> : <AlertTriangle size={14} />}
              {availability.message}
            </span>
            {exam.subject_name && <span className="status-badge neutral">{exam.subject_name}</span>}
          </div>

          <div className="stat-list">
            <div>
              <span>Duration</span>
              <strong>{exam.duration_minutes} minutes</strong>
            </div>
            <div>
              <span>Questions</span>
              <strong>{exam.question_count ?? 0}</strong>
            </div>
            <div>
              <span>Total marks</span>
              <strong>{exam.total_marks}</strong>
            </div>
            <div>
              <span>Passing marks</span>
              <strong>{exam.passing_marks ?? 0}</strong>
            </div>
            <div>
              <span>Attempts used</span>
              <strong>{exam.attempts_used ?? 0} / {exam.attempt_limit ?? 1}</strong>
            </div>
            <div><span>Starts</span><strong>{exam.start_date ? new Date(exam.start_date).toLocaleString() : "Any time"}</strong></div>
            <div><span>Ends</span><strong>{exam.end_date ? new Date(exam.end_date).toLocaleString() : "No deadline"}</strong></div>
            <div><span>Proctoring</span><strong>{exam.proctoring_enabled ? "Enabled" : "Not required"}</strong></div>
            <div><span>Camera</span><strong>{exam.webcam_required ? `Required (${exam.camera_denied_action || "warn"} on denial)` : "Not required"}</strong></div>
          </div>

          <div className="detail-actions">
            <Link
              className={`button${availability.can_start ? "" : " disabled"}`}
              to={availability.can_start ? `/app/quiz/${exam.id}` : "#"}
              onClick={(event) => {
                if (!availability.can_start) event.preventDefault();
              }}
            >
              <Play size={17} />
              Start Exam
            </Link>
          </div>
        </section>

        <section className="card">
          <div className="section-title">
            <h2>
              <ShieldCheck size={18} />
              Instructions
            </h2>
          </div>
          <div className="guide">
            <p>{exam.instructions || "Read each question carefully. Your progress will be autosaved during the attempt."}</p>
            <ul>
              <li className="inline"><Clock3 size={15} /> The timer starts as soon as the exam opens.</li>
              <li className="inline"><FileQuestion size={15} /> You can move between questions and mark items for review.</li>
              <li className="inline"><ShieldCheck size={15} /> Submitting finalizes scoring and locks the attempt.</li>
              {exam.webcam_required && <li className="inline"><ShieldCheck size={15} /> Camera frames are processed locally for face presence/count only; raw video is not uploaded or stored.</li>}
            </ul>
          </div>
        </section>
      </div>
    </div>
  );
}
