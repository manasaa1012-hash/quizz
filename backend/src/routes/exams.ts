import { Router } from "express";
import { requireAuth } from "../middleware/auth.js";
import { supabase } from "../config/supabase.js";
import { AppError } from "../utils/http.js";

export const examsRouter = Router();
examsRouter.use(requireAuth);

function getAvailability(exam: any, now = Date.now(), attemptsUsed = 0, questionCount = 1) {
  if (!exam.is_active || exam.status !== "published" || !exam.is_published) {
    return { can_start: false, status: "unavailable", message: "Exam is not available." };
  }
  if (exam.start_date && new Date(exam.start_date).getTime() > now) {
    return { can_start: false, status: "scheduled", message: "Exam is not open yet." };
  }
  if (exam.end_date && new Date(exam.end_date).getTime() < now) {
    return { can_start: false, status: "closed", message: "Exam is closed." };
  }
  if (attemptsUsed >= Number(exam.attempt_limit || 1)) {
    return { can_start: false, status: "limit_reached", message: "Attempt limit reached." };
  }
  if (questionCount === 0) {
    return { can_start: false, status: "unavailable", message: "Exam has no available questions." };
  }
  return { can_start: true, status: "available", message: "Exam is available." };
}

examsRouter.get("/", async (req, res, next) => {
  try {
    const now = Date.now();
    const { data: exams, error } = await supabase
      .from("exams")
      .select("id,title,description,duration_minutes,total_marks,passing_marks,attempt_limit,start_date,end_date,instructions,proctoring_enabled,webcam_required,camera_denied_action,is_published,status,is_active,subject_id")
      .eq("status", "published")
      .eq("is_published", true)
      .eq("is_active", true)
      .order("start_date", { ascending: true, nullsFirst: true });
    if (error) throw new AppError(500, "Unable to load available exams.");

    const subjectIds = [...new Set((exams || []).map((exam) => exam.subject_id).filter(Boolean))];
    const { data: subjects } = subjectIds.length
      ? await supabase.from("subjects").select("id,name").in("id", subjectIds)
      : { data: [] as any[] };
    const subjectMap = new Map((subjects || []).map((subject) => [subject.id, subject.name]));

    const examIds = (exams || []).map((exam) => exam.id);
    const { data: links } = examIds.length
      ? await supabase
          .from("exam_questions")
          .select("exam_id,questions!inner(id)")
          .in("exam_id", examIds)
          .eq("questions.is_active", true)
      : { data: [] as any[] };
    const counts = new Map<string, number>();
    for (const link of links || []) counts.set(link.exam_id, (counts.get(link.exam_id) || 0) + 1);

    const { data: submittedAttempts } = examIds.length
      ? await supabase
          .from("exam_attempts")
          .select("exam_id,status")
          .eq("user_id", req.authUser!.id)
          .eq("status", "submitted")
          .in("exam_id", examIds)
      : { data: [] as any[] };
    const submittedCounts = new Map<string, number>();
    for (const attempt of submittedAttempts || []) {
      submittedCounts.set(attempt.exam_id, (submittedCounts.get(attempt.exam_id) || 0) + 1);
    }

    res.json({
      exams: (exams || []).map((exam) => ({
        ...exam,
        subject_name: subjectMap.get(exam.subject_id || "") || "General",
        question_count: counts.get(exam.id) || 0,
        attempts_used: submittedCounts.get(exam.id) || 0,
        availability: getAvailability(exam, now, submittedCounts.get(exam.id) || 0, counts.get(exam.id) || 0)
      }))
    });
  } catch (error) {
    next(error);
  }
});

examsRouter.get("/:id", async (req, res, next) => {
  try {
    const now = Date.now();
    const { data: exam, error } = await supabase
      .from("exams")
      .select("*")
      .eq("id", req.params.id)
      .maybeSingle();
    if (error || !exam) throw new AppError(404, "Exam not found.");

    const { data: subject } = exam.subject_id
      ? await supabase.from("subjects").select("id,name").eq("id", exam.subject_id).maybeSingle()
      : { data: null as any };

    const { count: questionCount, error: countError } = await supabase
      .from("exam_questions")
      .select("question_id,questions!inner(id)", { count: "exact", head: true })
      .eq("exam_id", exam.id)
      .eq("questions.is_active", true);
    if (countError) throw new AppError(500, "Unable to count exam questions.");

    const { count: attemptsUsed, error: attemptError } = await supabase
      .from("exam_attempts")
      .select("*", { count: "exact", head: true })
      .eq("exam_id", exam.id)
      .eq("user_id", req.authUser!.id)
      .eq("status", "submitted");
    if (attemptError) throw new AppError(500, "Unable to load attempt history.");

    const availability = getAvailability(exam, now, attemptsUsed || 0, questionCount || 0);

    res.json({
      exam: {
        id: exam.id,
        title: exam.title,
        description: exam.description,
        subject_id: exam.subject_id,
        subject_name: subject?.name || "General",
        duration_minutes: exam.duration_minutes,
        total_marks: exam.total_marks,
        passing_marks: exam.passing_marks,
        attempt_limit: exam.attempt_limit,
        attempts_used: attemptsUsed || 0,
        start_date: exam.start_date,
        end_date: exam.end_date,
        instructions: exam.instructions,
        proctoring_enabled: exam.proctoring_enabled,
        webcam_required: exam.webcam_required,
        camera_denied_action: exam.camera_denied_action,
        fullscreen_required: exam.fullscreen_required,
        max_tab_switches: exam.max_tab_switches,
        question_count: questionCount || 0,
        availability
      }
    });
  } catch (error) {
    next(error);
  }
});
