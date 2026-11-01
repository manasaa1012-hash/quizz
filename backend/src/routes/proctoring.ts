import { Router } from "express";
import { z } from "zod";
import { requireAdmin, requireAuth } from "../middleware/auth.js";
import { supabase } from "../config/supabase.js";
import { AppError } from "../utils/http.js";
import { calculateRisk, isProctorEventType, PROCTOR_EVENT_CONFIG } from "../utils/riskScore.js";

export const proctoringRouter = Router();
proctoringRouter.use(requireAuth);

const eventSchema = z.object({
  attempt_id: z.string().uuid(),
  event_type: z.string().min(2).max(50).refine(isProctorEventType, "Unsupported proctoring event type."),
  details: z.record(z.unknown()).optional().default({}),
  detail: z.string().max(500).optional()
});

async function recalculateReport(attempt: { id: string; user_id: string; exam_id: string }) {
  const { data: events, error } = await supabase.from("proctoring_events").select("event_type")
    .eq("attempt_id", attempt.id).order("created_at", { ascending: true });
  if (error) throw new AppError(500, "Unable to calculate proctoring risk.");
  const result = calculateRisk(events || []);
  const { error: reportError } = await supabase.from("proctoring_reports").upsert({
    attempt_id: attempt.id, user_id: attempt.user_id, exam_id: attempt.exam_id,
    risk_score: result.riskScore, risk_level: result.riskLevel,
    event_counts: result.counts, calculation: result.calculation, calculated_at: new Date().toISOString()
  }, { onConflict: "attempt_id" });
  if (reportError) throw new AppError(500, "Unable to store proctoring report.");
  return result;
}

proctoringRouter.post("/event", async (req, res, next) => {
  try {
    const body = eventSchema.parse(req.body);
    const { data: attempt, error: attemptError } = await supabase.from("exam_attempts")
      .select("id,user_id,exam_id,status,expires_at,exams(proctoring_enabled)")
      .eq("id", body.attempt_id).eq("user_id", req.authUser!.id).maybeSingle();
    if (attemptError) throw new AppError(500, "Unable to verify attempt.");
    if (!attempt) throw new AppError(404, "Attempt not found.");
    if (attempt.status !== "in_progress") throw new AppError(409, "Attempt is no longer active.");
    const exam = Array.isArray(attempt.exams) ? attempt.exams[0] : attempt.exams;
    if (!exam?.proctoring_enabled) throw new AppError(409, "Proctoring is not enabled for this exam.");

    const config = PROCTOR_EVENT_CONFIG[body.event_type];
    const details = body.detail ? { ...body.details, message: body.detail } : body.details;
    const { data: event, error } = await supabase.from("proctoring_events").insert({
      attempt_id: body.attempt_id, user_id: req.authUser!.id, event_type: body.event_type,
      severity: config.severity, details, detail: body.detail || null
    }).select("id,event_type,severity,details,created_at").single();
    if (error) throw new AppError(500, "Unable to store proctoring event.");
    const report = await recalculateReport(attempt);
    let paused = false;
    // Record a sustained head turn for review, but do not pause an exam. A
    // false-positive must never force a student into an admin resume flow.
    const pauseForHeadTurn = false;
    if (pauseForHeadTurn && body.event_type === "head_turn_sustained") {
      const remaining = Math.max(0, Math.floor((new Date((attempt as any).expires_at || Date.now()).getTime() - Date.now()) / 1000));
      const { data: pausedAttempt, error: pauseError } = await supabase.from("exam_attempts").update({
        status: "paused", paused_at: new Date().toISOString(), paused_reason: "head_turn_sustained", remaining_seconds_at_pause: remaining
      }).eq("id", attempt.id).eq("status", "in_progress").select("id").maybeSingle();
      if (pauseError) throw new AppError(500, "Unable to pause the attempt.");
      paused = Boolean(pausedAttempt);
    }
    res.status(201).json({ event, warning_count: report.counts[body.event_type] || 0, risk_updated: true, paused });
  } catch (error) { next(error); }
});

proctoringRouter.post("/reports/:attemptId/:action", requireAdmin, async (req, res, next) => {
  try {
    const attemptId = z.string().uuid().parse(req.params.attemptId);
    const action = z.enum(["resume", "terminate"]).parse(req.params.action);
    const { data: attempt, error } = await supabase.from("exam_attempts").select("id,status,remaining_seconds_at_pause").eq("id", attemptId).maybeSingle();
    if (error || !attempt) throw new AppError(404, "Attempt not found.");
    if (attempt.status !== "paused") throw new AppError(409, "Only paused attempts can be reviewed.");
    const update = action === "resume" ? { status: "in_progress", expires_at: new Date(Date.now() + Math.max(0, Number(attempt.remaining_seconds_at_pause || 0)) * 1000).toISOString(), reviewed_at: new Date().toISOString(), review_action: action, paused_reason: null } : { status: "terminated", reviewed_at: new Date().toISOString(), review_action: action };
    const { error: updateError } = await supabase.from("exam_attempts").update(update).eq("id", attemptId).eq("status", "paused");
    if (updateError) throw new AppError(500, "Unable to review the paused attempt.");
    res.json({ message: action === "resume" ? "Attempt resumed." : "Attempt terminated." });
  } catch (error) { next(error); }
});

proctoringRouter.get("/reports", requireAdmin, async (req, res, next) => {
  try {
    const page = Math.max(1, Number(req.query.page || 1));
    const pageSize = Math.min(100, Math.max(1, Number(req.query.pageSize || 20)));
    const from = (page - 1) * pageSize;
    let query = supabase.from("proctoring_reports")
      .select("*,exams(title),profiles(full_name,email),exam_attempts(started_at,submitted_at)", { count: "exact" })
      .order("calculated_at", { ascending: false }).range(from, from + pageSize - 1);
    if (req.query.exam_id) query = query.eq("exam_id", req.query.exam_id.toString());
    if (req.query.user_id) query = query.eq("user_id", req.query.user_id.toString());
    if (req.query.risk_level) query = query.eq("risk_level", req.query.risk_level.toString());
    if (req.query.date_from) query = query.gte("calculated_at", req.query.date_from.toString());
    if (req.query.date_to) query = query.lte("calculated_at", req.query.date_to.toString());
    const { data, error, count } = await query;
    if (error) throw new AppError(500, "Unable to load proctoring reports.");
    res.json({ reports: data || [], pagination: { page, pageSize, total: count || 0, totalPages: Math.ceil((count || 0) / pageSize) } });
  } catch (error) { next(error); }
});

proctoringRouter.get("/reports/:attemptId", requireAdmin, async (req, res, next) => {
  try {
    z.string().uuid().parse(req.params.attemptId);
    const [{ data: report, error }, { data: events, error: eventsError }] = await Promise.all([
      supabase.from("proctoring_reports").select("*,exams(title),profiles(full_name,email),exam_attempts(started_at,submitted_at)").eq("attempt_id", req.params.attemptId).maybeSingle(),
      supabase.from("proctoring_events").select("id,event_type,severity,details,created_at").eq("attempt_id", req.params.attemptId).order("created_at")
    ]);
    if (error || eventsError) throw new AppError(500, "Unable to load proctoring detail.");
    if (!report) throw new AppError(404, "Proctoring report not found.");
    res.json({ report, events: events || [] });
  } catch (error) { next(error); }
});
