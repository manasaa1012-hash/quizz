import { FormEvent, useEffect, useState } from "react";
import { api } from "../lib/api";
import type { Exam, Question, Subject, Topic } from "../types";

const emptyExam = {
  id: "",
  title: "",
  description: "",
  subject_id: "",
  duration_minutes: 30,
  total_marks: 10,
  passing_marks: 4,
  negative_marking: false,
  start_date: "",
  end_date: "",
  status: "draft" as "draft" | "published" | "archived",
  shuffle_questions: false,
  shuffle_options: false,
  allow_review: true,
  proctoring_enabled: false,
  webcam_required: false,
  microphone_required: false,
  camera_denied_action: "warn" as "warn" | "block",
  fullscreen_required: false,
  max_tab_switches: 3,
  attempt_limit: 1,
  instructions: "",
  is_active: true
};

export default function AdminExamsPage() {
  const [exams, setExams] = useState<Exam[]>([]);
  const [subjects, setSubjects] = useState<Subject[]>([]);
  const [questions, setQuestions] = useState<Question[]>([]);
  const [topics, setTopics] = useState<Topic[]>([]);
  const [selectedExam, setSelectedExam] = useState<Exam | null>(null);
  const [selectedQuestionIds, setSelectedQuestionIds] = useState<string[]>([]);
  const [pickerOpen, setPickerOpen] = useState(false);
  const [questionSearch, setQuestionSearch] = useState("");
  const [questionSubject, setQuestionSubject] = useState("");
  const [questionTopic, setQuestionTopic] = useState("");
  const [questionDifficulty, setQuestionDifficulty] = useState("");
  const [form, setForm] = useState(emptyExam);
  const [message, setMessage] = useState("");
  const [error, setError] = useState("");

  async function load() {
    const [examResponse, subjectResponse, questionResponse, topicResponse] = await Promise.all([
      api.get("/admin/exams"),
      api.get("/admin/subjects"),
      api.get("/admin/questions", { params: { page: 1, pageSize: 50 } }),
      api.get("/admin/topics")
    ]);
    setExams(examResponse.data.exams);
    setSubjects(subjectResponse.data.subjects);
    setQuestions(questionResponse.data.questions);
    setTopics(topicResponse.data.topics);
  }

  useEffect(() => {
    load();
  }, []);

  useEffect(() => {
    const timeout = window.setTimeout(() => {
      api.get("/admin/questions", { params: { page: 1, pageSize: 50, search: questionSearch || undefined, subject_id: questionSubject || undefined, topic_id: questionTopic || undefined, difficulty: questionDifficulty || undefined, is_active: true } })
        .then((response) => setQuestions(response.data.questions)).catch((caught) => setError(caught.message));
    }, 250);
    return () => window.clearTimeout(timeout);
  }, [questionSearch, questionSubject, questionTopic, questionDifficulty]);

  async function openExam(examId: string) {
    const response = await api.get(`/admin/exams/${examId}`);
    setSelectedExam(response.data.exam);
  }

  async function submit(event: FormEvent) {
    event.preventDefault();
    try {
      const payload = {
        ...form,
        description: form.description || null,
        subject_id: form.subject_id || null,
        start_date: form.start_date ? new Date(form.start_date).toISOString() : null,
        end_date: form.end_date ? new Date(form.end_date).toISOString() : null,
        instructions: form.instructions || null
      };
      if (form.id) {
        await api.patch(`/admin/exams/${form.id}`, payload);
        setMessage("Exam updated.");
      } else {
        await api.post("/admin/exams", payload);
        setMessage("Exam created.");
      }
      setForm(emptyExam);
      setError("");
      await load();
    } catch (caught: any) {
      setError(caught.message);
    }
  }

  async function edit(examId: string) {
    const response = await api.get(`/admin/exams/${examId}`);
    const exam = response.data.exam;
    setForm({
      id: exam.id,
      title: exam.title,
      description: exam.description || "",
      subject_id: exam.subject_id || "",
      duration_minutes: exam.duration_minutes,
      total_marks: exam.total_marks,
      passing_marks: exam.passing_marks,
      negative_marking: exam.negative_marking,
      start_date: exam.start_date ? exam.start_date.slice(0, 16) : "",
      end_date: exam.end_date ? exam.end_date.slice(0, 16) : "",
      status: exam.status,
      shuffle_questions: exam.shuffle_questions,
      shuffle_options: exam.shuffle_options,
      allow_review: exam.allow_review,
      proctoring_enabled: exam.proctoring_enabled,
      webcam_required: exam.webcam_required,
      microphone_required: exam.microphone_required || false,
      camera_denied_action: exam.camera_denied_action || "warn",
      fullscreen_required: exam.fullscreen_required,
      max_tab_switches: exam.max_tab_switches,
      attempt_limit: exam.attempt_limit,
      instructions: exam.instructions || "",
      is_active: exam.is_active ?? true
    });
  }

  async function duplicate(examId: string) {
    await api.post(`/admin/exams/${examId}/duplicate`);
    setMessage("Exam duplicated.");
    load();
  }

  async function setPublished(exam: Exam, published: boolean) {
    try {
      await api.post(`/admin/exams/${exam.id}/${published ? "publish" : "unpublish"}`);
      setMessage(published ? "Exam published." : "Exam returned to draft.");
      setError("");
      await load();
      if (selectedExam?.id === exam.id) await openExam(exam.id);
    } catch (caught: any) {
      setError(caught.message);
    }
  }

  async function remove(examId: string) {
    if (!confirm("Delete this exam?")) return;
    try {
      await api.delete(`/admin/exams/${examId}`);
      setMessage("Exam deleted.");
      if (selectedExam?.id === examId) setSelectedExam(null);
      load();
    } catch (caught: any) {
      setError(caught.message);
    }
  }

  async function attachQuestions() {
    if (!selectedExam || !selectedQuestionIds.length) return;
    await api.post(`/admin/exams/${selectedExam.id}/questions`, { question_ids: selectedQuestionIds });
    setMessage("Questions added to exam.");
    setSelectedQuestionIds([]);
    await openExam(selectedExam.id);
    await load();
    setPickerOpen(false);
  }

  async function removeQuestion(questionId: string) {
    if (!selectedExam) return;
    await api.delete(`/admin/exams/${selectedExam.id}/questions/${questionId}`);
    setMessage("Question removed from exam.");
    openExam(selectedExam.id);
    load();
  }

  async function moveQuestion(questionId: string, direction: -1 | 1) {
    if (!selectedExam?.questions) return;
    const ids = selectedExam.questions.map((question) => question.id);
    const index = ids.indexOf(questionId);
    const target = index + direction;
    if (index < 0 || target < 0 || target >= ids.length) return;
    const reordered = [...ids];
    [reordered[index], reordered[target]] = [reordered[target], reordered[index]];
    await api.patch(`/admin/exams/${selectedExam.id}/questions/reorder`, { question_ids: reordered });
    openExam(selectedExam.id);
  }

  const attachedIds = new Set(selectedExam?.questions?.map((question) => question.id) || []);
  const availableTopics = topics.filter((topic) => !questionSubject || topic.subject_id === questionSubject);

  async function openQuestionPicker(examId: string) {
    await openExam(examId);
    setSelectedQuestionIds([]);
    setPickerOpen(true);
  }

  return (
    <>
      <div className="page-header">
        <div>
          <span className="eyebrow">CONTENT MANAGEMENT</span>
          <h1>Manage Exams</h1>
          <p>Create exams, control publication, and assemble papers from the question bank.</p>
        </div>
      </div>
      {message && <div className="alert success">{message}</div>}
      {error && <div className="alert error">{error}</div>}
      <div className="grid-2">
        <form className="card form-stack" onSubmit={submit}>
          <h2>{form.id ? "Edit exam" : "Create exam"}</h2>
          <label>Title<input value={form.title} onChange={(event) => setForm({ ...form, title: event.target.value })} required /></label>
          <label>Description<textarea value={form.description} onChange={(event) => setForm({ ...form, description: event.target.value })} /></label>
          <label>Student instructions<textarea value={form.instructions} onChange={(event) => setForm({ ...form, instructions: event.target.value })} /></label>
          <label>Subject<select value={form.subject_id} onChange={(event) => setForm({ ...form, subject_id: event.target.value })}>
            <option value="">No subject</option>
            {subjects.map((subject) => <option key={subject.id} value={subject.id}>{subject.name}</option>)}
          </select></label>
          <div className="form-row">
            <label>Duration<input type="number" min="1" value={form.duration_minutes} onChange={(event) => setForm({ ...form, duration_minutes: Number(event.target.value) })} /></label>
            <label>Total marks<input type="number" min="0" value={form.total_marks} onChange={(event) => setForm({ ...form, total_marks: Number(event.target.value) })} /></label>
          </div>
          <div className="form-row">
            <label>Passing marks<input type="number" min="0" value={form.passing_marks} onChange={(event) => setForm({ ...form, passing_marks: Number(event.target.value) })} /></label>
            <label>Status<select value={form.status} onChange={(event) => setForm({ ...form, status: event.target.value as "draft" | "published" | "archived" })}>
              <option value="draft">draft</option>
              <option value="published">published</option>
              <option value="archived">archived</option>
            </select></label>
          </div>
          <div className="form-row">
            <label>Start date<input type="datetime-local" value={form.start_date} onChange={(event) => setForm({ ...form, start_date: event.target.value })} /></label>
            <label>End date<input type="datetime-local" value={form.end_date} onChange={(event) => setForm({ ...form, end_date: event.target.value })} /></label>
          </div>
          <div className="form-row">
            <label>Attempt limit<input type="number" min="1" value={form.attempt_limit} onChange={(event) => setForm({ ...form, attempt_limit: Number(event.target.value) })} /></label>
            <label>Max tab switches<input type="number" min="0" value={form.max_tab_switches} onChange={(event) => setForm({ ...form, max_tab_switches: Number(event.target.value) })} /></label>
          </div>
          <label className="check"><input type="checkbox" checked={form.negative_marking} onChange={(event) => setForm({ ...form, negative_marking: event.target.checked })} /> Negative marking</label>
          <label className="check"><input type="checkbox" checked={form.shuffle_questions} onChange={(event) => setForm({ ...form, shuffle_questions: event.target.checked })} /> Shuffle questions</label>
          <label className="check"><input type="checkbox" checked={form.shuffle_options} onChange={(event) => setForm({ ...form, shuffle_options: event.target.checked })} /> Shuffle options</label>
          <label className="check"><input type="checkbox" checked={form.allow_review} onChange={(event) => setForm({ ...form, allow_review: event.target.checked })} /> Allow review</label>
          <label className="check"><input type="checkbox" checked={form.proctoring_enabled} onChange={(event) => setForm({ ...form, proctoring_enabled: event.target.checked })} /> Proctoring enabled</label>
          <label className="check"><input type="checkbox" checked={form.webcam_required} onChange={(event) => setForm({ ...form, webcam_required: event.target.checked, proctoring_enabled: event.target.checked || form.proctoring_enabled })} /> Webcam presence/count monitoring required</label>
          <label className="check"><input type="checkbox" checked={form.microphone_required} onChange={(event) => setForm({ ...form, microphone_required: event.target.checked, proctoring_enabled: event.target.checked || form.proctoring_enabled })} /> Microphone access required</label>
          {(form.webcam_required || form.microphone_required) && <label>When device permission is denied<select value={form.camera_denied_action} onChange={(event) => setForm({ ...form, camera_denied_action: event.target.value as "warn" | "block" })}><option value="warn">Warn and allow exam</option><option value="block">Block exam start</option></select></label>}
          <label className="check"><input type="checkbox" checked={form.fullscreen_required} onChange={(event) => setForm({ ...form, fullscreen_required: event.target.checked })} /> Fullscreen required</label>
          <label className="check"><input type="checkbox" checked={form.is_active} onChange={(event) => setForm({ ...form, is_active: event.target.checked })} /> Exam active</label>
          <div className="button-row">
            <button className="button">{form.id ? "Update exam" : "Create exam"}</button>
            {form.id && <button className="button secondary" type="button" onClick={() => setForm(emptyExam)}>Cancel edit</button>}
          </div>
        </form>

        <section className="card form-stack">
          <h2>Existing exams</h2>
          <div className="stack-list">
            {exams.map((exam) => (
              <div className="list-row card-lite" key={exam.id}>
                <div>
                  <strong>{exam.title}</strong>
                  <small>{exam.status} • {exam.question_count || 0} questions</small>
                </div>
                <div className="button-row">
                  <button className="button small secondary" onClick={() => openExam(exam.id)}>Preview</button>
                  <button className="button small" onClick={() => void openQuestionPicker(exam.id)}>Add Questions</button>
                  <button className="button small secondary" onClick={() => edit(exam.id)}>Edit</button>
                  <button className="button small secondary" onClick={() => duplicate(exam.id)}>Duplicate</button>
                  <button className="button small secondary" onClick={() => setPublished(exam, exam.status !== "published")}>
                    {exam.status === "published" ? "Unpublish" : "Publish"}
                  </button>
                  <button className="button small danger" onClick={() => remove(exam.id)}>Delete</button>
                </div>
              </div>
            ))}
          </div>
        </section>
      </div>

      {selectedExam && !pickerOpen && (
        <div className="grid-2">
          <section className="card form-stack">
            <h2>{selectedExam.title}</h2>
            <p className="muted">{selectedExam.description || "No description provided."}</p>
            <div className="stack-list">
              {(selectedExam.questions || []).map((question, index) => (
                <div className="list-row card-lite" key={question.id}>
                  <div>
                    <strong>{index + 1}. {question.question_text}</strong>
                    <small>{question.difficulty} • {question.marks} mark(s)</small>
                  </div>
                  <div className="button-row">
                    <button className="button small secondary" onClick={() => moveQuestion(question.id, -1)}>Up</button>
                    <button className="button small secondary" onClick={() => moveQuestion(question.id, 1)}>Down</button>
                    <button className="button small danger" onClick={() => removeQuestion(question.id)}>Remove</button>
                  </div>
                </div>
              ))}
            </div>
          </section>

          <section className="card form-stack"><h2>Question assignment</h2><p className="muted">Use the Add Questions action to search the bank and assign multiple questions without removing them from the main bank.</p><button className="button" onClick={() => void openQuestionPicker(selectedExam.id)}>Add Questions</button></section>
        </div>
      )}
      {pickerOpen && selectedExam && <div className="modal-backdrop" role="presentation"><section className="card modal-card question-picker" role="dialog" aria-modal="true" aria-label="Add questions to exam"><div className="section-title"><div><h2>Add questions to {selectedExam.title}</h2><p className="muted">{selectedExam.question_count || 0} assigned · {selectedQuestionIds.length} selected</p></div><button className="button small secondary" onClick={() => setPickerOpen(false)}>Close</button></div><div className="filter-bar"><label>Search<input value={questionSearch} onChange={event => setQuestionSearch(event.target.value)} placeholder="Search question text" /></label><label>Subject<select value={questionSubject} onChange={event => { setQuestionSubject(event.target.value); setQuestionTopic(""); }}><option value="">All subjects</option>{subjects.map(subject => <option key={subject.id} value={subject.id}>{subject.name}</option>)}</select></label><label>Topic<select value={questionTopic} onChange={event => setQuestionTopic(event.target.value)}><option value="">All topics</option>{availableTopics.map(topic => <option key={topic.id} value={topic.id}>{topic.name}</option>)}</select></label><label>Difficulty<select value={questionDifficulty} onChange={event => setQuestionDifficulty(event.target.value)}><option value="">All levels</option><option value="easy">Easy</option><option value="medium">Medium</option><option value="hard">Hard</option></select></label></div><div className="stack-list selectable-list question-picker-list">{questions.filter(question => !attachedIds.has(question.id)).map(question => <label className="check card-lite" key={question.id}><input type="checkbox" checked={selectedQuestionIds.includes(question.id)} onChange={event => setSelectedQuestionIds(current => event.target.checked ? [...current, question.id] : current.filter(id => id !== question.id))}/><span><b>{question.question_text}</b><small>{question.difficulty} · {question.marks} mark(s)</small></span></label>)}{!questions.filter(question => !attachedIds.has(question.id)).length && <div className="empty">No unassigned questions match these filters.</div>}</div><div className="button-row"><button className="button" onClick={() => void attachQuestions()} disabled={!selectedQuestionIds.length}>Add Selected Questions ({selectedQuestionIds.length})</button><button className="button secondary" onClick={() => setPickerOpen(false)}>Cancel</button></div></section></div>}
    </>
  );
}
