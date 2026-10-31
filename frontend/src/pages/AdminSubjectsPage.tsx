import { FormEvent, useEffect, useState } from "react";
import { api } from "../lib/api";
import type { Subject } from "../types";

export default function AdminSubjectsPage() {
  const [subjects, setSubjects] = useState<Subject[]>([]);
  const [search, setSearch] = useState("");
  const [name, setName] = useState("");
  const [editingId, setEditingId] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");
  const [message, setMessage] = useState("");

  async function load(nextSearch = "") {
    setLoading(true);
    try {
      const response = await api.get("/admin/subjects", { params: nextSearch ? { search: nextSearch } : {} });
      setSubjects(response.data.subjects);
      setError("");
    } catch (caught: any) {
      setError(caught.message);
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => {
    load();
  }, []);

  async function saveSubject(event: FormEvent) {
    event.preventDefault();
    try {
      if (editingId) await api.patch(`/admin/subjects/${editingId}`, { name });
      else await api.post("/admin/subjects", { name, is_active: true });
      setName("");
      setEditingId(null);
      setMessage(editingId ? "Subject updated." : "Subject created.");
      setError("");
      load(search);
    } catch (caught: any) {
      setError(caught.message);
    }
  }

  async function toggle(subject: Subject) {
    try {
      await api.patch(`/admin/subjects/${subject.id}`, { is_active: !subject.is_active });
      await load(search);
    } catch (caught: any) {
      setError(caught.message);
    }
  }

  async function remove(subject: Subject) {
    if (!confirm(`Delete "${subject.name}"?`)) return;
    try {
      await api.delete(`/admin/subjects/${subject.id}`);
      setMessage("Subject deleted.");
      load(search);
    } catch (caught: any) {
      setError(caught.message);
    }
  }

  return (
    <>
      <div className="page-header">
        <div>
          <span className="eyebrow">ACADEMICS</span>
          <h1>Subjects</h1>
          <p>Create, search, activate, and delete core subjects.</p>
        </div>
      </div>
      {message && <div className="alert success">{message}</div>}
      {error && <div className="alert error">{error}</div>}
      <div className="grid-2">
        <form className="card form-stack" onSubmit={saveSubject}>
          <h2>{editingId ? "Edit subject" : "Create subject"}</h2>
          <label>Name<input value={name} onChange={(event) => setName(event.target.value)} required /></label>
          <div className="button-row">
            <button className="button">{editingId ? "Save subject" : "Add subject"}</button>
            {editingId && <button className="button secondary" type="button" onClick={() => { setEditingId(null); setName(""); }}>Cancel</button>}
          </div>
        </form>

        <form className="card filter-bar" onSubmit={(event) => { event.preventDefault(); load(search); }}>
          <input placeholder="Search subjects" value={search} onChange={(event) => setSearch(event.target.value)} />
          <button className="button secondary">Filter</button>
        </form>
      </div>

      <section className="card">
        <table className="table">
          <thead><tr><th>Name</th><th>Status</th><th></th></tr></thead>
          <tbody>
            {subjects.map((subject) => (
              <tr key={subject.id}>
                <td><b>{subject.name}</b></td>
                <td>{subject.is_active ? "Active" : "Inactive"}</td>
                <td className="actions-cell">
                  <button className="button small secondary" onClick={() => { setEditingId(subject.id); setName(subject.name); }}>Edit</button>
                  <button className="button small secondary" onClick={() => toggle(subject)}>{subject.is_active ? "Deactivate" : "Activate"}</button>
                  <button className="button small danger" onClick={() => remove(subject)}>Delete</button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
        {loading && <div className="empty">Loading subjects...</div>}
        {!loading && !subjects.length && <div className="empty">No subjects found.</div>}
      </section>
    </>
  );
}
