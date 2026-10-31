import { FormEvent, useState } from "react";
import { Link } from "react-router-dom";
import { Mail } from "lucide-react";
import { supabase } from "../lib/supabase";

export default function ForgotPasswordPage() {
  const [email, setEmail] = useState("");
  const [message, setMessage] = useState("");
  const [error, setError] = useState("");
  const [busy, setBusy] = useState(false);

  async function submit(event: FormEvent) {
    event.preventDefault();
    setBusy(true);
    setMessage("");
    setError("");

    const { error } = await supabase.auth.resetPasswordForEmail(email, {
      redirectTo: `${window.location.origin}/reset-password`
    });

    setBusy(false);
    if (error) {
      setError(error.message);
      return;
    }

    setMessage("Password reset instructions have been sent if the account exists.");
  }

  return (
    <div className="auth-page">
      <form className="auth-card" onSubmit={submit}>
        <div className="auth-heading">
          <Link className="brand dark" to="/">Quiz<span>AI</span></Link>
          <span className="auth-kicker">Account recovery</span>
          <h1>Reset your password</h1>
          <p className="muted">Enter your email and we will send a secure reset link if an account exists.</p>
        </div>
        {message && <div className="alert success">{message}</div>}
        {error && <div className="alert error">{error}</div>}
        <label>Email
          <span className="field-control">
            <Mail size={17} />
            <input type="email" value={email} onChange={(event) => setEmail(event.target.value)} placeholder="you@example.com" required />
          </span>
        </label>
        <button className="button full" disabled={busy}>{busy ? "Sending..." : "Send reset link"}</button>
        <p className="center muted auth-footer">Remembered it? <Link to="/login">Back to sign in</Link></p>
      </form>
    </div>
  );
}
