import { FormEvent, useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import { Eye, EyeOff } from "lucide-react";
import { supabase } from "../lib/supabase";

export default function ResetPasswordPage() {
  const navigate = useNavigate();
  const [password, setPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [passwordVisible, setPasswordVisible] = useState(false);
  const [confirmPasswordVisible, setConfirmPasswordVisible] = useState(false);
  const [message, setMessage] = useState("");
  const [error, setError] = useState("");
  const [busy, setBusy] = useState(false);

  async function submit(event: FormEvent) {
    event.preventDefault();
    setMessage("");
    setError("");

    if (password.length < 6) {
      setError("Password must be at least 6 characters.");
      return;
    }
    if (password !== confirmPassword) {
      setError("Passwords do not match.");
      return;
    }

    setBusy(true);
    const { error } = await supabase.auth.updateUser({ password });
    setBusy(false);

    if (error) {
      setError(error.message);
      return;
    }

    setMessage("Password updated successfully. Redirecting to sign in...");
    setTimeout(() => navigate("/login"), 1200);
  }

  return (
    <div className="auth-page">
      <form className="auth-card" onSubmit={submit}>
        <Link className="brand dark" to="/">Quiz<span>AI</span></Link>
        <h1>Reset password</h1>
        <p className="muted">Set a new password for your account.</p>
        {message && <div className="alert success">{message}</div>}
        {error && <div className="alert error">{error}</div>}
        <label>New password
          <span className="password-field">
            <input type={passwordVisible ? "text" : "password"} value={password} onChange={(event) => setPassword(event.target.value)} required />
            <button className="password-toggle" type="button" aria-label={passwordVisible ? "Hide password" : "Show password"} onClick={() => setPasswordVisible((visible) => !visible)}>
              {passwordVisible ? <EyeOff size={17} /> : <Eye size={17} />}
            </button>
          </span>
        </label>
        <label>Confirm password
          <span className="password-field">
            <input type={confirmPasswordVisible ? "text" : "password"} value={confirmPassword} onChange={(event) => setConfirmPassword(event.target.value)} required />
            <button className="password-toggle" type="button" aria-label={confirmPasswordVisible ? "Hide password" : "Show password"} onClick={() => setConfirmPasswordVisible((visible) => !visible)}>
              {confirmPasswordVisible ? <EyeOff size={17} /> : <Eye size={17} />}
            </button>
          </span>
        </label>
        <button className="button full" disabled={busy}>{busy ? "Saving..." : "Update password"}</button>
        <p className="center muted">Need to sign in instead? <Link to="/login">Open login</Link></p>
      </form>
    </div>
  );
}
