import { Router } from "express";
import { z } from "zod";
import { requireAdmin, requireAuth } from "../middleware/auth.js";
import { env } from "../config/env.js";
import { supabase } from "../config/supabase.js";
import { AppError } from "../utils/http.js";
import { generateQuestions, generatedQuestionSchema } from "../services/questionGenerator.js";

export const adminAIQuestionsRouter = Router();
adminAIQuestionsRouter.use(requireAuth, requireAdmin);

function draftsSetupError(error: any) {
  const code = String(error?.code || "");
  if (code === "42P01" || code === "PGRST205") {
    return new AppError(503, "AI Drafts database setup is missing. Apply Supabase migration 009_phase6_proctoring_ai_final.sql, then retry.");
  }
  return new AppError(503, "AI Drafts is temporarily unavailable. Check the backend Supabase connection and retry.");
}

const generateSchema = z.object({
  subject_id: z.string().uuid(), topic_id: z.string().uuid(),
  difficulty: z.enum(["easy", "medium", "hard"]),
  number_of_questions: z.number().int().min(1).max(20),
  question_type: z.enum(["multiple_choice", "single_best_answer"]).default("multiple_choice")
});
const idSchema = z.string().uuid();

adminAIQuestionsRouter.get("/ai-questions/config", (_req, res) => {
  res.json({ configured: Boolean(env.aiApiKey), provider: env.aiProvider, model: env.aiApiKey ? env.aiModel : null });
});

adminAIQuestionsRouter.get("/ai-questions/drafts", async (req, res, next) => {
  try {
    const { data, error } = await supabase.from("ai_question_drafts").select("*")
      .eq("created_by", req.authUser!.id).order("created_at", { ascending: false }).limit(100);
    if (error) throw draftsSetupError(error);
    res.json({ drafts: data || [] });
  } catch (error) { next(error); }
});

adminAIQuestionsRouter.post("/ai-questions/generate", async (req, res, next) => {
  try {
    const body = generateSchema.parse(req.body);
    const [{ data: subject }, { data: topic }] = await Promise.all([
      supabase.from("subjects").select("id,name").eq("id", body.subject_id).maybeSingle(),
      supabase.from("topics").select("id,name,subject_id").eq("id", body.topic_id).maybeSingle()
    ]);
    if (!subject || !topic || topic.subject_id !== subject.id) throw new AppError(400, "Select a valid subject and topic.");
    const questions = await generateQuestions({ subject: subject.name, topic: topic.name, difficulty: body.difficulty, count: body.number_of_questions, questionType: body.question_type });
    const rows = questions.map(question => ({ ...question, created_by: req.authUser!.id, subject_id: subject.id, topic_id: topic.id, question_type: body.question_type, provider: env.aiProvider, status: "draft" }));
    const { data, error } = await supabase.from("ai_question_drafts").insert(rows).select();
    if (error) throw draftsSetupError(error);
    res.status(201).json({ drafts: data || [], message: "Questions generated as drafts. Review and approve before saving." });
  } catch (error) { next(error); }
});

adminAIQuestionsRouter.patch("/ai-questions/drafts/:id", async (req, res, next) => {
  try {
    idSchema.parse(req.params.id);
    const body = generatedQuestionSchema.partial().refine(value => Object.keys(value).length > 0).parse(req.body);
    const { data, error } = await supabase.from("ai_question_drafts").update({ ...body, status: "draft", approved_at: null })
      .eq("id", req.params.id).eq("created_by", req.authUser!.id).neq("status", "saved").select().maybeSingle();
    if (error || !data) throw new AppError(404, "Editable draft not found.");
    res.json({ draft: data, message: "Draft updated and requires approval." });
  } catch (error) { next(error); }
});

adminAIQuestionsRouter.post("/ai-questions/drafts/:id/approve", async (req, res, next) => {
  try {
    idSchema.parse(req.params.id);
    const { data, error } = await supabase.from("ai_question_drafts")
      .update({ status: "approved", approved_at: new Date().toISOString() })
      .eq("id", req.params.id).eq("created_by", req.authUser!.id).eq("status", "draft").select().maybeSingle();
    if (error || !data) throw new AppError(404, "Draft not found or already processed.");
    res.json({ draft: data, message: "Draft approved. It is not yet in the Question Bank." });
  } catch (error) { next(error); }
});

adminAIQuestionsRouter.post("/ai-questions/drafts/:id/save", async (req, res, next) => {
  try {
    idSchema.parse(req.params.id);
    const { data: draft } = await supabase.from("ai_question_drafts").select("*")
      .eq("id", req.params.id).eq("created_by", req.authUser!.id).eq("status", "approved").maybeSingle();
    if (!draft) throw new AppError(409, "Approve this draft before saving it to the Question Bank.");
    const { data: question, error } = await supabase.from("questions").insert({
      subject_id: draft.subject_id, topic_id: draft.topic_id, question_text: draft.question_text,
      options: draft.options, correct_answer: draft.correct_answer, explanation: draft.explanation,
      difficulty: draft.difficulty, marks: 1, negative_marks: 0, created_by: req.authUser!.id,
      exam_id: null, display_order: 1, is_active: true
    }).select().single();
    if (error || !question) throw new AppError(500, "Unable to save approved question.");
    await supabase.from("ai_question_drafts").update({ status: "saved", saved_question_id: question.id }).eq("id", draft.id);
    res.status(201).json({ question, message: "Approved question saved to the Question Bank." });
  } catch (error) { next(error); }
});
