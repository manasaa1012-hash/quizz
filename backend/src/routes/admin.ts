import { Router } from "express";
import { z } from "zod";
import { requireAdmin, requireAuth } from "../middleware/auth.js";
import { supabase } from "../config/supabase.js";
import { AppError } from "../utils/http.js";
import { mapProfile } from "../utils/db.js";

const booleanFromQuery = z.enum(["true", "false"]).transform((value) => value === "true");
const uuidSchema = z.string().uuid();

const subjectSchema = z.object({
  name: z.string().trim().min(2).max(120),
  is_active: z.boolean().optional()
});

const topicSchema = z.object({
  subject_id: z.string().uuid(),
  name: z.string().trim().min(2).max(120),
  is_active: z.boolean().optional()
});

const examBaseSchema = z.object({
  title: z.string().trim().min(3).max(180),
  description: z.string().trim().max(2000).nullable().optional(),
  subject_id: z.string().uuid().nullable().optional(),
  duration_minutes: z.number().int().min(1),
  total_marks: z.number().nonnegative(),
  passing_marks: z.number().nonnegative(),
  negative_marking: z.boolean().default(false),
  start_date: z.string().datetime().nullable().optional(),
  end_date: z.string().datetime().nullable().optional(),
  status: z.enum(["draft", "published", "archived"]).default("draft"),
  shuffle_questions: z.boolean().default(false),
  shuffle_options: z.boolean().default(false),
  allow_review: z.boolean().default(true),
  proctoring_enabled: z.boolean().default(false),
  webcam_required: z.boolean().default(false),
  camera_denied_action: z.enum(["warn", "block"]).default("warn"),
  fullscreen_required: z.boolean().default(false),
  max_tab_switches: z.number().int().min(0).default(3),
  attempt_limit: z.number().int().min(1).default(1),
  instructions: z.string().trim().max(5000).nullable().optional(),
  is_active: z.boolean().default(true)
});

const examSchema = examBaseSchema
  .refine((data) => !data.end_date || !data.start_date || data.end_date >= data.start_date, {
      message: "End date must be after start date.",
      path: ["end_date"]
    })
  .refine((data) => data.passing_marks <= data.total_marks, {
    message: "Passing marks cannot exceed total marks.",
    path: ["passing_marks"]
  });

const examUpdateSchema = examBaseSchema.partial().refine(
  (data) => !data.end_date || !data.start_date || data.end_date >= data.start_date,
  {
    message: "End date must be after start date.",
    path: ["end_date"]
  }
);

const questionSchema = z.object({
  subject_id: z.string().uuid(),
  topic_id: z.string().uuid().nullable().optional(),
  question_text: z.string().trim().min(3),
  question_image_url: z.string().url().nullable().optional(),
  options: z.array(z.string().trim().min(1)).length(4),
  option_images: z.array(z.string().url().nullable()).length(4).nullable().optional(),
  correct_answer: z.number().int().min(0).max(3),
  difficulty: z.enum(["easy", "medium", "hard"]),
  marks: z.number().positive(),
  negative_marks: z.number().nonnegative().default(0),
  explanation: z.string().trim().max(2000).nullable().optional(),
  is_active: z.boolean().default(true)
});

const jsonImportSchema = z.object({
  subject: z.object({ name: z.string().trim().min(2).max(120), is_active: z.boolean().default(true) }),
  topics: z.array(z.object({ name: z.string().trim().min(2).max(120), is_active: z.boolean().default(true) })).min(1),
  exam: z.object({
    title: z.string().trim().min(3).max(180),
    description: z.string().trim().max(2000).nullable().optional(),
    duration_minutes: z.number().int().min(1),
    total_marks: z.number().nonnegative(),
    passing_marks: z.number().nonnegative(),
    negative_marking: z.boolean().default(false),
    status: z.enum(["draft", "published"]).default("draft"),
    shuffle_questions: z.boolean().default(false),
    shuffle_options: z.boolean().default(false),
    allow_review: z.boolean().default(true),
    proctoring_enabled: z.boolean().default(false),
    webcam_required: z.boolean().default(false),
    camera_denied_action: z.enum(["warn", "block"]).default("warn"),
    fullscreen_required: z.boolean().default(false),
    max_tab_switches: z.number().int().min(0).default(3),
    attempt_limit: z.number().int().min(1).default(1),
    instructions: z.string().trim().max(5000).nullable().optional(),
    is_active: z.boolean().default(true)
  }).refine((exam) => exam.passing_marks <= exam.total_marks, {
    message: "Passing marks cannot exceed total marks.",
    path: ["passing_marks"]
  }),
  questions: z.array(z.object({
    topic: z.string().trim().min(2).max(120),
    question_text: z.string().trim().min(3),
    options: z.array(z.string().trim().min(1)).length(4),
    correct_answer: z.number().int().min(0).max(3),
    difficulty: z.enum(["easy", "medium", "hard"]),
    marks: z.number().positive(),
    negative_marks: z.number().nonnegative().default(0),
    explanation: z.string().trim().max(2000).nullable().optional(),
    is_active: z.boolean().default(true)
  })).min(1)
});

const examQuestionAttachSchema = z.object({
  question_ids: z.array(z.string().uuid()).min(1)
});

const reorderSchema = z.object({
  question_ids: z.array(z.string().uuid()).min(1)
});

const optionalUuidQuery = z.preprocess((value) => value === "" ? undefined : value, z.string().uuid().optional());
const optionalDateQuery = z.preprocess((value) => value === "" ? undefined : value, z.string().date().optional());
const dashboardQuerySchema = z.object({
  exam_id: optionalUuidQuery,
  date_from: optionalDateQuery,
  date_to: optionalDateQuery
});

const performanceQuerySchema = dashboardQuerySchema.extend({
  page: z.coerce.number().int().min(1).default(1),
  pageSize: z.coerce.number().int().min(1).max(50).default(20),
  search: z.string().trim().max(120).optional()
});

const average = (values: number[]) => values.length ? values.reduce((sum, value) => sum + value, 0) / values.length : 0;
const round = (value: number) => Number(value.toFixed(2));
const isoStart = (date?: string) => date ? `${date}T00:00:00.000Z` : undefined;
const isoEnd = (date?: string) => date ? `${date}T23:59:59.999Z` : undefined;

function cleanNullableString(value?: string | null) {
  if (value === undefined) return undefined;
  return value ? value : null;
}

async function notifyExamPublished(exam: { id:string; title:string }) {
  const { data: students } = await supabase.from("profiles").select("id").eq("role", "student").eq("account_status", "active");
  if (students?.length) await supabase.from("notifications").upsert(students.map(student => ({
    user_id: student.id, type: "exam_published", title: "New exam published",
    message: `${exam.title} is now available.`, link: `/app/exams/${exam.id}`,
    event_key: `exam_published:${exam.id}`
  })), { onConflict: "user_id,event_key", ignoreDuplicates: true });
}

async function fetchExamQuestionCount(examId: string) {
  const { count, error } = await supabase
    .from("exam_questions")
    .select("*", { count: "exact", head: true })
    .eq("exam_id", examId);

  if (error) throw new AppError(500, "Unable to load exam question count.");
  return count || 0;
}

async function fetchExamPreview(examId: string) {
  const { data: exam, error: examError } = await supabase.from("exams").select("*").eq("id", examId).maybeSingle();
  if (examError || !exam) throw new AppError(404, "Exam not found.");

  const { data: links, error: linkError } = await supabase
    .from("exam_questions")
    .select("question_id, display_order")
    .eq("exam_id", examId)
    .order("display_order", { ascending: true });
  if (linkError) throw new AppError(500, "Unable to load exam questions.");

  const questionIds = (links || []).map((link) => link.question_id);
  const { data: questions, error: questionsError } = questionIds.length
    ? await supabase
        .from("questions")
        .select("id, question_text, difficulty, marks, negative_marks, subject_id, topic_id, is_active")
        .in("id", questionIds)
    : { data: [] as any[], error: null };
  if (questionsError) throw new AppError(500, "Unable to load exam question details.");

  const questionsById = new Map((questions || []).map((question) => [question.id, question]));
  return {
    ...exam,
    is_published: exam.status === "published",
    question_count: links?.length || 0,
    questions: (links || []).map((link) => ({
      ...questionsById.get(link.question_id),
      display_order: link.display_order
    }))
  };
}

export const adminRouter = Router();
adminRouter.use(requireAuth, requireAdmin);
adminRouter.param("id", (req, _res, next, value) => {
  try {
    uuidSchema.parse(value);
    next();
  } catch (error) {
    next(error);
  }
});
adminRouter.param("questionId", (req, _res, next, value) => {
  try {
    uuidSchema.parse(value);
    next();
  } catch (error) {
    next(error);
  }
});

adminRouter.get("/dashboard", async (req, res, next) => {
  try {
    const filters = dashboardQuerySchema.parse(req.query);
    let submittedQuery: any = supabase.from("exam_attempts")
      .select("id,user_id,exam_id,percentage,accuracy,correct_count,incorrect_count,total_time_seconds,passed,submitted_at,exams(title,subject_id)")
      .eq("status", "submitted").order("submitted_at", { ascending: true });
    if (filters.exam_id) submittedQuery = submittedQuery.eq("exam_id", filters.exam_id);
    if (filters.date_from) submittedQuery = submittedQuery.gte("submitted_at", isoStart(filters.date_from)!);
    if (filters.date_to) submittedQuery = submittedQuery.lte("submitted_at", isoEnd(filters.date_to)!);
    const now = new Date().toISOString();
    const [students, exams, publishedExams, draftExams, questions, allAttempts, recentUsers, submittedAttempts, activeRooms, suspiciousCases, highRiskCases, presence, examOptions] = await Promise.all([
      supabase.from("profiles").select("*", { count: "exact", head: true }).eq("role", "student"),
      supabase.from("exams").select("*", { count: "exact", head: true }),
      supabase.from("exams").select("*", { count: "exact", head: true }).eq("status", "published"),
      supabase.from("exams").select("*", { count: "exact", head: true }).eq("status", "draft"),
      supabase.from("questions").select("*", { count: "exact", head: true }),
      supabase.from("exam_attempts").select("*", { count: "exact", head: true }),
      supabase.from("profiles").select("id, full_name, email, created_at, role").order("created_at", { ascending: false }).limit(5),
      submittedQuery,
      supabase.from("multiplayer_rooms").select("*", { count: "exact", head: true }).in("status", ["open", "countdown", "in_progress"]),
      supabase.from("proctoring_reports").select("*", { count: "exact", head: true }).in("risk_level", ["Suspicious", "High Risk"]),
      supabase.from("proctoring_reports").select("*", { count: "exact", head: true }).eq("risk_level", "High Risk"),
      supabase.from("student_presence").select("user_id,current_exam_id,session_started_at,last_activity_at,expires_at").gt("expires_at", now),
      supabase.from("exams").select("id,title").order("title")
    ]);

    const requiredResults = { students, exams, publishedExams, draftExams, questions, allAttempts, recentUsers, submittedAttempts, activeRooms, suspiciousCases, highRiskCases, examOptions };
    const failedRequiredQueries = Object.entries(requiredResults).filter(([, result]) => result.error);
    if (failedRequiredQueries.length) {
      console.error("Admin dashboard query failure:", failedRequiredQueries.map(([name, result]) => ({ name, message: result.error?.message, code: result.error?.code })));
      throw new AppError(500, "Unable to load dashboard metrics.");
    }
    // Presence was introduced after the initial schema. Keep historic dashboards usable
    // until migration 012 is applied, and expose an empty live count in that case.
    if (presence.error) console.warn("Student presence is unavailable; apply migration 012_admin_analytics_presence.sql.", presence.error.message);
    const presenceRows = presence.error ? [] : (presence.data || []);
    const attempts = submittedAttempts.data || [];
    const userIds = [...new Set([...(attempts || []).map((attempt: any) => attempt.user_id), ...presenceRows.map((item: any) => item.user_id)])];
    const { data: profiles, error: profileError } = userIds.length ? await supabase.from("profiles").select("id,full_name,email").in("id", userIds) : { data: [], error: null };
    if (profileError) throw new AppError(500, "Unable to load student details.");
    const profileMap = new Map((profiles || []).map((profile: any) => [profile.id, profile]));
    const examMap = new Map((examOptions.data || []).map((exam: any) => [exam.id, exam.title]));
    const grouped = new Map<string, any[]>();
    for (const attempt of attempts) grouped.set(attempt.user_id, [...(grouped.get(attempt.user_id) || []), attempt]);
    const leaderboard = [...grouped].map(([userId, rows]) => {
      const correct = rows.reduce((sum, row) => sum + Number(row.correct_count || 0), 0);
      const answered = rows.reduce((sum, row) => sum + Number(row.correct_count || 0) + Number(row.incorrect_count || 0), 0);
      return { user_id: userId, full_name: profileMap.get(userId)?.full_name || "Student", exams_attempted: rows.length,
        average_score: round(average(rows.map(row => Number(row.percentage || 0)))), highest_score: Math.max(...rows.map(row => Number(row.percentage || 0))),
        accuracy: answered ? round(correct / answered * 100) : 0 };
    }).sort((a, b) => b.average_score - a.average_score || b.highest_score - a.highest_score || b.accuracy - a.accuracy || a.full_name.localeCompare(b.full_name));
    let previousKey = ""; let rank = 0;
    const rankedLeaderboard = leaderboard.map((row, index) => {
      const key = `${row.average_score}|${row.highest_score}|${row.accuracy}`;
      if (key !== previousKey) rank = index + 1;
      previousKey = key;
      return { ...row, rank };
    });
    const participation = new Map<string, number>(); const examPerformance = new Map<string, number[]>();
    for (const attempt of attempts) {
      const day = String(attempt.submitted_at).slice(0, 10); participation.set(day, (participation.get(day) || 0) + 1);
      const title = (Array.isArray(attempt.exams) ? attempt.exams[0] : attempt.exams)?.title || examMap.get(attempt.exam_id) || "Exam";
      examPerformance.set(title, [...(examPerformance.get(title) || []), Number(attempt.percentage || 0)]);
    }
    const live_students = presenceRows.map((item: any) => ({
      user_id: item.user_id, full_name: profileMap.get(item.user_id)?.full_name || "Student", email: profileMap.get(item.user_id)?.email || null,
      current_exam: item.current_exam_id ? examMap.get(item.current_exam_id) || "Exam" : null, session_start_time: item.session_started_at,
      last_activity_time: item.last_activity_at, status: "active"
    }));
    const passCount = attempts.filter((attempt: any) => Boolean(attempt.passed)).length;

    res.json({
      total_students: students.count || 0,
      active_students: live_students.length,
      total_exams: exams.count || 0,
      published_exams: publishedExams.count || 0,
      draft_exams: draftExams.count || 0,
      total_questions: questions.count || 0,
      total_attempts: attempts.length,
      average_score: round(average(attempts.map((row: any) => Number(row.percentage || 0)))),
      pass_percentage: attempts.length ? round(passCount / attempts.length * 100) : 0,
      fail_percentage: attempts.length ? round((attempts.length - passCount) / attempts.length * 100) : 0,
      completion_rate: (allAttempts.count || 0) ? round(attempts.length / (allAttempts.count || 1) * 100) : 0,
      active_multiplayer_rooms: activeRooms.count || 0,
      suspicious_attempts: suspiciousCases.count || 0,
      high_risk_cases: highRiskCases.count || 0,
      recent_registrations: recentUsers.data || [],
      recent_submissions: [...attempts].slice(-5).reverse().map((attempt: any) => ({ ...attempt, profiles: profileMap.get(attempt.user_id) })),
      filters: { exams: examOptions.data || [] },
      charts: {
        participation: [...participation].map(([date, attempts]) => ({ date, attempts })),
        exam_performance: [...examPerformance].map(([exam, scores]) => ({ exam, average_score: round(average(scores)) })),
        average_scores: [...attempts].map((attempt: any) => ({ date: String(attempt.submitted_at).slice(0, 10), score: Number(attempt.percentage || 0) })),
        pass_fail: [{ name: "Pass", value: passCount }, { name: "Fail", value: attempts.length - passCount }]
      },
      leaderboard: rankedLeaderboard.slice(0, 50), ranking_rules: "Average score descending; then highest score; then answer accuracy. Students with identical three values share a competition rank.",
      top_performing_students: rankedLeaderboard.slice(0, 5), live_students
    });
  } catch (error) {
    next(error);
  }
});

adminRouter.get("/performance/students", async (req, res, next) => {
  try {
    const query = performanceQuerySchema.parse(req.query);
    const from = (query.page - 1) * query.pageSize;
    let studentsQuery: any = supabase.from("profiles").select("id,full_name,email,created_at", { count: "exact" }).eq("role", "student").order("full_name").range(from, from + query.pageSize - 1);
    if (query.search) studentsQuery = studentsQuery.or(`full_name.ilike.%${query.search}%,email.ilike.%${query.search}%`);
    const { data, count, error } = await studentsQuery;
    if (error) throw new AppError(500, "Unable to load students.");
    res.json({ students: data || [], pagination: { page: query.page, pageSize: query.pageSize, total: count || 0, totalPages: count ? Math.ceil(count / query.pageSize) : 0 } });
  } catch (error) { next(error); }
});

adminRouter.get("/performance/:userId", async (req, res, next) => {
  try {
    const userId = uuidSchema.parse(req.params.userId);
    const query = dashboardQuerySchema.parse(req.query);
    const { data: student, error: studentError } = await supabase.from("profiles").select("id,full_name,email,created_at").eq("id", userId).eq("role", "student").maybeSingle();
    if (studentError || !student) throw new AppError(404, "Student not found.");
    let attemptsQuery: any = supabase.from("exam_attempts")
      .select("id,exam_id,percentage,accuracy,correct_count,incorrect_count,unanswered_count,total_time_seconds,passed,score,started_at,submitted_at,exams(title,subject_id)")
      .eq("user_id", userId).eq("status", "submitted").order("submitted_at");
    if (query.exam_id) attemptsQuery = attemptsQuery.eq("exam_id", query.exam_id);
    if (query.date_from) attemptsQuery = attemptsQuery.gte("submitted_at", isoStart(query.date_from)!);
    if (query.date_to) attemptsQuery = attemptsQuery.lte("submitted_at", isoEnd(query.date_to)!);
    const { data: attempts, error: attemptsError } = await attemptsQuery;
    if (attemptsError) throw new AppError(500, "Unable to load student attempts.");
    const ids = (attempts || []).map((attempt: any) => attempt.id);
    const { data: answers, error: answersError } = ids.length ? await supabase.from("student_answers")
      .select("attempt_id,question_id,selected_answer,is_correct,marks_awarded,time_taken_seconds,question_snapshot").in("attempt_id", ids) : { data: [], error: null };
    if (answersError) throw new AppError(500, "Unable to load question results.");
    const subjectIds = [...new Set((attempts || []).map((attempt: any) => (Array.isArray(attempt.exams) ? attempt.exams[0] : attempt.exams)?.subject_id).filter(Boolean))];
    const topicIds = [...new Set((answers || []).map((answer: any) => answer.question_snapshot?.topic_id).filter(Boolean))];
    const [{ data: subjects }, { data: topics }] = await Promise.all([
      subjectIds.length ? supabase.from("subjects").select("id,name").in("id", subjectIds) : Promise.resolve({ data: [] as any[] }),
      topicIds.length ? supabase.from("topics").select("id,name,subject_id").in("id", topicIds) : Promise.resolve({ data: [] as any[] })
    ]);
    const subjectMap = new Map((subjects || []).map((subject: any) => [subject.id, subject.name]));
    const topicMap = new Map((topics || []).map((topic: any) => [topic.id, topic]));
    const bySubject = new Map<string, any[]>(); const byTopic = new Map<string, any[]>();
    for (const answer of answers || []) {
      const snapshot: any = answer.question_snapshot || {}; const topicId = snapshot.topic_id;
      const topic = topicId ? topicMap.get(topicId) : null; const subjectId = topic?.subject_id || snapshot.subject_id || "general";
      bySubject.set(subjectId, [...(bySubject.get(subjectId) || []), answer]);
      if (topicId) byTopic.set(topicId, [...(byTopic.get(topicId) || []), answer]);
    }
    const summarize = (rows: any[]) => { const answered = rows.filter(row => row.selected_answer !== null); const correct = answered.filter(row => row.is_correct).length; return { attempted: answered.length, correct, accuracy: answered.length ? round(correct / answered.length * 100) : 0, average_time: round(average(answered.map(row => Number(row.time_taken_seconds || 0)))) }; };
    const subject_performance = [...bySubject].map(([subjectId, rows]) => ({ subject_id: subjectId, subject: subjectMap.get(subjectId) || "General", ...summarize(rows) }));
    const topic_performance = [...byTopic].map(([topicId, rows]) => ({ topic_id: topicId, topic: topicMap.get(topicId)?.name || "Topic", ...summarize(rows) })).sort((a, b) => a.accuracy - b.accuracy);
    res.json({
      student,
      attempts: (attempts || []).map((attempt: any) => ({ ...attempt, exam_title: (Array.isArray(attempt.exams) ? attempt.exams[0] : attempt.exams)?.title || "Exam" })),
      score_trend: (attempts || []).map((attempt: any, index: number) => ({ label: `Attempt ${index + 1}`, date: attempt.submitted_at, score: Number(attempt.percentage || 0), accuracy: Number(attempt.accuracy || 0) })),
      subject_performance, topic_performance,
      weak_topics: topic_performance.filter(topic => topic.accuracy < 60), strong_topics: topic_performance.filter(topic => topic.accuracy >= 75),
      question_results: (answers || []).map((answer: any) => ({ ...answer, question_text: answer.question_snapshot?.question_text || "Question", topic: topicMap.get(answer.question_snapshot?.topic_id)?.name || "General" }))
    });
  } catch (error) { next(error); }
});

adminRouter.get("/users", async (req, res, next) => {
  try {
    const search = (req.query.search?.toString() || "").trim();
    let query = supabase
      .from("profiles")
      .select("id, full_name, email, institution, college, role, created_at, last_login, account_status")
      .order("created_at", { ascending: false });

    if (search) {
      query = query.or(`full_name.ilike.%${search}%,email.ilike.%${search}%`);
    }

    const { data, error } = await query;
    if (error) throw new AppError(500, "Unable to load users.");
    res.json({ users: (data || []).map(mapProfile) });
  } catch (error) {
    next(error);
  }
});

adminRouter.get("/subjects", async (req, res, next) => {
  try {
    const search = (req.query.search?.toString() || "").trim();
    const isActive = req.query.is_active ? booleanFromQuery.parse(req.query.is_active) : undefined;
    let query = supabase.from("subjects").select("*").order("name");
    if (search) query = query.ilike("name", `%${search}%`);
    if (typeof isActive === "boolean") query = query.eq("is_active", isActive);
    const { data, error } = await query;
    if (error) throw new AppError(500, "Unable to load subjects.");
    res.json({ subjects: data || [] });
  } catch (error) {
    next(error);
  }
});

adminRouter.post("/subjects", async (req, res, next) => {
  try {
    const body = subjectSchema.parse(req.body);
    const { data, error } = await supabase.from("subjects").insert(body).select().single();
    if (error) throw new AppError(400, "Unable to create subject.");
    res.status(201).json({ subject: data, message: "Subject created successfully." });
  } catch (error) {
    next(error);
  }
});

adminRouter.patch("/subjects/:id", async (req, res, next) => {
  try {
    const body = subjectSchema.partial().parse(req.body);
    const { data, error } = await supabase.from("subjects").update(body).eq("id", req.params.id).select().maybeSingle();
    if (error || !data) throw new AppError(404, "Subject not found.");
    res.json({ subject: data, message: "Subject updated successfully." });
  } catch (error) {
    next(error);
  }
});

adminRouter.delete("/subjects/:id", async (req, res, next) => {
  try {
    const { error } = await supabase.from("subjects").delete().eq("id", req.params.id);
    if (error) throw new AppError(409, "Subject could not be deleted because it is still in use.");
    res.json({ message: "Subject deleted successfully." });
  } catch (error) {
    next(error);
  }
});

adminRouter.get("/topics", async (req, res, next) => {
  try {
    const search = (req.query.search?.toString() || "").trim();
    const subjectId = req.query.subject_id?.toString();
    const isActive = req.query.is_active ? booleanFromQuery.parse(req.query.is_active) : undefined;
    let query = supabase.from("topics").select("*").order("name");
    if (search) query = query.ilike("name", `%${search}%`);
    if (subjectId) query = query.eq("subject_id", subjectId);
    if (typeof isActive === "boolean") query = query.eq("is_active", isActive);
    const { data, error } = await query;
    if (error) throw new AppError(500, "Unable to load topics.");
    res.json({ topics: data || [] });
  } catch (error) {
    next(error);
  }
});

adminRouter.post("/topics", async (req, res, next) => {
  try {
    const body = topicSchema.parse(req.body);
    const { data, error } = await supabase.from("topics").insert(body).select().single();
    if (error) throw new AppError(400, "Unable to create topic.");
    res.status(201).json({ topic: data, message: "Topic created successfully." });
  } catch (error) {
    next(error);
  }
});

adminRouter.patch("/topics/:id", async (req, res, next) => {
  try {
    const body = topicSchema.partial().parse(req.body);
    const { data, error } = await supabase.from("topics").update(body).eq("id", req.params.id).select().maybeSingle();
    if (error || !data) throw new AppError(404, "Topic not found.");
    res.json({ topic: data, message: "Topic updated successfully." });
  } catch (error) {
    next(error);
  }
});

adminRouter.delete("/topics/:id", async (req, res, next) => {
  try {
    const { error } = await supabase.from("topics").delete().eq("id", req.params.id);
    if (error) throw new AppError(409, "Topic could not be deleted because it is still in use.");
    res.json({ message: "Topic deleted successfully." });
  } catch (error) {
    next(error);
  }
});

adminRouter.get("/questions", async (req, res, next) => {
  try {
    const search = (req.query.search?.toString() || "").trim();
    const subjectId = req.query.subject_id?.toString();
    const topicId = req.query.topic_id?.toString();
    const difficulty = req.query.difficulty?.toString();
    const isActive = req.query.is_active ? booleanFromQuery.parse(req.query.is_active) : undefined;
    const page = Math.max(1, Number(req.query.page || 1));
    const pageSize = Math.min(50, Math.max(1, Number(req.query.pageSize || 10)));
    const from = (page - 1) * pageSize;
    const to = from + pageSize - 1;

    let query = supabase
      .from("questions")
      .select("*", { count: "exact" })
      .order("created_at", { ascending: false })
      .range(from, to);

    if (search) query = query.ilike("question_text", `%${search}%`);
    if (subjectId) query = query.eq("subject_id", subjectId);
    if (topicId) query = query.eq("topic_id", topicId);
    if (difficulty) query = query.eq("difficulty", difficulty);
    if (typeof isActive === "boolean") query = query.eq("is_active", isActive);

    const { data, error, count } = await query;
    if (error) throw new AppError(500, "Unable to load questions.");

    res.json({
      questions: data || [],
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

adminRouter.get("/questions/:id", async (req, res, next) => {
  try {
    const { data, error } = await supabase.from("questions").select("*").eq("id", req.params.id).maybeSingle();
    if (error || !data) throw new AppError(404, "Question not found.");
    res.json({ question: data });
  } catch (error) {
    next(error);
  }
});

adminRouter.post("/questions", async (req, res, next) => {
  try {
    const body = questionSchema.parse(req.body);
    const { data, error } = await supabase
      .from("questions")
      .insert({
        ...body,
        topic_id: body.topic_id || null,
        question_image_url: cleanNullableString(body.question_image_url),
        option_images: body.option_images || null,
        explanation: cleanNullableString(body.explanation),
        created_by: req.authUser!.id,
        exam_id: null,
        display_order: 1
      })
      .select()
      .single();
    if (error) throw new AppError(400, "Unable to create question.");
    res.status(201).json({ question: data, message: "Question created successfully." });
  } catch (error) {
    next(error);
  }
});

adminRouter.post("/imports/exam-json", async (req, res, next) => {
  try {
    const body = jsonImportSchema.parse(req.body);
    const normalizedSubjectName = body.subject.name.toLocaleLowerCase();
    const normalizedTopicNames = new Set(body.topics.map((topic) => topic.name.toLocaleLowerCase()));
    const invalidQuestionTopic = body.questions.find((question) => !normalizedTopicNames.has(question.topic.toLocaleLowerCase()));
    if (invalidQuestionTopic) {
      throw new AppError(400, `Question topic "${invalidQuestionTopic.topic}" is not listed in topics.`);
    }

    const { data: existingSubjects, error: subjectLookupError } = await supabase.from("subjects").select("id,name");
    if (subjectLookupError) throw new AppError(500, "Unable to check existing subjects.");
    let subject = (existingSubjects || []).find((item) => item.name.toLocaleLowerCase() === normalizedSubjectName);
    if (!subject) {
      const { data, error } = await supabase.from("subjects").insert(body.subject).select("id,name").single();
      if (error || !data) throw new AppError(400, "Unable to create the imported subject.");
      subject = data;
    }

    const { data: existingTopics, error: topicLookupError } = await supabase.from("topics").select("id,name").eq("subject_id", subject.id);
    if (topicLookupError) throw new AppError(500, "Unable to check existing topics.");
    const topicsByName = new Map((existingTopics || []).map((topic) => [topic.name.toLocaleLowerCase(), topic]));
    for (const topic of body.topics) {
      const key = topic.name.toLocaleLowerCase();
      if (topicsByName.has(key)) continue;
      const { data, error } = await supabase.from("topics").insert({ ...topic, subject_id: subject.id }).select("id,name").single();
      if (error || !data) throw new AppError(400, `Unable to create topic "${topic.name}".`);
      topicsByName.set(key, data);
    }

    const { data: exam, error: examError } = await supabase.from("exams").insert({
      ...body.exam,
      description: cleanNullableString(body.exam.description),
      instructions: cleanNullableString(body.exam.instructions),
      subject_id: subject.id,
      created_by: req.authUser!.id,
      is_published: body.exam.status === "published"
    }).select().single();
    if (examError || !exam) throw new AppError(400, "Unable to create the imported exam.");

    const questionRows = body.questions.map((question) => ({
      subject_id: subject!.id,
      topic_id: topicsByName.get(question.topic.toLocaleLowerCase())!.id,
      question_text: question.question_text,
      options: question.options,
      correct_answer: question.correct_answer,
      difficulty: question.difficulty,
      marks: question.marks,
      negative_marks: question.negative_marks,
      explanation: cleanNullableString(question.explanation),
      is_active: question.is_active,
      created_by: req.authUser!.id,
      exam_id: null,
      display_order: 1
    }));
    const { data: questions, error: questionError } = await supabase.from("questions").insert(questionRows).select("id");
    if (questionError || !questions?.length) throw new AppError(400, "Exam created, but its questions could not be imported.");

    const { error: linkError } = await supabase.from("exam_questions").insert(questions.map((question, index) => ({
      exam_id: exam.id,
      question_id: question.id,
      display_order: index + 1
    })));
    if (linkError) throw new AppError(400, "Questions were imported, but could not be attached to the exam.");
    if (exam.status === "published") await notifyExamPublished(exam);

    res.status(201).json({
      exam: await fetchExamPreview(exam.id),
      message: `Imported ${questions.length} question(s) into "${exam.title}".`
    });
  } catch (error) {
    next(error);
  }
});

adminRouter.patch("/questions/:id", async (req, res, next) => {
  try {
    const body = questionSchema.partial().parse(req.body);
    const { data, error } = await supabase
      .from("questions")
      .update({
        ...body,
        ...(body.question_image_url !== undefined ? { question_image_url: cleanNullableString(body.question_image_url) } : {}),
        ...(body.explanation !== undefined ? { explanation: cleanNullableString(body.explanation) } : {})
      })
      .eq("id", req.params.id)
      .select()
      .maybeSingle();
    if (error || !data) throw new AppError(404, "Question not found.");
    res.json({ question: data, message: "Question updated successfully." });
  } catch (error) {
    next(error);
  }
});

adminRouter.delete("/questions/:id", async (req, res, next) => {
  try {
    const { error } = await supabase.from("questions").delete().eq("id", req.params.id);
    if (error) throw new AppError(409, "Question could not be deleted because it is still in use.");
    res.json({ message: "Question deleted successfully." });
  } catch (error) {
    next(error);
  }
});

adminRouter.get("/exams", async (req, res, next) => {
  try {
    const search = (req.query.search?.toString() || "").trim();
    const status = req.query.status?.toString();
    const subjectId = req.query.subject_id?.toString();

    let query = supabase.from("exams").select("*").order("created_at", { ascending: false });
    if (search) query = query.ilike("title", `%${search}%`);
    if (status) query = query.eq("status", status);
    if (subjectId) query = query.eq("subject_id", subjectId);

    const { data: exams, error } = await query;
    if (error) throw new AppError(500, "Unable to load exams.");

    const counts = new Map<string, number>();
    for (const exam of exams || []) {
      counts.set(exam.id, await fetchExamQuestionCount(exam.id));
    }

    res.json({
      exams: (exams || []).map((exam) => ({
        ...exam,
        is_published: exam.status === "published",
        question_count: counts.get(exam.id) || 0
      }))
    });
  } catch (error) {
    next(error);
  }
});

adminRouter.get("/exams/:id", async (req, res, next) => {
  try {
    const exam = await fetchExamPreview(req.params.id);
    res.json({ exam });
  } catch (error) {
    next(error);
  }
});

adminRouter.post("/exams", async (req, res, next) => {
  try {
    const body = examSchema.parse(req.body);
    const payload = {
      ...body,
      description: cleanNullableString(body.description),
      subject_id: body.subject_id || null,
      start_date: cleanNullableString(body.start_date),
      end_date: cleanNullableString(body.end_date),
      created_by: req.authUser!.id,
      is_published: body.status === "published"
    };
    const { data, error } = await supabase.from("exams").insert(payload).select().single();
    if (error) throw new AppError(400, "Unable to create exam.");
    if (data.status === "published") await notifyExamPublished(data);
    res.status(201).json({ exam: data, message: "Exam created successfully." });
  } catch (error) {
    next(error);
  }
});

adminRouter.patch("/exams/:id", async (req, res, next) => {
  try {
    const body = examUpdateSchema.parse(req.body);
    const payload = {
      ...body,
      ...(body.description !== undefined ? { description: cleanNullableString(body.description) } : {}),
      ...(body.subject_id !== undefined ? { subject_id: body.subject_id || null } : {}),
      ...(body.start_date !== undefined ? { start_date: cleanNullableString(body.start_date) } : {}),
      ...(body.end_date !== undefined ? { end_date: cleanNullableString(body.end_date) } : {}),
      ...(body.status !== undefined ? { is_published: body.status === "published" } : {})
    };
    const { data, error } = await supabase.from("exams").update(payload).eq("id", req.params.id).select().maybeSingle();
    if (error || !data) throw new AppError(404, "Exam not found.");
    if (body.status === "published") await notifyExamPublished(data);
    res.json({ exam: data, message: "Exam updated successfully." });
  } catch (error) {
    next(error);
  }
});

adminRouter.delete("/exams/:id", async (req, res, next) => {
  try {
    const { error } = await supabase.from("exams").delete().eq("id", req.params.id);
    if (error) throw new AppError(409, "Exam could not be deleted.");
    res.json({ message: "Exam deleted successfully." });
  } catch (error) {
    next(error);
  }
});

adminRouter.post("/exams/:id/publish", async (req, res, next) => {
  try {
    const { count: questionCount, error: countError } = await supabase
      .from("exam_questions")
      .select("question_id,questions!inner(id)", { count: "exact", head: true })
      .eq("exam_id", req.params.id)
      .eq("questions.is_active", true);
    if (countError) throw new AppError(500, "Unable to validate exam questions.");
    if (!questionCount) throw new AppError(400, "Add at least one question before publishing an exam.");
    const { data, error } = await supabase
      .from("exams")
      .update({ status: "published", is_published: true })
      .eq("id", req.params.id)
      .select()
      .maybeSingle();
    if (error || !data) throw new AppError(404, "Exam not found.");
    await notifyExamPublished(data);
    res.json({ exam: data, message: "Exam published successfully." });
  } catch (error) {
    next(error);
  }
});

adminRouter.post("/exams/:id/unpublish", async (req, res, next) => {
  try {
    const { data, error } = await supabase
      .from("exams")
      .update({ status: "draft", is_published: false })
      .eq("id", req.params.id)
      .select()
      .maybeSingle();
    if (error || !data) throw new AppError(404, "Exam not found.");
    res.json({ exam: data, message: "Exam returned to draft." });
  } catch (error) {
    next(error);
  }
});

adminRouter.post("/exams/:id/duplicate", async (req, res, next) => {
  try {
    const original = await fetchExamPreview(req.params.id);
    const { data: createdExam, error: createError } = await supabase
      .from("exams")
      .insert({
        title: `${original.title} (Copy)`,
        description: original.description,
        subject_id: original.subject_id,
        duration_minutes: original.duration_minutes,
        total_marks: original.total_marks,
        passing_marks: original.passing_marks,
        negative_marking: original.negative_marking,
        start_date: null,
        end_date: null,
        status: "draft",
        is_published: false,
        shuffle_questions: original.shuffle_questions,
        shuffle_options: original.shuffle_options,
        allow_review: original.allow_review,
        proctoring_enabled: original.proctoring_enabled,
        webcam_required: original.webcam_required,
        camera_denied_action: original.camera_denied_action,
        fullscreen_required: original.fullscreen_required,
        max_tab_switches: original.max_tab_switches,
        attempt_limit: original.attempt_limit,
        instructions: original.instructions,
        is_active: original.is_active,
        created_by: req.authUser!.id
      })
      .select()
      .single();
    if (createError || !createdExam) throw new AppError(400, "Unable to duplicate exam.");

    const links = (original.questions || []).map((question: any, index: number) => ({
      exam_id: createdExam.id,
      question_id: question.id,
      display_order: index + 1
    }));
    if (links.length) {
      const { error: linkError } = await supabase.from("exam_questions").insert(links);
      if (linkError) throw new AppError(500, "Exam copy created, but question linking failed.");
    }

    res.status(201).json({ exam: await fetchExamPreview(createdExam.id), message: "Exam duplicated successfully." });
  } catch (error) {
    next(error);
  }
});

adminRouter.post("/exams/:id/questions", async (req, res, next) => {
  try {
    const body = examQuestionAttachSchema.parse(req.body);
    if (new Set(body.question_ids).size !== body.question_ids.length) {
      throw new AppError(400, "Select each question only once.");
    }
    const { data: existing, error: existingError } = await supabase.from("exam_questions")
      .select("question_id").eq("exam_id", req.params.id).in("question_id", body.question_ids);
    if (existingError) throw new AppError(500, "Unable to validate existing exam questions.");
    if (existing?.length) throw new AppError(409, "One or more selected questions are already assigned to this exam.");
    const currentCount = await fetchExamQuestionCount(req.params.id);
    const rows = body.question_ids.map((questionId, index) => ({
      exam_id: req.params.id,
      question_id: questionId,
      display_order: currentCount + index + 1
    }));
    const { error } = await supabase.from("exam_questions").insert(rows);
    if (error) throw new AppError(400, "Unable to attach question(s) to exam.");
    res.status(201).json({ exam: await fetchExamPreview(req.params.id), message: "Question(s) added to exam." });
  } catch (error) {
    next(error);
  }
});

adminRouter.delete("/exams/:id/questions/:questionId", async (req, res, next) => {
  try {
    const { error } = await supabase
      .from("exam_questions")
      .delete()
      .eq("exam_id", req.params.id)
      .eq("question_id", req.params.questionId);
    if (error) throw new AppError(400, "Unable to remove question from exam.");

    const exam = await fetchExamPreview(req.params.id);
    const orderedIds = (exam.questions || []).map((question: any) => question.id);
    for (let index = 0; index < orderedIds.length; index += 1) {
      await supabase
        .from("exam_questions")
        .update({ display_order: index + 1 })
        .eq("exam_id", req.params.id)
        .eq("question_id", orderedIds[index]);
    }

    res.json({ exam: await fetchExamPreview(req.params.id), message: "Question removed from exam." });
  } catch (error) {
    next(error);
  }
});

adminRouter.patch("/exams/:id/questions/reorder", async (req, res, next) => {
  try {
    const body = reorderSchema.parse(req.body);
    if (new Set(body.question_ids).size !== body.question_ids.length) {
      throw new AppError(400, "Question order contains duplicate IDs.");
    }
    const { error } = await supabase.rpc("reorder_exam_questions", {
      p_exam_id: req.params.id,
      p_question_ids: body.question_ids
    });
    if (error) throw new AppError(400, error.message || "Unable to reorder exam questions.");

    res.json({ exam: await fetchExamPreview(req.params.id), message: "Question order updated successfully." });
  } catch (error) {
    next(error);
  }
});
