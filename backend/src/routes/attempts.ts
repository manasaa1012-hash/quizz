import { Router } from "express";
import { z } from "zod";
import { requireAuth } from "../middleware/auth.js";
import { supabase } from "../config/supabase.js";
import { AppError } from "../utils/http.js";

export const attemptsRouter = Router();
attemptsRouter.use(requireAuth);

const filtersSchema = z.object({
  page: z.coerce.number().int().min(1).default(1),
  pageSize: z.coerce.number().int().min(1).max(20).default(10),
  result: z.enum(["pass", "fail"]).optional(),
  date_from: z.string().date().optional(),
  date_to: z.string().date().optional(),
  min_score: z.coerce.number().min(0).max(100).optional(),
  max_score: z.coerce.number().min(0).max(100).optional(),
  subject_id: z.string().uuid().optional()
}).refine((value) => value.min_score === undefined || value.max_score === undefined || value.min_score <= value.max_score, {
  message: "Minimum score cannot exceed maximum score.",
  path: ["min_score"]
});

attemptsRouter.get("/", async (req, res, next) => {
  try {
    const filters = filtersSchema.parse(req.query);
    const { page, pageSize } = filters;
    const from = (page - 1) * pageSize;
    const to = from + pageSize - 1;
    const resultFilter = filters.result;
    const dateFrom = filters.date_from;
    const dateTo = filters.date_to;
    const minScore = filters.min_score;
    const maxScore = filters.max_score;
    const subjectId = filters.subject_id;

    let query = supabase
      .from("exam_attempts")
      .select("id,exam_id,score,percentage,correct_count,incorrect_count,unanswered_count,started_at,submitted_at,total_time_seconds,passed,exams!inner(title,subject_id)", { count: "exact" })
      .eq("user_id", req.authUser!.id)
      .eq("status", "submitted")
      .order("submitted_at", { ascending: false })
      .range(from, to);

    if (resultFilter === "pass") query = query.eq("passed", true);
    if (resultFilter === "fail") query = query.eq("passed", false);
    if (dateFrom) query = query.gte("submitted_at", `${dateFrom}T00:00:00.000Z`);
    if (dateTo) query = query.lte("submitted_at", `${dateTo}T23:59:59.999Z`);
    if (minScore !== undefined) query = query.gte("percentage", minScore);
    if (maxScore !== undefined) query = query.lte("percentage", maxScore);
    if (subjectId) query = query.eq("exams.subject_id", subjectId);

    const { data, error, count } = await query;
    if (error) throw new AppError(500, "Unable to load attempts.");

    const { data: allAttemptExams, error: filterError } = await supabase
      .from("exam_attempts")
      .select("exams!inner(subject_id)")
      .eq("user_id", req.authUser!.id)
      .eq("status", "submitted");
    if (filterError) throw new AppError(500, "Unable to load attempt filters.");

    const subjectIds = [...new Set((allAttemptExams || []).map((attempt: any) => {
      const exam = Array.isArray(attempt.exams) ? attempt.exams[0] : attempt.exams;
      return exam?.subject_id;
    }).filter(Boolean))];
    const { data: subjects } = subjectIds.length
      ? await supabase.from("subjects").select("id,name").in("id", subjectIds)
      : { data: [] as any[] };
    const subjectMap = new Map((subjects || []).map((subject) => [subject.id, subject.name]));

    const attempts = (data || []).map((attempt: any) => {
      const exam = Array.isArray(attempt.exams) ? attempt.exams[0] : attempt.exams;
      return {
        id: attempt.id,
        exam_id: attempt.exam_id,
        exam_title: exam?.title || "Exam",
        subject_id: exam?.subject_id || null,
        subject_name: subjectMap.get(exam?.subject_id || "") || "General",
        score: attempt.score,
        percentage: attempt.percentage,
        pass_fail: attempt.passed ? "Pass" : "Fail",
        started_at: attempt.started_at,
        submitted_at: attempt.submitted_at,
        total_time_seconds: attempt.total_time_seconds
      };
    });

    res.json({
      attempts,
      subjects: subjects || [],
      pagination: {
        page,
        pageSize,
        total: count || 0,
        totalPages: count ? Math.ceil(count / pageSize) : 0
      }
    });
  } catch (error) {
    next(error);
  }
});
