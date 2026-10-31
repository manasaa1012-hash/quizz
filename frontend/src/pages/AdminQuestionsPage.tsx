import { ChangeEvent, FormEvent, useEffect, useState } from "react";
import { api } from "../lib/api";
import { supabase } from "../lib/supabase";
import type { Question, Subject, Topic } from "../types";

const emptyForm = {
  id: "",
  subject_id: "",
  topic_id: "",
  question_text: "",
  question_image_url: "",
  options: ["", "", "", ""],
  correct_answer: 0,
  difficulty: "medium" as "easy" | "medium" | "hard",
  marks: 1,
  negative_marks: 0,
  explanation: "",
  is_active: true
};

export default function AdminQuestionsPage() {
  const [preview, setPreview] = useState<Question | null>(null);
  const [questions, setQuestions] = useState<Question[]>([]);
  const [subjects, setSubjects] = useState<Subject[]>([]);
  const [topics, setTopics] = useState<Topic[]>([]);
  const [filters, setFilters] = useState({ search: "", subject_id: "", topic_id: "", difficulty: "" });
  const [form, setForm] = useState(emptyForm);
  const [page, setPage] = useState(1);
  const [totalPages, setTotalPages] = useState(1);
  const [message, setMessage] = useState("");
  const [error, setError] = useState("");
  const [saving, setSaving] = useState(false);

  async function load(nextPage = page) {
    const [questionResponse, subjectResponse, topicResponse] = await Promise.all([
      api.get("/admin/questions", {
        params: {
          page: nextPage,
          pageSize: 20,
          ...(filters.search ? { search: filters.search } : {}),
          ...(filters.subject_id ? { subject_id: filters.subject_id } : {}),
          ...(filters.topic_id ? { topic_id: filters.topic_id } : {}),
          ...(filters.difficulty ? { difficulty: filters.difficulty } : {})
        }
      }),
      api.get("/admin/subjects"),
      api.get("/admin/topics")
    ]);
    setQuestions(questionResponse.data.questions);
    setTotalPages(questionResponse.data.pagination.totalPages || 1);
    setSubjects(subjectResponse.data.subjects);
    setTopics(topicResponse.data.topics);
    setPage(nextPage);
  }

  useEffect(() => {
    load(1);
  }, []);

  function updateOption(index: number, value: string) {
    const nextOptions = [...form.options];
    nextOptions[index] = value;
    setForm({ ...form, options: nextOptions });
  }

  async function uploadImage(event: ChangeEvent<HTMLInputElement>) {
    const file = event.target.files?.[0];
    if (!file) return;
    const extension = file.name.split(".").pop() || "png";
    const { data: sessionData } = await supabase.auth.getSession();
    const userId = sessionData.session?.user.id;
    if (!userId) {
      setError("Your session has expired. Sign in again.");
      return;
    }
    const path = `${userId}/${crypto.randomUUID()}.${extension}`;
    const { error: uploadError } = await supabase.storage.from("question-media").upload(path, file, {
      cacheControl: "3600",
      upsert: true
    });
    if (uploadError) {
      setError(uploadError.message);
      return;
    }
    const { data } = supabase.storage.from("question-media").getPublicUrl(path);
    setForm({ ...form, question_image_url: data.publicUrl });
    setMessage("Image uploaded. Save the question to persist it.");
  }

  async function submit(event: FormEvent) {
    event.preventDefault();
    setSaving(true);
    setError("");
    setMessage("");
    try {
      const payload = {
        subject_id: form.subject_id,
        topic_id: form.topic_id || null,
        question_text: form.question_text,
        question_image_url: form.question_image_url || null,
        options: form.options,
        correct_answer: Number(form.correct_answer),
        difficulty: form.difficulty,
        marks: Number(form.marks),
        negative_marks: Number(form.negative_marks),
        explanation: form.explanation || null,
        is_active: form.is_active
      };
      if (form.id) {
        await api.patch(`/admin/questions/${form.id}`, payload);
        setMessage("Question updated.");
      } else {
        await api.post("/admin/questions", payload);
        setMessage("Question created.");
      }
      setForm(emptyForm);
      await load(1);
    } catch (caught: any) {
      setError(caught.message);
    } finally {
      setSaving(false);
    }
  }

  async function edit(questionId: string) {
    try {
      const response = await api.get(`/admin/questions/${questionId}`);
      const question = response.data.question;
      setForm({
        id: question.id,
        subject_id: question.subject_id,
        topic_id: question.topic_id || "",
        question_text: question.question_text,
        question_image_url: question.question_image_url || "",
        options: question.options,
        correct_answer: question.correct_answer ?? 0,
        difficulty: question.difficulty,
        marks: question.marks,
        negative_marks: question.negative_marks,
        explanation: question.explanation || "",
        is_active: question.is_active ?? true
      });
    } catch (caught: any) {
      setError(caught.message);
    }
  }

  async function remove(question: Question) {
    if (!confirm("Delete this question?")) return;
    try {
      await api.delete(`/admin/questions/${question.id}`);
      setMessage("Question deleted.");
      load(page);
    } catch (caught: any) {
      setError(caught.message);
    }
  }

  const filteredTopics = topics.filter((topic) => !form.subject_id || topic.subject_id === form.subject_id);
  const subjectMap = new Map(subjects.map((subject) => [subject.id, subject.name]));
  const topicMap = new Map(topics.map((topic) => [topic.id, topic.name]));

  return (
    <>
      <div className="page-header">
        <div>
          <span className="eyebrow">QUESTION BANK</span>
          <h1>Questions</h1>
          <p>Create, filter, preview, and maintain reusable MCQs.</p>
        </div>
      </div>
      {message && <div className="alert success">{message}</div>}
      {error && <div className="alert error">{error}</div>}
      <div className="grid-2">
        <form className="card form-stack" onSubmit={submit}>
          <h2>{form.id ? "Edit question" : "Create question"}</h2>
          <label>Subject<select value={form.subject_id} onChange={(event) => setForm({ ...form, subject_id: event.target.value, topic_id: "" })} required>
            <option value="">Select subject</option>
            {subjects.map((subject) => <option key={subject.id} value={subject.id}>{subject.name}</option>)}
          </select></label>
          <label>Topic<select value={form.topic_id} onChange={(event) => setForm({ ...form, topic_id: event.target.value })}>
            <option value="">No topic</option>
            {filteredTopics.map((topic) => <option key={topic.id} value={topic.id}>{topic.name}</option>)}
          </select></label>
          <label>Question<textarea value={form.question_text} onChange={(event) => setForm({ ...form, question_text: event.target.value })} required /></label>
          <label>Question image<input type="file" accept="image/png,image/jpeg,image/webp" onChange={uploadImage} /></label>
          {form.question_image_url && <img className="media-preview" src={form.question_image_url} alt="Question" />}
          {form.options.map((option, index) => (
            <label key={index}>Option {String.fromCharCode(65 + index)}
              <input value={option} onChange={(event) => updateOption(index, event.target.value)} required />
            </label>
          ))}
          <div className="form-row">
            <label>Correct option<select value={form.correct_answer} onChange={(event) => setForm({ ...form, correct_answer: Number(event.target.value) })}>
              <option value={0}>A</option>
              <option value={1}>B</option>
              <option value={2}>C</option>
              <option value={3}>D</option>
            </select></label>
            <label>Difficulty<select value={form.difficulty} onChange={(event) => setForm({ ...form, difficulty: event.target.value as "easy" | "medium" | "hard" })}>
              <option value="easy">easy</option>
              <option value="medium">medium</option>
              <option value="hard">hard</option>
            </select></label>
          </div>
          <div className="form-row">
            <label>Marks<input type="number" min="1" value={form.marks} onChange={(event) => setForm({ ...form, marks: Number(event.target.value) })} /></label>
            <label>Negative marks<input type="number" min="0" value={form.negative_marks} onChange={(event) => setForm({ ...form, negative_marks: Number(event.target.value) })} /></label>
          </div>
          <label>Explanation<textarea value={form.explanation} onChange={(event) => setForm({ ...form, explanation: event.target.value })} /></label>
          <label className="check"><input type="checkbox" checked={form.is_active} onChange={(event) => setForm({ ...form, is_active: event.target.checked })} /> Active question</label>
          <div className="button-row">
            <button className="button" disabled={saving}>{saving ? "Saving..." : form.id ? "Update question" : "Create question"}</button>
            {form.id && <button className="button secondary" type="button" onClick={() => setForm(emptyForm)}>Cancel edit</button>}
          </div>
        </form>

        <section className="card form-stack">
          <h2>Filters</h2>
          <label>Search<input value={filters.search} onChange={(event) => setFilters({ ...filters, search: event.target.value })} /></label>
          <label>Subject<select value={filters.subject_id} onChange={(event) => setFilters({ ...filters, subject_id: event.target.value, topic_id: "" })}>
            <option value="">All subjects</option>
            {subjects.map((subject) => <option key={subject.id} value={subject.id}>{subject.name}</option>)}
          </select></label>
          <label>Topic<select value={filters.topic_id} onChange={(event) => setFilters({ ...filters, topic_id: event.target.value })}>
            <option value="">All topics</option>
            {topics.filter((topic) => !filters.subject_id || topic.subject_id === filters.subject_id).map((topic) => <option key={topic.id} value={topic.id}>{topic.name}</option>)}
          </select></label>
          <label>Difficulty<select value={filters.difficulty} onChange={(event) => setFilters({ ...filters, difficulty: event.target.value })}>
            <option value="">All levels</option>
            <option value="easy">easy</option>
            <option value="medium">medium</option>
            <option value="hard">hard</option>
          </select></label>
          <button className="button secondary" onClick={() => load(1)}>Apply filters</button>
        </section>
      </div>

      <section className="card">
        <div className="section-title">
          <h2>Question list</h2>
          <div className="inline">
            <button className="button small secondary" disabled={page <= 1} onClick={() => load(page - 1)}>Prev</button>
            <span>Page {page} of {totalPages}</span>
            <button className="button small secondary" disabled={page >= totalPages} onClick={() => load(page + 1)}>Next</button>
          </div>
        </div>
        <table className="table">
          <thead><tr><th>Question</th><th>Subject</th><th>Topic</th><th>Difficulty</th><th></th></tr></thead>
          <tbody>
            {questions.map((question) => (
              <tr key={question.id}>
                <td>
                  <b>{question.question_text}</b>
                  <small>{question.marks} mark(s)</small>
                </td>
                <td>{subjectMap.get(question.subject_id) || "-"}</td>
                <td>{topicMap.get(question.topic_id || "") || "-"}</td>
                <td>{question.difficulty}</td>
                <td className="actions-cell">
                  <button className="button small secondary" onClick={() => setPreview(question)}>Preview</button>
                  <button className="button small secondary" onClick={() => edit(question.id)}>Edit</button>
                  <button className="button small danger" onClick={() => remove(question)}>Delete</button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
        {!questions.length && <div className="empty">No questions match these filters.</div>}
      </section>

      {preview && (
        <section className="card form-stack">
          <div className="section-title">
            <h2>Question preview</h2>
            <button className="button small secondary" onClick={() => setPreview(null)}>Close</button>
          </div>
          <p><b>{preview.question_text}</b></p>
          {preview.question_image_url && <img className="media-preview" src={preview.question_image_url} alt="Question" />}
          <ol className="answer-preview" type="A">
            {preview.options.map((option, index) => (
              <li key={index} className={index === preview.correct_answer ? "correct-answer" : ""}>
                {option}{index === preview.correct_answer ? " (correct)" : ""}
              </li>
            ))}
          </ol>
          {preview.explanation && <p><b>Explanation:</b> {preview.explanation}</p>}
        </section>
      )}
    </>
  );
}
