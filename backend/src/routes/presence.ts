import { Router } from "express";
import { z } from "zod";
import { requireAuth } from "../middleware/auth.js";
import { supabase } from "../config/supabase.js";
import { AppError } from "../utils/http.js";

export const presenceRouter = Router();
presenceRouter.use(requireAuth);

const isMissingPresenceTable = (error: any) => error?.code === "42P01" || error?.code === "PGRST205" || /student_presence/i.test(error?.message || "");

const heartbeatSchema = z.object({ current_exam_id: z.string().uuid().nullable().optional() });

presenceRouter.post("/heartbeat", async (req, res, next) => {
  try {
    // Presence is an active-student feature. Never create a heartbeat for an admin.
    if (req.profile?.role !== "student") return res.status(204).end();
    const body = heartbeatSchema.parse(req.body);
    const now = new Date();
    const expiresAt = new Date(now.getTime() + 90_000).toISOString();
    const { data: existing, error: existingError } = await supabase
      .from("student_presence").select("session_started_at").eq("user_id", req.authUser!.id).maybeSingle();
    if (isMissingPresenceTable(existingError)) return res.status(204).end();
    if (existingError) throw new AppError(500, "Unable to read presence status.");
    const { error } = await supabase.from("student_presence").upsert({
      user_id: req.authUser!.id,
      current_exam_id: body.current_exam_id || null,
      session_started_at: existing?.session_started_at || now.toISOString(),
      last_activity_at: now.toISOString(),
      expires_at: expiresAt
    });
    if (isMissingPresenceTable(error)) return res.status(204).end();
    if (error) throw new AppError(500, "Unable to update presence status.");
    res.json({ expires_at: expiresAt });
  } catch (error) { next(error); }
});

presenceRouter.delete("/heartbeat", async (req, res, next) => {
  try {
    if (req.profile?.role !== "student") return res.status(204).end();
    const { error } = await supabase.from("student_presence").delete().eq("user_id", req.authUser!.id);
    if (isMissingPresenceTable(error)) return res.status(204).end();
    if (error) throw new AppError(500, "Unable to end presence session.");
    res.status(204).end();
  } catch (error) { next(error); }
});
