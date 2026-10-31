import { FormEvent, useEffect, useState } from "react";
import { api } from "../lib/api";
import type { Profile } from "../types";

export default function AdminUsersPage() {
  const [users, setUsers] = useState<Profile[]>([]);
  const [search, setSearch] = useState("");
  const [error, setError] = useState("");

  async function load(nextSearch = "") {
    try {
      const response = await api.get("/admin/users", { params: nextSearch ? { search: nextSearch } : {} });
      setUsers(response.data.users);
      setError("");
    } catch (caught: any) {
      setError(caught.message);
    }
  }

  useEffect(() => {
    load();
  }, []);

  function onSubmit(event: FormEvent) {
    event.preventDefault();
    load(search);
  }

  return (
    <>
      <div className="page-header">
        <div>
          <span className="eyebrow">USERS</span>
          <h1>Registered Users</h1>
          <p>Search student and admin accounts with activity details.</p>
        </div>
      </div>
      <form className="card filter-bar" onSubmit={onSubmit}>
        <input placeholder="Search by name or email" value={search} onChange={(event) => setSearch(event.target.value)} />
        <button className="button">Search</button>
      </form>
      {error && <div className="alert error">{error}</div>}
      <section className="card">
        <table className="table">
          <thead>
            <tr>
              <th>Name</th>
              <th>Email</th>
              <th>Institution</th>
              <th>Role</th>
              <th>Status</th>
              <th>Last login</th>
            </tr>
          </thead>
          <tbody>
            {users.map((user) => (
              <tr key={user.id}>
                <td><b>{user.full_name}</b></td>
                <td>{user.email || "-"}</td>
                <td>{user.institution || user.college || "-"}</td>
                <td>{user.role}</td>
                <td>{user.account_status || "active"}</td>
                <td>{user.last_login ? new Date(user.last_login).toLocaleString() : "-"}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </section>
    </>
  );
}
