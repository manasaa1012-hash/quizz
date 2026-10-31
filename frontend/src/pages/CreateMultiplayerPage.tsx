import { FormEvent, useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { api } from "../lib/api";

const initial = { name: "Study showdown", subject_id: "", topic_id: "", exam_id: "", question_ids: [] as string[], question_count: 10, difficulty: "", question_time_seconds: 30, max_players: 8, is_public: true };

export default function CreateMultiplayerPage() {
  const nav = useNavigate();
  const [form, setForm] = useState(initial);
  const [options, setOptions] = useState<any>({ subjects: [], topics: [], exams: [], questions: [] });
  const [error, setError] = useState("");
  const [submitting, setSubmitting] = useState(false);

  useEffect(() => { api.get("/multiplayer/options").then((response) => setOptions(response.data)).catch((caught) => setError(caught.message)); }, []);

  const questions = options.questions.filter((question: any) => question.subject_id === form.subject_id && (!form.topic_id || question.topic_id === form.topic_id) && (!form.difficulty || question.difficulty === form.difficulty));
  const missing = Math.max(0, form.question_count - form.question_ids.length);
  const manualSelectionError = !form.exam_id && form.subject_id && missing ? `Select ${missing} more matching question${missing === 1 ? "" : "s"}, or reduce the question count.` : "";

  async function submit(event: FormEvent) {
    event.preventDefault();
    setError("");
    if (manualSelectionError) { setError(manualSelectionError); return; }
    setSubmitting(true);
    try {
      const { data } = await api.post("/multiplayer/rooms", { ...form, topic_id: form.topic_id || null, exam_id: form.exam_id || null, difficulty: form.difficulty || null });
      nav(`/app/multiplayer/${data.room.room_code}`);
    } catch (caught) {
      setError(caught instanceof Error ? caught.message : "Unable to create room.");
    } finally { setSubmitting(false); }
  }

  function selectRequestedQuestions() {
    setForm({ ...form, question_ids: questions.slice(0, Math.min(form.question_count, 50)).map((question: any) => question.id) });
    setError("");
  }

  return <>
    <header className="page-header"><div><span className="eyebrow">HOST A GAME</span><h1>Create room</h1><p>Questions come directly from the existing question bank.</p></div></header>
    {error && <div className="alert error">{error}</div>}
    <form className="card form-stack multiplayer-form" onSubmit={submit}>
      <label>Room name<input required value={form.name} onChange={(event) => setForm({ ...form, name: event.target.value })} /></label>
      <div className="form-row">
        <label>Subject<select required value={form.subject_id} onChange={(event) => setForm({ ...form, subject_id: event.target.value, topic_id: "", exam_id: "", question_ids: [] })}><option value="">Select subject</option>{options.subjects.map((subject: any) => <option value={subject.id} key={subject.id}>{subject.name}</option>)}</select></label>
        <label>Topic (optional)<select value={form.topic_id} onChange={(event) => setForm({ ...form, topic_id: event.target.value, question_ids: [] })}><option value="">All topics</option>{options.topics.filter((topic: any) => topic.subject_id === form.subject_id).map((topic: any) => <option value={topic.id} key={topic.id}>{topic.name}</option>)}</select></label>
      </div>
      <label>Question source<select value={form.exam_id} onChange={(event) => setForm({ ...form, exam_id: event.target.value, question_ids: [] })}><option value="">Choose questions manually</option>{options.exams.filter((exam: any) => exam.subject_id === form.subject_id).map((exam: any) => <option value={exam.id} key={exam.id}>{exam.title}</option>)}</select></label>
      <div className="form-row">
        <label>Questions<input type="number" min="1" max="50" value={form.question_count} onChange={(event) => setForm({ ...form, question_count: +event.target.value })} /></label>
        <label>Difficulty<select value={form.difficulty} onChange={(event) => setForm({ ...form, difficulty: event.target.value, question_ids: [] })}><option value="">Mixed</option><option>easy</option><option>medium</option><option>hard</option></select></label>
      </div>
      {!form.exam_id && form.subject_id && <fieldset className="question-picker">
        <legend>Question set ({form.question_ids.length} selected)</legend>
        <div className="question-picker-actions"><button type="button" className="button small secondary" onClick={selectRequestedQuestions} disabled={!questions.length}>Select requested {Math.min(form.question_count, questions.length)}</button><button type="button" className="ghost ghost-link" onClick={() => setForm({ ...form, question_ids: [] })} disabled={!form.question_ids.length}>Clear</button></div>
        {!questions.length && <p className="muted">No questions match these filters.</p>}
        {questions.map((question: any) => <label className="check" key={question.id}><input type="checkbox" disabled={!form.question_ids.includes(question.id) && form.question_ids.length >= 50} checked={form.question_ids.includes(question.id)} onChange={(event) => setForm({ ...form, question_ids: event.target.checked ? [...form.question_ids, question.id] : form.question_ids.filter((id) => id !== question.id) })} /><span>{question.question_text}<small>{question.difficulty}</small></span></label>)}
      </fieldset>}
      {!form.exam_id && form.subject_id && <div className={`selection-summary ${manualSelectionError ? "invalid" : "valid"}`}>{manualSelectionError || `${form.question_count} questions are ready for this room.`}</div>}
      <div className="form-row">
        <label>Seconds per question<input type="number" min="10" max="180" value={form.question_time_seconds} onChange={(event) => setForm({ ...form, question_time_seconds: +event.target.value })} /></label>
        <label>Maximum players<input type="number" min="2" max="50" value={form.max_players} onChange={(event) => setForm({ ...form, max_players: +event.target.value })} /></label>
      </div>
      <label className="check"><input type="checkbox" checked={form.is_public} onChange={(event) => setForm({ ...form, is_public: event.target.checked })} />Show in public room list</label>
      <button className="button" disabled={submitting || !!manualSelectionError}>{submitting ? "Creating…" : "Create lobby"}</button>
    </form>
  </>;
}
