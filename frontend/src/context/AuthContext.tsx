import {
  createContext,
  useContext,
  useEffect,
  useMemo,
  useState,
  ReactNode
} from "react";
import type { Session, User } from "@supabase/supabase-js";
import { supabase } from "../lib/supabase";
import { api } from "../lib/api";
import type { Profile } from "../types";

interface AuthState {
  user: User | null;
  session: Session | null;
  profile: Profile | null;
  profileError: string | null;
  loading: boolean;
  signOut: () => Promise<void>;
  refreshProfile: () => Promise<void>;
}

const AuthContext = createContext<AuthState | undefined>(undefined);

export function AuthProvider({ children }: { children: ReactNode }) {
  const [user, setUser] = useState<User | null>(null);
  const [session, setSession] = useState<Session | null>(null);
  const [profile, setProfile] = useState<Profile | null>(null);
  const [profileError, setProfileError] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);

  const loadProfile = async (accessToken?: string) => {
    try {
      const { data } = await api.get("/auth/me", accessToken ? {
        headers: { Authorization: `Bearer ${accessToken}` }
      } : undefined);
      setProfile(data.profile);
      setProfileError(null);
    } catch (caught) {
      setProfile(null);
      setProfileError(caught instanceof Error ? caught.message : "Unable to load your account.");
    }
  };

  useEffect(() => {
    supabase.auth.getSession().then(async ({ data }) => {
      setSession(data.session);
      setUser(data.session?.user ?? null);
      if (data.session) await loadProfile(data.session.access_token);
      setLoading(false);
    });

    const { data: listener } = supabase.auth.onAuthStateChange(
      async (_event, nextSession) => {
        setSession(nextSession);
        setUser(nextSession?.user ?? null);
        if (nextSession) await loadProfile(nextSession.access_token);
        else {
          setProfile(null);
          setProfileError(null);
        }
        setLoading(false);
      }
    );

    return () => listener.subscription.unsubscribe();
  }, []);

  useEffect(() => {
    if (!session || profile?.role !== "student") return;
    const heartbeat = () => {
      const match = window.location.pathname.match(/^\/app\/quiz\/([\w-]+)/);
      void api.post("/presence/heartbeat", { current_exam_id: match?.[1] || null }).catch(() => {});
    };
    heartbeat();
    const interval = window.setInterval(heartbeat, 30_000);
    const onVisibility = () => { if (document.visibilityState === "visible") heartbeat(); };
    document.addEventListener("visibilitychange", onVisibility);
    return () => {
      window.clearInterval(interval);
      document.removeEventListener("visibilitychange", onVisibility);
    };
  }, [session?.access_token, profile?.role]);

  const value = useMemo(
    () => ({
      user,
      session,
      profile,
      profileError,
      loading,
      signOut: async () => {
        await api.delete("/presence/heartbeat").catch(() => {});
        await supabase.auth.signOut();
      },
      refreshProfile: loadProfile
    }),
    [user, session, profile, profileError, loading]
  );

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
}

export function useAuth() {
  const ctx = useContext(AuthContext);
  if (!ctx) throw new Error("useAuth must be used within AuthProvider");
  return ctx;
}
