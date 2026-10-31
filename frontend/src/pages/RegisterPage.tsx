import { FormEvent, useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import { Building2, Eye, EyeOff, LockKeyhole, Mail, UserRound } from "lucide-react";
import { supabase } from "../lib/supabase";

export default function RegisterPage() {
  const [fullName, setFullName] = useState("");
  const [college, setCollege] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [passwordVisible, setPasswordVisible] = useState(false);
  const [message, setMessage] = useState("");
  const [error, setError] = useState("");
  const [busy, setBusy] = useState(false);
  const navigate = useNavigate();

  async function submit(e: FormEvent) {
    e.preventDefault();
    setError("");
    setMessage("");
    setBusy(true);
    const { data, error } = await supabase.auth.signUp({
      email,
      password,
      options: {
        data: { full_name: fullName, college, institution: college },
        emailRedirectTo: `${window.location.origin}/login`
      }
    });
    setBusy(false);
    if (error) return setError(error.message);
    if (data.session) navigate("/app");
    else setMessage("Account created. Check your email if confirmation is enabled.");
  }

  return (
    <div className="auth-page">
      <form className="auth-card" onSubmit={submit}>
        <div className="auth-heading">
          <Link className="brand dark" to="/">Quiz<span>AI</span></Link>
          <span className="auth-kicker">Start learning smarter</span>
          <h1>Create your account</h1>
          <p className="muted">Set up your learner profile and make every study session count.</p>
        </div>
        {message && <div className="alert success">{message}</div>}
        {error && <div className="alert error">{error}</div>}
        <label>Full name<span className="field-control"><UserRound size={17} /><input value={fullName} onChange={e => setFullName(e.target.value)} placeholder="Your full name" required /></span></label>
        <label>College / Institution<span className="field-control"><Building2 size={17} /><input value={college} onChange={e => setCollege(e.target.value)} placeholder="Optional" /></span></label>
        <label>Email<span className="field-control"><Mail size={17} /><input type="email" value={email} onChange={e => setEmail(e.target.value)} placeholder="you@example.com" required /></span></label>
        <label>Password
          <span className="field-control password-field">
            <LockKeyhole size={17} />
            <input minLength={6} type={passwordVisible ? "text" : "password"} value={password} onChange={e => setPassword(e.target.value)} required />
            <button className="password-toggle" type="button" aria-label={passwordVisible ? "Hide password" : "Show password"} onClick={() => setPasswordVisible((visible) => !visible)}>
              {passwordVisible ? <EyeOff size={17} /> : <Eye size={17} />}
            </button>
          </span>
        </label>
        <small className="field-hint">Use at least 6 characters to protect your account.</small>
        <button className="button full" disabled={busy}>{busy ? "Creating..." : "Create account"}</button>
        <p className="center muted auth-footer">Already registered? <Link to="/login">Sign in</Link></p>
      </form>
    </div>
  );
}
