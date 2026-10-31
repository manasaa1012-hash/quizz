import { CheckCircle2, Clock3, Home, RotateCcw, Trophy, XCircle } from "lucide-react";
import { Link, useLocation, useParams } from "react-router-dom";
import { useEffect, useState } from "react";
import { api } from "../lib/api";

type ResultQuestion = {
  question_id: string;
  display_order: number;
  question_text: string;
  question_image_url?: string | null;
  options: string[];
  option_images?: (string | null)[] | null;
  selected_answer: number | null;
  selected_answer_text?: string | null;
  correct_answer: number;
  correct_answer_text?: string | null;
  is_correct: boolean;
  explanation?: string | null;
  marks_awarded: number;
  response_time_seconds: number;
  marked_for_review: boolean;
};

type ResultPayload = {
  attempt_id: string;
  exam_id?: string;
  exam_title?: string;
  score: number;
  total_marks: number;
  percentage: number;
  pass_fail?: "Pass" | "Fail";
  passed?: boolean;
  correct_count: number;
  incorrect_count: number;
  unanswered_count: number;
  accuracy?: number;
  total_time_seconds?: number;
  average_response_time_seconds?: number;
  marks_gained?: number;
  negative_marks_obtained?: number;
  xp_earned?: number;
  questions?: ResultQuestion[];
};

function formatDuration(totalSeconds?: number) {
  if (!totalSeconds) return "0m";
  const minutes = Math.floor(totalSeconds / 60);
  const seconds = totalSeconds % 60;
  return `${minutes}m ${seconds}s`;
}

export default function ResultPage() {
  const { attemptId } = useParams();
  const location = useLocation();
  const [result, setResult] = useState<ResultPayload | null>(location.state || null);
  const [error, setError] = useState("");

  useEffect(() => {
    if (attemptId) {
      api.get(`/results/${attemptId}`)
        .then((response) => setResult(response.data.result))
        .catch((caught) => setError(caught.message));
    }
  }, [attemptId]);

  if (error) return <div className="center-screen"><div className="card form-stack"><div className="alert error">{error}</div><Link className="button secondary" to="/app/attempts">Back to attempts</Link></div></div>;
  if (!result) return <div className="center-screen">Loading result...</div>;

  return (
    <div className="result-page">
      <div className="result-wrap">
        <div className={`result-hero card ${result.passed ? "passed" : "failed"}`}>
          <Trophy size={42} />
          <span className="eyebrow">{result.passed ? "OUTSTANDING PERFORMANCE" : "KEEP LEARNING"}</span>
          <h1>{Math.round(result.percentage)}%</h1>
          <p>{result.exam_title || "Exam"} • You scored {result.score} out of {result.total_marks} marks.</p>
          <div className="detail-badges result-badges">
            <span className={`status-badge ${result.passed ? "ok" : "danger"}`}>
              {result.pass_fail || (result.passed ? "Pass" : "Fail")}
            </span>
            <span className="status-badge neutral">
              <Clock3 size={14} />
              {formatDuration(result.total_time_seconds)}
            </span>
          </div>
          <div className="result-stats">
            <div><CheckCircle2 /><strong>{result.correct_count}</strong><span>Correct</span></div>
            <div><XCircle /><strong>{result.incorrect_count}</strong><span>Incorrect</span></div>
            <div><RotateCcw /><strong>{result.unanswered_count}</strong><span>Unanswered</span></div>
            <div><Trophy /><strong>+{result.xp_earned ?? 0}</strong><span>XP earned</span></div>
          </div>
          <div className="stat-list result-details">
            <div><span>Accuracy</span><strong>{Math.round(result.accuracy ?? 0)}%</strong></div>
            <div><span>Average response</span><strong>{formatDuration(result.average_response_time_seconds)}</strong></div>
            <div><span>Marks gained</span><strong>{result.marks_gained ?? 0}</strong></div>
            <div><span>Negative marks</span><strong>{result.negative_marks_obtained ?? 0}</strong></div>
          </div>
          <div className="hero-actions">
            <Link className="button" to="/app/attempts">View History</Link>
            <Link className="button secondary" to="/app"><Home size={17} />Dashboard</Link>
          </div>
        </div>
      </div>

      <section className="card">
        <div className="section-title">
          <h2>Question Review</h2>
          <span className="muted">{result.questions?.length ?? 0} questions</span>
        </div>

        {!result.questions?.length ? (
          <div className="empty">Detailed review is not available for this attempt.</div>
        ) : (
          <div className="stack-list">
            {result.questions.map((question, index) => (
              <article className="card-lite review-card" key={question.question_id}>
                <div className="list-row">
                  <div>
                    <strong>Question {question.display_order || index + 1}</strong>
                    <small>{formatDuration(question.response_time_seconds)} spent</small>
                  </div>
                  <span className={`status-badge ${question.is_correct ? "ok" : question.selected_answer === null ? "warn" : "danger"}`}>
                    {question.is_correct ? "Correct" : question.selected_answer === null ? "Unanswered" : "Incorrect"}
                  </span>
                </div>
                <p>{question.question_text}</p>
                {question.question_image_url && (
                  <img className="media-preview" src={question.question_image_url} alt="Question" />
                )}
                <div className="review-options">
                  {question.options.map((option, optionIndex) => {
                    const classes = [
                      "review-option",
                      question.correct_answer === optionIndex ? "correct" : "",
                      question.selected_answer === optionIndex && question.correct_answer !== optionIndex ? "wrong" : ""
                    ].filter(Boolean).join(" ");
                    return (
                      <div className={classes} key={optionIndex}>
                        <strong>{String.fromCharCode(65 + optionIndex)}</strong>
                        <span className="option-content">
                          {option}
                          {question.option_images?.[optionIndex] && <img src={question.option_images[optionIndex] || ""} alt={`Option ${String.fromCharCode(65 + optionIndex)}`} />}
                        </span>
                      </div>
                    );
                  })}
                </div>
                <div className="review-meta">
                  <span>Your answer: {question.selected_answer_text || "Not answered"}</span>
                  <span>Correct answer: {question.correct_answer_text || "N/A"}</span>
                  <span>Marks: {question.marks_awarded}</span>
                  {question.marked_for_review && <span>Marked for review</span>}
                </div>
                {question.explanation && <p className="muted">Explanation: {question.explanation}</p>}
              </article>
            ))}
          </div>
        )}
      </section>
    </div>
  );
}
