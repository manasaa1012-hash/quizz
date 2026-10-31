import { FormEvent, useEffect, useState } from "react";
import { api } from "../lib/api";
import type { Subject, Topic } from "../types";

export default function AdminTopicsPage() {
  const [topics, setTopics] = useState<Topic[]>([]);
  const [subjects, setSubjects] = useState<Subject[]>([]);
  const [subjectId, setSubjectId] = useState("");
  const [name, setName] = useState("");
  const [editingId, setEditingId] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);
  const [filterSubject, setFilterSubject] = useState("");
  const [search, setSearch] = useState("");
  const [error, setError] = useState("");
  const [message, setMessage] = useState("");

  async function load(nextSearch = search, nextSubject = filterSubject) {
    setLoading(true);
    try {
      const [topicResponse, subjectResponse] = await Promise.all([
        api.get("/admin/topics", {
          params: {
            ...(nextSearch ? { search: nextSearch } : {}),
            ...(nextSubject ? { subject_id: nextSubject } : {})
          }
        }),
        api.get("/admin/subjects")
      ]);
      setTopics(topicResponse.data.topics);
      setSubjects(subjectResponse.data.subjects);
      setError("");
    } catch (caught: any) {
      setError(caught.message);
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => {
    load("", "");
  }, []);

  async function saveTopic(event: FormEvent) {
    event.preventDefault();
    try {
      if (editingId) await api.patch(`/admin/topics/${editingId}`, { subject_id: subjectId, name });
      else await api.post("/admin/topics", { subject_id: subjectId, name, is_active: true });
      setName("");
      setSubjectId("");
      setEditingId(null);
      setMessage(editingId ? "Topic updated." : "Topic created.");
      setError("");
      load();
    } catch (caught: any) {
      setError(caught.message);
    }
  }

  async function toggle(topic: Topic) {
    try {
      await api.patch(`/admin/topics/${topic.id}`, { is_active: !topic.is_active });
      await load();
    } catch (caught: any) {
      setError(caught.message);
    }
  }

  async function remove(topic: Topic) {
    if (!confirm(`Delete "${topic.name}"?`)) return;
    try {
      await api.delete(`/admin/topics/${topic.id}`);
      setMessage("Topic deleted.");
      load();
    } catch (caught: any) {
      setError(caught.message);
    }
  }

  const subjectMap = new Map(subjects.map((subject) => [subject.id, subject.name]));

  return (
    <>
      <div className="page-header">
        <div>
          <span className="eyebrow">ACADEMICS</span>
          <h1>Topics</h1>
          <p>Manage subject-linked topics with search and filtering.</p>
        </div>
      </div>
      {message && <div className="alert success">{message}</div>}
      {error && <div className="alert error">{error}</div>}
      <div className="grid-2">
        <form className="card form-stack" onSubmit={saveTopic}>
          <h2>{editingId ? "Edit topic" : "Create topic"}</h2>
          <label>Subject<select value={subjectId} onChange={(event) => setSubjectId(event.target.value)} required>
            <option value="">Select subject</option>
            {subjects.map((subject) => <option key={subject.id} value={subject.id}>{subject.name}</option>)}
          </select></label>
          <label>Name<input value={name} onChange={(event) => setName(event.target.value)} required /></label>
          <div className="button-row">
            <button className="button">{editingId ? "Save topic" : "Add topic"}</button>
            {editingId && <button className="button secondary" type="button" onClick={() => { setEditingId(null); setName(""); setSubjectId(""); }}>Cancel</button>}
          </div>
        </form>

        <form className="card form-stack" onSubmit={(event) => { event.preventDefault(); load(search, filterSubject); }}>
          <h2>Filters</h2>
          <label>Search<input value={search} onChange={(event) => setSearch(event.target.value)} /></label>
          <label>Subject<select value={filterSubject} onChange={(event) => setFilterSubject(event.target.value)}>
            <option value="">All subjects</option>
            {subjects.map((subject) => <option key={subject.id} value={subject.id}>{subject.name}</option>)}
          </select></label>
          <button className="button secondary">Apply filters</button>
        </form>
      </div>

      <section className="card">
        <table className="table">
          <thead><tr><th>Name</th><th>Subject</th><th>Status</th><th></th></tr></thead>
          <tbody>
            {topics.map((topic) => (
              <tr key={topic.id}>
                <td><b>{topic.name}</b></td>
                <td>{subjectMap.get(topic.subject_id) || "-"}</td>
                <td>{topic.is_active ? "Active" : "Inactive"}</td>
                <td className="actions-cell">
                  <button className="button small secondary" onClick={() => { setEditingId(topic.id); setName(topic.name); setSubjectId(topic.subject_id); }}>Edit</button>
                  <button className="button small secondary" onClick={() => toggle(topic)}>{topic.is_active ? "Deactivate" : "Activate"}</button>
                  <button className="button small danger" onClick={() => remove(topic)}>Delete</button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
        {loading && <div className="empty">Loading topics...</div>}
        {!loading && !topics.length && <div className="empty">No topics found.</div>}
      </section>
    </>
  );
}
