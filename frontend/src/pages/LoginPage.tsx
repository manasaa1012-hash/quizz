import { FormEvent, useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import { Eye, EyeOff, LockKeyhole, Mail } from "lucide-react";
import { supabase } from "../lib/supabase";
import { api } from "../lib/api";

export default function LoginPage() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [passwordVisible, setPasswordVisible] = useState(false);
  const [error, setError] = useState("");
  const [busy, setBusy] = useState(false);
  const navigate = useNavigate();

  async function submit(e: FormEvent) {
    e.preventDefault();
    setBusy(true);
    setError("");
    const { data, error } = await supabase.auth.signInWithPassword({ email, password });
    setBusy(false);
    if (error) setError(error.message);
    else {
      try {
        const response = await api.get("/auth/me", {
          headers: { Authorization: `Bearer ${data.session.access_token}` }
        });
        navigate(response.data.profile?.role === "admin" ? "/admin" : "/app");
      } catch {
        navigate("/app");
      }
    }
  }

  return (
    <div className="auth-page">
      <form className="auth-card" onSubmit={submit}>
        <div className="auth-heading">
          <Link className="brand dark" to="/">Quiz<span>AI</span></Link>
          <span className="auth-kicker">Learning workspace</span>
          <h1>Welcome back</h1>
          <p className="muted">Sign in to pick up exactly where your learning left off.</p>
        </div>
        {error && <div className="alert error">{error}</div>}
        <label>Email
          <span className="field-control">
            <Mail size={17} />
            <input type="email" value={email} onChange={e => setEmail(e.target.value)} placeholder="you@example.com" required />
          </span>
        </label>
        <label>Password
          <span className="field-control password-field">
            <LockKeyhole size={17} />
            <input type={passwordVisible ? "text" : "password"} value={password} onChange={e => setPassword(e.target.value)} required />
            <button className="password-toggle" type="button" aria-label={passwordVisible ? "Hide password" : "Show password"} onClick={() => setPasswordVisible((visible) => !visible)}>
              {passwordVisible ? <EyeOff size={17} /> : <Eye size={17} />}
            </button>
          </span>
        </label>
        <button className="button full" disabled={busy}>{busy ? "Signing in..." : "Sign in"}</button>
        <div className="auth-links">
          <Link to="/forgot-password">Forgot your password?</Link>
          <span className="muted">New here? <Link to="/register">Create account</Link></span>
        </div>
      </form>
    </div>
  );
}
