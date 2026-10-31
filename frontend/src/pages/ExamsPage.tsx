import { useEffect, useState } from "react";
import { ArrowRight, Clock3, FileQuestion, Play, ShieldCheck } from "lucide-react";
import { Link } from "react-router-dom";
import { api } from "../lib/api";
import type { Exam } from "../types";

export default function ExamsPage() {
  const [exams, setExams] = useState<Exam[]>([]);
  const [error, setError] = useState("");

  useEffect(() => {
    api.get("/exams")
      .then(r => setExams(r.data.exams))
      .catch(e => setError(e.message));
  }, []);

  return (
    <>
      <div className="page-header">
        <div><span className="eyebrow">ASSESSMENTS</span><h1>Available Exams</h1><p>Select an exam and test your knowledge.</p></div>
      </div>
      {error && <div className="alert error">{error}</div>}
      <div className="exam-grid">
        {exams.map(exam => (
          <article className="card exam-card" key={exam.id}>
            <div className="exam-icon exam-brand-mark" aria-label="QuizAI exam">
              <span className="exam-brand-letter">Q</span>
              <span className="exam-brand-ai">AI</span>
            </div>
            {exam.subject_name && <span className="eyebrow">{exam.subject_name}</span>}
            <h2>{exam.title}</h2>
            <p>{exam.description || "Online assessment"}</p>
            <div className="exam-meta">
              <span><Clock3 size={16}/>{exam.duration_minutes} min</span>
              <span><FileQuestion size={16}/>{exam.question_count ?? 0} questions</span>
            </div>
            <div className="exam-facts">
              <span>Total marks: <b>{exam.total_marks}</b></span>
              <span>Passing marks: <b>{exam.passing_marks ?? 0}</b></span>
              <span>Attempts: <b>{exam.attempts_used ?? 0}/{exam.attempt_limit ?? 1}</b></span>
              <span>Proctoring: <b>{exam.proctoring_enabled ? "Enabled" : "Not required"}</b></span>
              <span>Starts: <b>{exam.start_date ? new Date(exam.start_date).toLocaleString() : "Any time"}</b></span>
              <span>Ends: <b>{exam.end_date ? new Date(exam.end_date).toLocaleString() : "No deadline"}</b></span>
            </div>
            <div className="exam-status-row">
              <span className={`status-badge ${exam.availability?.can_start ? "ok" : "warn"}`}>
                <ShieldCheck size={14} />
                {exam.availability?.message || "Available"}
              </span>
            </div>
            <div className="exam-actions">
              <Link className="button secondary full" to={`/app/exams/${exam.id}`}>
                Details <ArrowRight size={16} />
              </Link>
              <Link
                className={`button full${exam.availability?.can_start === false ? " disabled" : ""}`}
                to={exam.availability?.can_start === false ? "#" : `/app/quiz/${exam.id}`}
                onClick={(event) => {
                  if (exam.availability?.can_start === false) event.preventDefault();
                }}
              >
                <Play size={17}/> Start Exam
              </Link>
            </div>
          </article>
        ))}
        {!error && exams.length === 0 && <div className="empty card">No published exams are available.</div>}
      </div>
    </>
  );
}
