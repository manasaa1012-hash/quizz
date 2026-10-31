import {
  Award, BarChart3, Bell, BrainCircuit, CalendarDays, Camera, ClipboardList, FileJson, Gamepad2, Gauge, History, LogOut, Medal, Menu, NotebookPen, Search, Shapes, ShieldCheck, Sparkles, SquareLibrary, Target, UserRound, Users, WandSparkles, X, Flame, Zap
} from "lucide-react";
import { useEffect, useRef, useState } from "react";
import { NavLink, Outlet, useLocation, useNavigate } from "react-router-dom";
import { useAuth } from "../context/AuthContext";
import { api } from "../lib/api";
import { supabase } from "../lib/supabase";

const studentLinks = [
  { title: "Workspace", items: [{ to: "/app", icon: Gauge, label: "Dashboard", end: true }, { to: "/app/exams", icon: ClipboardList, label: "Exams" }, { to: "/app/attempts", icon: History, label: "Attempts" }, { to: "/app/analytics", icon: BarChart3, label: "Analytics" }] },
  { title: "Learning", items: [{ to: "/app/recommendations", icon: BrainCircuit, label: "AI Coach" }, { to: "/app/adaptive", icon: Target, label: "Adaptive Practice" }, { to: "/app/revision-plan", icon: CalendarDays, label: "Revision Plan" }, { to: "/app/predictions", icon: Sparkles, label: "Predictions" }] },
  { title: "Community", items: [{ to: "/app/leaderboard", icon: Medal, label: "Leaderboard" }, { to: "/app/multiplayer", icon: Gamepad2, label: "Multiplayer" }, { to: "/app/achievements", icon: Award, label: "Achievements" }, { to: "/app/notifications", icon: Bell, label: "Notifications" }, { to: "/app/profile", icon: UserRound, label: "Profile" }] }
];

const adminLinks = [
  { title: "Operations", items: [{ to: "/admin", icon: ShieldCheck, label: "Dashboard", end: true }, { to: "/admin/exams", icon: ClipboardList, label: "Exams" }, { to: "/admin/questions", icon: NotebookPen, label: "Questions" }, { to: "/admin/users", icon: Users, label: "Users" }] },
  { title: "Catalog", items: [{ to: "/admin/subjects", icon: Shapes, label: "Subjects" }, { to: "/admin/topics", icon: SquareLibrary, label: "Topics" }, { to: "/admin/badges", icon: Award, label: "Badges" }] },
  { title: "Monitoring", items: [{ to: "/admin/multiplayer", icon: Gamepad2, label: "Multiplayer" }, { to: "/admin/proctoring", icon: Camera, label: "Proctoring" }, { to: "/admin/ai-questions", icon: WandSparkles, label: "AI Questions" }, { to: "/admin/json-import", icon: FileJson, label: "Upload JSON" }] }
];

export function Layout({ admin = false }: { admin?: boolean }) {
  const { profile, signOut } = useAuth();
  const navigate = useNavigate();
  const location = useLocation();
  const links = admin ? adminLinks : studentLinks;
  const [unread, setUnread] = useState(0);
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);
  const [headerStats, setHeaderStats] = useState<{ totalXp: number; streakDays: number } | null>(null);
  const [search, setSearch] = useState("");
  const [searchOpen, setSearchOpen] = useState(false);
  const [profileMenuOpen, setProfileMenuOpen] = useState(false);
  const searchRef = useRef<HTMLDivElement | null>(null);
  const profileMenuRef = useRef<HTMLDivElement | null>(null);

  const navItems = links.flatMap((group) => group.items);
  const currentNavItem = navItems.find((item) => item.to === location.pathname || (item.end && location.pathname === item.to));
  const pageTitle = currentNavItem?.label || (admin ? "Admin workspace" : "Student workspace");
  const pageSection = links.find((group) => group.items.some((item) => item.to === currentNavItem?.to))?.title;
  const filteredNavItems = search.trim()
    ? navItems.filter((item) => item.label.toLowerCase().includes(search.trim().toLowerCase()))
    : navItems.slice(0, 6);

  useEffect(() => {
    if (!profile?.id) return;
    const load = () => api.get("/notifications").then((response) => setUnread(response.data.unread_count)).catch(() => {});
    void load();
    const channel = supabase.channel(`notifications-${profile.id}`).on("postgres_changes", { event: "*", schema: "public", table: "notifications", filter: `user_id=eq.${profile.id}` }, load).subscribe();
    return () => { void supabase.removeChannel(channel); };
  }, [profile?.id]);

  useEffect(() => { setMobileMenuOpen(false); }, [location.pathname]);

  useEffect(() => {
    if (admin || !profile?.id) return;
    api.get("/gamification/me")
      .then((response) => setHeaderStats({
        totalXp: Number(response.data?.stats?.total_xp || 0),
        streakDays: Number(response.data?.stats?.streak_days || 0)
      }))
      .catch(() => setHeaderStats(null));
  }, [admin, profile?.id]);

  useEffect(() => {
    const handlePointerDown = (event: MouseEvent) => {
      const target = event.target as Node;
      if (searchRef.current && !searchRef.current.contains(target)) setSearchOpen(false);
      if (profileMenuRef.current && !profileMenuRef.current.contains(target)) setProfileMenuOpen(false);
    };

    document.addEventListener("mousedown", handlePointerDown);
    return () => document.removeEventListener("mousedown", handlePointerDown);
  }, []);

  const initials = profile?.full_name?.split(" ").map((part) => part[0]).join("").slice(0, 2).toUpperCase() || "U";
  const roleLabel = admin ? "Admin workspace" : "Student workspace";
  const goToNotifications = () => navigate("/app/notifications");
  const closeAndNavigate = (to: string) => {
    setSearch("");
    setSearchOpen(false);
    setProfileMenuOpen(false);
    navigate(to);
  };
  const handleSignOut = async () => {
    await signOut();
    navigate("/");
  };

  return <div className="shell sidebar-shell">
    {!admin && mobileMenuOpen && <button className="sidebar-overlay" type="button" aria-label="Close navigation overlay" onClick={() => setMobileMenuOpen(false)} />}
    <aside className={`sidebar${mobileMenuOpen ? " open" : ""}`} aria-label={`${roleLabel} navigation`}>
      <div className="sidebar-brand-row">
        <button className="brand brand-button sidebar-brand" type="button" onClick={() => navigate(admin ? "/admin" : "/app")}>Quiz<span>AI</span></button>
        <button className="sidebar-close nav-toggle" type="button" aria-label="Close navigation" onClick={() => setMobileMenuOpen(false)}><X size={18} /></button>
      </div>
      <div className="sidebar-scroll">
        {links.map((group) => <section className="nav-group" key={group.title}>
          <span className="nav-group-label">{group.title}</span>
          <nav className="sidebar-nav">{group.items.map(({ to, icon: Icon, label, end }) => <NavLink key={to} to={to} end={end} title={label} className="sidebar-link"><Icon size={18} /><span>{label}</span></NavLink>)}</nav>
        </section>)}
      </div>
      <div className="sidebar-footer">
        {!admin && <button className="sidebar-notification" type="button" onClick={goToNotifications}><Bell size={17} /><span>Notifications</span>{unread > 0 && <b>{unread > 99 ? "99+" : unread}</b>}</button>}
        {profile?.role === "admin" && !admin && <button className="sidebar-admin-switch" type="button" onClick={() => navigate("/admin")}><ShieldCheck size={16} /> Admin workspace</button>}
        <div className="sidebar-profile">
          <div className="avatar">{profile?.avatar_url ? <img src={profile.avatar_url} alt={profile.full_name || "User"} /> : initials}</div>
          <div><strong>{profile?.full_name || "User"}</strong><small>{profile?.role || "student"}</small></div>
          <NavLink to={admin ? "/admin" : "/app/profile"} aria-label="Open profile"><UserRound size={17} /></NavLink>
        </div>
        <button className="sidebar-logout" onClick={handleSignOut}><LogOut size={16} /> Sign out</button>
      </div>
    </aside>

    <main className="main sidebar-main">
      <header className="workspace-header">
        <div className="workspace-header-main">
          <div className="workspace-heading">
            <button className="nav-toggle workspace-menu-toggle" type="button" aria-label="Open navigation" aria-expanded={mobileMenuOpen} onClick={() => setMobileMenuOpen(true)}><Menu size={19} /></button>
            <div>
              <span className="workspace-kicker">{pageSection || roleLabel}</span>
              <h1>{pageTitle}</h1>
            </div>
          </div>
          <div className="workspace-actions">
            <div className={`workspace-search${searchOpen ? " open" : ""}`} ref={searchRef}>
              <Search size={16} />
              <input
                type="search"
                placeholder="Search pages"
                aria-label="Search dashboard pages"
                value={search}
                onChange={(event) => {
                  setSearch(event.target.value);
                  setSearchOpen(true);
                }}
                onFocus={() => setSearchOpen(true)}
              />
              {searchOpen && (
                <div className="workspace-search-panel" role="listbox" aria-label="Quick navigation results">
                  {filteredNavItems.length ? filteredNavItems.map(({ to, icon: Icon, label }) => (
                    <button key={to} type="button" className="workspace-search-result" onClick={() => closeAndNavigate(to)}>
                      <span><Icon size={16} /></span>
                      <strong>{label}</strong>
                    </button>
                  )) : <div className="workspace-search-empty">No matching pages</div>}
                </div>
              )}
            </div>
            {!admin && <button className="notification-bell header-icon-button" aria-label="Notifications" onClick={goToNotifications}><Bell size={18} />{unread > 0 && <span>{unread > 99 ? "99+" : unread}</span>}</button>}
            {!admin && <div className="workspace-pill"><Zap size={15} /><span>{headerStats?.totalXp ?? 0} XP</span></div>}
            {!admin && <div className="workspace-pill warning"><Flame size={15} /><span>{headerStats?.streakDays ?? 0} day streak</span></div>}
            <div className="workspace-profile-menu" ref={profileMenuRef}>
              <button className="workspace-profile-button" type="button" aria-haspopup="menu" aria-expanded={profileMenuOpen} onClick={() => setProfileMenuOpen((open) => !open)}>
                <div className="avatar">{profile?.avatar_url ? <img src={profile.avatar_url} alt={profile.full_name || "User"} /> : initials}</div>
                <div className="workspace-profile-copy">
                  <strong>{profile?.full_name || "User"}</strong>
                  <small>{admin ? "Administrator" : "Student"}</small>
                </div>
              </button>
              {profileMenuOpen && (
                <div className="workspace-profile-dropdown" role="menu">
                  <button type="button" role="menuitem" onClick={() => closeAndNavigate(admin ? "/admin" : "/app/profile")}><UserRound size={16} /> Profile</button>
                  {!admin && profile?.role === "admin" && <button type="button" role="menuitem" onClick={() => closeAndNavigate("/admin")}><ShieldCheck size={16} /> Admin workspace</button>}
                  <button type="button" role="menuitem" onClick={handleSignOut}><LogOut size={16} /> Sign out</button>
                </div>
              )}
            </div>
          </div>
        </div>
      </header>
      <div className="mobile-workspace-header">
        <button className="nav-toggle" type="button" aria-label="Open navigation" aria-expanded={mobileMenuOpen} onClick={() => setMobileMenuOpen(true)}><Menu size={19} /></button>
        <span>{roleLabel}</span>
        {!admin && <button className="notification-bell" aria-label="Notifications" onClick={goToNotifications}><Bell size={18} />{unread > 0 && <span>{unread > 99 ? "99+" : unread}</span>}</button>}
      </div>
      <Outlet />
    </main>
  </div>;
}
