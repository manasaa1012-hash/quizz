import { supabase } from "../config/supabase.js";
import { AppError } from "./http.js";

export function mapProfile(profile: any) {
  if (!profile) return null;
  return {
    id: profile.id,
    full_name: profile.full_name,
    email: profile.email,
    institution: profile.institution ?? profile.college ?? null,
    college: profile.college ?? profile.institution ?? null,
    avatar_url: profile.avatar_url ?? null,
    role: profile.role,
    created_at: profile.created_at,
    last_login: profile.last_login ?? null,
    account_status: profile.account_status ?? "active"
  };
}

export async function getProfileById(userId: string) {
  const { data, error } = await supabase
    .from("profiles")
    .select("id, full_name, email, institution, college, avatar_url, role, created_at, last_login, account_status")
    .eq("id", userId)
    .maybeSingle();

  if (error) {
    throw new AppError(500, "Unable to load profile.");
  }

  return mapProfile(data);
}

export async function touchLastLogin(userId: string, lastSignInAt?: string) {
  const { error } = await supabase
    .from("profiles")
    .update({ last_login: lastSignInAt || new Date().toISOString() })
    .eq("id", userId);

  if (error) {
    throw new AppError(500, "Unable to update last login.");
  }
}
