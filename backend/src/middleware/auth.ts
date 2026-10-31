import type { NextFunction, Request, Response } from "express";
import { supabase } from "../config/supabase.js";
import { AppError } from "../utils/http.js";
import { getProfileById, touchLastLogin } from "../utils/db.js";

export async function requireAuth(req: Request, res: Response, next: NextFunction) {
  try {
    const header = req.headers.authorization;
    if (!header?.startsWith("Bearer ")) return res.status(401).json({ message: "Authentication required" });
    const token = header.slice(7);
    const { data, error } = await supabase.auth.getUser(token);
    if (error || !data.user) return res.status(401).json({ message: "Invalid or expired session" });

    req.authUser = {
      id: data.user.id,
      email: data.user.email,
      emailConfirmedAt: data.user.email_confirmed_at,
      lastSignInAt: data.user.last_sign_in_at
    };
    const profile = await getProfileById(data.user.id);
    if (!profile) return res.status(403).json({ message: "Profile not found" });
    if (profile.account_status === "suspended") return res.status(403).json({ message: "Account suspended" });
    if (!data.user.email_confirmed_at || profile.account_status === "pending_verification") {
      return res.status(403).json({ message: "Verify your email address before continuing." });
    }
    req.profile = profile;
    if (data.user.last_sign_in_at && profile.last_login !== data.user.last_sign_in_at) {
      await touchLastLogin(data.user.id, data.user.last_sign_in_at);
    }
    next();
  } catch (error) {
    next(error);
  }
}

export function requireAdmin(req: Request, res: Response, next: NextFunction) {
  if (req.profile?.role !== "admin") return next(new AppError(403, "Admin access required"));
  next();
}
