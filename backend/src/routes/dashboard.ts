import { Router } from "express";
import { requireAuth } from "../middleware/auth.js";
import { supabase } from "../config/supabase.js";
import { AppError } from "../utils/http.js";

export const dashboardRouter = Router();
dashboardRouter.use(requireAuth);

dashboardRouter.get("/", async (req, res, next) => {
  try {
    const [{ data: attempts, error }, { data: stats, error: statsError }] = await Promise.all([
      supabase
        .from("exam_attempts")
        .select("id,exam_id,score,percentage,correct_count,incorrect_count,unanswered_count,started_at,submitted_at,total_time_seconds,passed,exams(title)")
        .eq("user_id", req.authUser!.id)
        .eq("status", "submitted")
        .order("submitted_at", { ascending: false }),
      supabase.from("student_stats").select("*").eq("user_id", req.authUser!.id).maybeSingle()
    ]);
    if (error || statsError) throw new AppError(500, "Unable to load dashboard.");

    const completedAttempts = attempts || [];
    const totalAttempts = completedAttempts.length;
    const totalQuestionsAttempted = completedAttempts.reduce(
      (sum, attempt) => sum + Number(attempt.correct_count || 0) + Number(attempt.incorrect_count || 0),
      0
    );
    const totalCorrect = completedAttempts.reduce((sum, attempt) => sum + Number(attempt.correct_count || 0), 0);
    const totalIncorrect = completedAttempts.reduce((sum, attempt) => sum + Number(attempt.incorrect_count || 0), 0);
    const averagePercentage = totalAttempts
      ? completedAttempts.reduce((sum, attempt) => sum + Number(attempt.percentage || 0), 0) / totalAttempts
      : 0;
    const bestPercentage = totalAttempts
      ? Math.max(...completedAttempts.map((attempt) => Number(attempt.percentage || 0)))
      : 0;

    const mappedAttempts = completedAttempts.map((attempt: any) => {
      const exam = Array.isArray(attempt.exams) ? attempt.exams[0] : attempt.exams;
      return { ...attempt, exam_title: exam?.title || "Exam", exams: undefined };
    });

    res.json({
      stats: stats || { total_xp: 0, quizzes_completed: 0, streak_days: 0 },
      quizzes_completed: totalAttempts,
      questions_attempted: totalQuestionsAttempted,
      correct_count: totalCorrect,
      incorrect_count: totalIncorrect,
      average_percentage: Number(averagePercentage.toFixed(1)),
      best_percentage: Number(bestPercentage.toFixed(1)),
      latest_attempt: mappedAttempts[0] || null,
      recent_attempts: mappedAttempts.slice(0, 5)
    });
  } catch (error) {
    next(error);
  }
});
