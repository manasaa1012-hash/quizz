import { Router } from "express";
import { randomUUID } from "node:crypto";
import { z } from "zod";
import { requireAuth } from "../middleware/auth.js";
import { supabase } from "../config/supabase.js";
import { AppError } from "../utils/http.js";
import { buildAnalytics } from "./analytics.js";
import {
  AttemptQuestion,
  buildAttemptQuestionView,
  ensureAttemptCanSave,
  ensureAttemptCanSubmit,
  ensureValidDisplayedAnswer,
  mapDisplayedAnswerToOriginal,
  shuffleIndices,
  summarizeSavedAnswers
} from "../utils/quizEngine.js";

export const quizRouter = Router();
quizRouter.use(requireAuth);

const answerSchema = z.object({
  question_id: z.string().uuid(),
  selected_answer: z.number().int().min(0).max(3).nullable(),
  marked_for_review: z.boolean().default(false),
  visited: z.boolean().default(true),
  time_taken_seconds: z.number().int().min(0).max(604800).default(0)
});

const saveSchema = z.object({
  answers: z.array(answerSchema).min(1)
});

const submitSchema = z.object({
  answers: z.array(answerSchema).optional().default([])
});

async function fetchAttemptContext(attemptId: string, userId: string) {
  const { data: attempt, error: attemptError } = await supabase
    .from("exam_attempts")
    .select("*, exams(*)")
    .eq("id", attemptId)
    .eq("user_id", userId)
    .maybeSingle();

  if (attemptError || !attempt) throw new AppError(404, "Attempt not found");

  const exam = Array.isArray((attempt as any).exams) ? (attempt as any).exams[0] : (attempt as any).exams;
  if (!exam) throw new AppError(404, "Exam not found");

  const { data: links, error: linksError } = await supabase
    .from("exam_questions")
    .select("question_id, display_order")
    .eq("exam_id", attempt.exam_id)
    .order("display_order", { ascending: true });
  if (linksError) throw new AppError(500, "Unable to load exam questions.");

  const questionIds = (links || []).map((item) => item.question_id);
  const { data: questions, error: questionsError } = questionIds.length
    ? await supabase
        .from("questions")
        .select("id,question_text,question_image_url,options,option_images,correct_answer,difficulty,marks,negative_marks,explanation,topic_id")
        .in("id", questionIds)
    : { data: [] as any[], error: null };
  if (questionsError) throw new AppError(500, "Unable to load question details.");

  const { data: answers, error: answersError } = await supabase
    .from("student_answers")
    .select("*")
    .eq("attempt_id", attemptId)
    .order("display_order", { ascending: true });
  if (answersError) throw new AppError(500, "Unable to load saved answers.");

  const questionMap = new Map((questions || []).map((question) => [question.id, question as AttemptQuestion]));
  for (const answer of answers || []) {
    if (answer.question_snapshot) {
      questionMap.set(answer.question_id, answer.question_snapshot as AttemptQuestion);
    }
  }
  const answerMap = new Map((answers || []).map((answer) => [answer.question_id, answer]));

  const orderedQuestions = (answers?.length ? answers : links || []).map((entry: any) => {
    const questionId = entry.question_id;
    const question = questionMap.get(questionId);
    const answer = answerMap.get(questionId);
    if (!question) throw new AppError(500, "Question mapping is incomplete.");
    return {
      ...question,
      display_order: answer?.display_order ?? entry.display_order,
      saved_answer: answer
    };
  });

  return {
    attempt,
    exam,
    orderedQuestions,
    answers: answers || []
  };
}

async function createAttemptRows(attemptId: string, examId: string, shuffleQuestions: boolean, shuffleOptions: boolean) {
  const { data: links, error: linksError } = await supabase
    .from("exam_questions")
    .select("question_id, display_order, questions!inner(id,question_text,question_image_url,options,option_images,correct_answer,difficulty,marks,negative_marks,explanation,topic_id,is_active)")
    .eq("exam_id", examId)
    .eq("questions.is_active", true)
    .order("display_order", { ascending: true });
  if (linksError) throw new AppError(500, "Unable to load exam mappings.");

  const orderedLinks = [...(links || [])];
  if (shuffleQuestions) {
    const questionOrder = shuffleIndices(orderedLinks.length);
    const shuffled = questionOrder.map((index) => orderedLinks[index]);
    orderedLinks.splice(0, orderedLinks.length, ...shuffled);
  }

  const rows = orderedLinks.map((link: any, index) => {
    const question = Array.isArray(link.questions) ? link.questions[0] : link.questions;
    return ({
    attempt_id: attemptId,
    question_id: link.question_id,
    selected_answer: null,
    is_correct: false,
    marks_awarded: 0,
    time_taken_seconds: 0,
    marked_for_review: false,
    visited: false,
    updated_at: new Date().toISOString(),
    display_order: index + 1,
    option_order: shuffleOptions ? shuffleIndices(4) : [0, 1, 2, 3],
    question_snapshot: question ? {
      id: question.id,
      question_text: question.question_text,
      question_image_url: question.question_image_url,
      options: question.options,
      option_images: question.option_images,
      correct_answer: question.correct_answer,
      difficulty: question.difficulty,
      marks: question.marks,
      negative_marks: question.negative_marks,
      explanation: question.explanation,
      topic_id: question.topic_id
    } : null
  });
  });

  if (rows.length) {
    const { error } = await supabase.from("student_answers").upsert(rows, {
      onConflict: "attempt_id,question_id",
      ignoreDuplicates: true
    });
    if (error) throw new AppError(500, "Unable to initialize attempt state.");
  }
}

async function finalizeAttempt(attemptId: string, userId: string, submissionToken: string) {
  const context = await fetchAttemptContext(attemptId, userId);
  const now = Date.now();
  const startedAt = new Date(context.attempt.started_at).getTime();
  const durationLimit = Number(context.exam.duration_minutes || 0) * 60;
  const elapsedSeconds = Math.max(0, Math.min(durationLimit, Math.floor((now - startedAt) / 1000)));
  const summary = summarizeSavedAnswers(context.orderedQuestions, context.answers as any[], {
    negativeMarking: Boolean(context.exam.negative_marking),
    maxTotalTimeSeconds: durationLimit
  });
  const totalMarks = Number(
    context.exam.total_marks || context.orderedQuestions.reduce((sum, question) => sum + Number(question.marks), 0)
  );
  const percentage = totalMarks > 0 ? (summary.score / totalMarks) * 100 : 0;
  const passingMarks = Number(context.exam.passing_marks || 0);
  const passed = summary.score >= passingMarks;
  const accuracy = context.orderedQuestions.length ? (summary.correct / context.orderedQuestions.length) * 100 : 0;

  for (const detail of summary.details) {
    const { error } = await supabase
      .from("student_answers")
      .update({
        selected_answer: detail.selected_answer,
        is_correct: detail.is_correct,
        marks_awarded: detail.marks_awarded,
        time_taken_seconds: detail.time_taken_seconds,
        marked_for_review: detail.marked_for_review,
        visited: detail.visited,
        updated_at: new Date().toISOString()
      })
      .eq("attempt_id", attemptId)
      .eq("question_id", detail.question_id);
    if (error) throw new AppError(500, "Unable to finalize saved answer state.");
  }

  const submittedAt = new Date().toISOString();
  const { data: updatedAttempt, error: updateAttemptError } = await supabase
    .from("exam_attempts")
    .update({
      status: "submitted",
      submitted_at: submittedAt,
      last_saved_at: submittedAt,
      score: summary.score,
      percentage,
      correct_count: summary.correct,
      incorrect_count: summary.incorrect,
      unanswered_count: summary.unanswered,
      total_time_seconds: elapsedSeconds,
      average_response_time_seconds: context.orderedQuestions.length
        ? Number((elapsedSeconds / context.orderedQuestions.length).toFixed(2))
        : 0,
      accuracy: Number(accuracy.toFixed(2)),
      passed,
      marks_gained: summary.marksGained,
      negative_marks_obtained: summary.negativeMarks,
      xp_earned: 0,
      submission_token: null
    })
    .eq("id", attemptId)
    .eq("user_id", userId)
    .eq("status", "in_progress")
    .eq("submission_token", submissionToken)
    .select("id")
    .maybeSingle();
  if (updateAttemptError || !updatedAttempt) throw new AppError(409, "Attempt was already submitted.");

  const { error: rewardError } = await supabase.rpc("apply_attempt_rewards", {
    p_attempt_id: attemptId,
    p_user_id: userId
  });
  if (rewardError) console.error("Unable to apply attempt rewards", rewardError);
  const { data: rewardedAttempt } = await supabase.from("exam_attempts").select("xp_earned").eq("id", attemptId).single();
  const xpEarned = Number(rewardedAttempt?.xp_earned || 0);
  const { data: pendingPrediction } = await supabase.from("performance_predictions").select("id,predicted_score")
    .eq("user_id", userId).is("actual_score", null).lt("created_at", submittedAt)
    .order("created_at", { ascending: false }).limit(1).maybeSingle();
  if (pendingPrediction) await supabase.from("performance_predictions").update({actual_score:Number(percentage.toFixed(2)),prediction_error:Number(Math.abs(Number(pendingPrediction.predicted_score)-percentage).toFixed(2))}).eq("id",pendingPrediction.id);
  try { await buildAnalytics(userId); } catch (error) { console.error("Unable to refresh topic abilities", error); }

  return {
    attempt_id: attemptId,
    score: Number(summary.score.toFixed(2)),
    total_marks: totalMarks,
    percentage: Number(percentage.toFixed(2)),
    correct_count: summary.correct,
    incorrect_count: summary.incorrect,
    unanswered_count: summary.unanswered,
    total_time_seconds: elapsedSeconds,
    average_response_time_seconds: context.orderedQuestions.length
      ? Number((elapsedSeconds / context.orderedQuestions.length).toFixed(2))
      : 0,
    accuracy: Number(accuracy.toFixed(2)),
    marks_gained: Number(summary.marksGained.toFixed(2)),
    negative_marks_obtained: Number(summary.negativeMarks.toFixed(2)),
    passed,
    xp_earned: xpEarned
  };
}

quizRouter.post("/start/:examId", async (req, res, next) => {
  try {
    const examId = z.string().uuid().parse(req.params.examId);
    // Do not filter by the newer enum values in SQL: this keeps older databases
    // operable until migration 013 is applied, while still enforcing them once present.
    const { data: restrictedAttempt, error: restrictedError } = await supabase.from("exam_attempts")
      .select("status").eq("exam_id", examId).eq("user_id", req.authUser!.id).order("started_at", { ascending: false }).limit(1).maybeSingle();
    if (restrictedError) throw new AppError(500, "Unable to verify attempt status.");
    if (restrictedAttempt?.status === "paused") throw new AppError(423, "Exam paused due to a proctoring alert. Awaiting admin review.");
    if (restrictedAttempt?.status === "terminated") throw new AppError(403, "This exam attempt was terminated after proctoring review.");
    const { data, error } = await supabase.rpc("start_or_resume_exam_attempt", {
      p_exam_id: examId,
      p_user_id: req.authUser!.id
    });
    if (error || !data?.attempt) {
      const message = error?.message || "Unable to start exam.";
      const status = message.includes("limit") || message.includes("no questions") ? 409
        : message.includes("not open") || message.includes("closed") ? 403 : 404;
      throw new AppError(status, message);
    }

    const attempt = data.attempt;
    const { data: exam, error: examError } = await supabase
      .from("exams")
      .select("shuffle_questions,shuffle_options,proctoring_enabled")
      .eq("id", examId)
      .single();
    if (examError || !exam) throw new AppError(500, "Unable to initialize exam settings.");

    const { count: savedQuestionCount, error: savedQuestionError } = await supabase
      .from("student_answers")
      .select("*", { count: "exact", head: true })
      .eq("attempt_id", attempt.id);
    if (savedQuestionError) throw new AppError(500, "Unable to inspect saved attempt state.");
    if (!data.resumed || !savedQuestionCount) {
      await createAttemptRows(attempt.id, examId, Boolean(exam.shuffle_questions), Boolean(exam.shuffle_options));
    }
    if (exam.proctoring_enabled) {
      const { error: reportError } = await supabase.from("proctoring_reports").upsert({
        attempt_id: attempt.id, user_id: req.authUser!.id, exam_id: examId,
        risk_score: 0, risk_level: "Low", event_counts: {},
        calculation: { raw_score: 0, clamped_score: 0, contributions: {} },
        calculated_at: new Date().toISOString()
      }, { onConflict: "attempt_id", ignoreDuplicates: true });
      if (reportError) throw new AppError(500, "Unable to initialize proctoring report.");
    }
    res.status(data.resumed ? 200 : 201).json({ attempt, resumed: Boolean(data.resumed) });
  } catch (error) {
    next(error);
  }
});

quizRouter.get("/attempt/:attemptId", async (req, res, next) => {
  try {
    const context = await fetchAttemptContext(req.params.attemptId, req.authUser!.id);
    const now = Date.now();
    const remainingSeconds = context.attempt.expires_at
      ? Math.max(0, Math.floor((new Date(context.attempt.expires_at).getTime() - now) / 1000))
      : Number(context.exam.duration_minutes || 0) * 60;

    res.json({
      attempt: {
        id: context.attempt.id,
        status: context.attempt.status,
        attempt_number: context.attempt.attempt_number,
        started_at: context.attempt.started_at,
        expires_at: context.attempt.expires_at,
        remaining_seconds: remainingSeconds
      },
      exam: {
        id: context.exam.id,
        title: context.exam.title,
        description: context.exam.description,
        duration_minutes: context.exam.duration_minutes,
        total_marks: context.exam.total_marks,
        passing_marks: context.exam.passing_marks,
        attempt_limit: context.exam.attempt_limit,
        allow_review: context.exam.allow_review,
        proctoring_enabled: context.exam.proctoring_enabled,
        webcam_required: context.exam.webcam_required,
        microphone_required: context.exam.microphone_required,
        camera_denied_action: context.exam.camera_denied_action,
        fullscreen_required: context.exam.fullscreen_required,
        head_turn_yaw_threshold: context.exam.head_turn_yaw_threshold,
        head_turn_duration_seconds: context.exam.head_turn_duration_seconds,
        max_tab_switches: context.exam.max_tab_switches,
        instructions: context.exam.instructions,
        questions: context.orderedQuestions.map((question) => ({
          ...buildAttemptQuestionView(question, question.saved_answer?.option_order as number[] | null),
          display_order: question.saved_answer?.display_order ?? question.display_order,
          answer_state: {
            selected_answer: question.saved_answer?.selected_answer ?? null,
            marked_for_review: Boolean(question.saved_answer?.marked_for_review),
            visited: Boolean(question.saved_answer?.visited),
            time_taken_seconds: Number(question.saved_answer?.time_taken_seconds || 0)
          }
        }))
      }
    });
  } catch (error) {
    next(error);
  }
});

quizRouter.put("/save/:attemptId", async (req, res, next) => {
  try {
    const parsed = saveSchema.parse(req.body);
    const context = await fetchAttemptContext(req.params.attemptId, req.authUser!.id);
    ensureAttemptCanSave(context.attempt.status, context.attempt.expires_at);
    if (context.attempt.submission_token) throw new AppError(409, "Attempt submission is already in progress.");

    const validIds = new Set(context.orderedQuestions.map((question) => question.id));
    for (const answer of parsed.answers) {
      ensureValidDisplayedAnswer(answer.selected_answer);
      if (!validIds.has(answer.question_id)) throw new AppError(400, "Submitted question does not belong to this exam.");
      const { error } = await supabase
        .from("student_answers")
        .update({
          selected_answer: answer.selected_answer,
          marked_for_review: answer.marked_for_review,
          visited: answer.visited,
          time_taken_seconds: answer.time_taken_seconds,
          updated_at: new Date().toISOString()
        })
        .eq("attempt_id", req.params.attemptId)
        .eq("question_id", answer.question_id);
      if (error) throw new AppError(500, "Unable to save answer state.");
    }

    const { error: attemptError } = await supabase
      .from("exam_attempts")
      .update({ last_saved_at: new Date().toISOString() })
      .eq("id", req.params.attemptId);
    if (attemptError) throw new AppError(500, "Unable to update attempt progress.");

    res.json({ message: "Progress saved." });
  } catch (error) {
    next(error);
  }
});

quizRouter.post("/submit/:attemptId", async (req, res, next) => {
  try {
    const parsed = submitSchema.parse(req.body);
    const context = await fetchAttemptContext(req.params.attemptId, req.authUser!.id);
    ensureAttemptCanSubmit(context.attempt.status, Boolean(context.attempt.submission_token));

    const submissionToken = randomUUID();
    const { data: claim, error: claimError } = await supabase
      .from("exam_attempts")
      .update({ submission_token: submissionToken })
      .eq("id", req.params.attemptId)
      .eq("user_id", req.authUser!.id)
      .eq("status", "in_progress")
      .is("submission_token", null)
      .select("id")
      .maybeSingle();
    if (claimError) throw new AppError(500, "Unable to claim attempt submission.");
    if (!claim) throw new AppError(409, "Attempt submission is already in progress or complete.");

    try {
      const expired = Boolean(context.attempt.expires_at) && new Date(context.attempt.expires_at).getTime() <= Date.now();
      if (!expired && parsed.answers.length) {
      const validIds = new Set(context.orderedQuestions.map((question) => question.id));
      for (const answer of parsed.answers) {
        ensureValidDisplayedAnswer(answer.selected_answer);
        if (!validIds.has(answer.question_id)) throw new AppError(400, "Submitted question does not belong to this exam.");
        const existing = context.answers.find((item: any) => item.question_id === answer.question_id);
        const originalIndex = mapDisplayedAnswerToOriginal(answer.selected_answer, existing?.option_order as number[] | null);
        if (originalIndex !== null && (originalIndex < 0 || originalIndex > 3)) {
          throw new AppError(400, "Submitted option is invalid.");
        }
        const { error } = await supabase
          .from("student_answers")
          .update({
            selected_answer: answer.selected_answer,
            marked_for_review: answer.marked_for_review,
            visited: answer.visited,
            time_taken_seconds: answer.time_taken_seconds,
            updated_at: new Date().toISOString()
          })
          .eq("attempt_id", req.params.attemptId)
          .eq("question_id", answer.question_id);
        if (error) throw new AppError(500, "Unable to finalize submitted answers.");
      }
      }

      const result = await finalizeAttempt(req.params.attemptId, req.authUser!.id, submissionToken);
      res.json({ result });
    } catch (error) {
      await supabase
        .from("exam_attempts")
        .update({ submission_token: null })
        .eq("id", req.params.attemptId)
        .eq("status", "in_progress")
        .eq("submission_token", submissionToken);
      throw error;
    }
  } catch (error) {
    next(error);
  }
});
