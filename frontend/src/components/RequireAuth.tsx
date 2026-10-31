import { Navigate, Outlet } from "react-router-dom";
import { useAuth } from "../context/AuthContext";

export function RequireAuth({ admin = false }: { admin?: boolean }) {
  const { user, profile, profileError, loading, signOut } = useAuth();

  if (loading) return <div className="center-screen">Loading...</div>;
  if (!user) return <Navigate to="/login" replace />;
  if (!profile) return (
    <div className="center-screen">
      <div className="card form-stack">
        <h2>Account unavailable</h2>
        <p className="muted">{profileError || "Your account profile could not be loaded."}</p>
        <button className="button" onClick={() => void signOut()}>Sign out</button>
      </div>
    </div>
  );
  if (admin && profile?.role !== "admin") return <Navigate to="/app" replace />;
  if (!admin && profile?.role === "admin") return <Navigate to="/admin" replace />;
  return <Outlet />;
}
