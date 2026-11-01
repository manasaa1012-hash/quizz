import { useState } from "react";
import { Navigate, Outlet } from "react-router-dom";
import { useAuth } from "../context/AuthContext";

export function RequireAuth({ admin = false }: { admin?: boolean }) {
  const { user, profile, profileError, loading, refreshProfile } = useAuth();
  const [retrying, setRetrying] = useState(false);

  if (loading) return <div className="center-screen">Loading...</div>;
  if (!user) return <Navigate to="/login" replace />;
  if (!profile) return (
    <div className="center-screen">
      <div className="card form-stack">
        <h2>{profileError ? "Connecting to your account" : "Loading your account"}</h2>
        <p className="muted">{profileError || "Please wait while we load your account."}</p>
        {profileError && <button className="button" disabled={retrying} onClick={() => {
          setRetrying(true);
          void refreshProfile().finally(() => setRetrying(false));
        }}>{retrying ? "Retrying..." : "Try again"}</button>}
      </div>
    </div>
  );
  if (admin && profile?.role !== "admin") return <Navigate to="/app" replace />;
  if (!admin && profile?.role === "admin") return <Navigate to="/admin" replace />;
  return <Outlet />;
}
