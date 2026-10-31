import { Router } from "express";
import { requireAuth } from "../middleware/auth.js";
import { supabase } from "../config/supabase.js";
import { AppError } from "../utils/http.js";
import { mapDisplayedAnswerToOriginal } from "../utils/quizEngine.js";

export const resultsRouter = Router();
resultsRouter.use(requireAuth);

resultsRouter.get("/:attemptId", async (req, res, next) => {
  try {
    const { data: attempt, error } = await supabase
      .from("exam_attempts")
      .select("*, exams(*)")
      .eq("id", req.params.attemptId)
      .eq("user_id", req.authUser!.id)
      .maybeSingle();
    if (error || !attempt) throw new AppError(404, "Result not found");
    if (attempt.status !== "submitted") throw new AppError(409, "This attempt is not submitted yet.");

    const { error: rewardError } = await supabase.rpc("apply_attempt_rewards", {
      p_attempt_id: attempt.id,
      p_user_id: req.authUser!.id
    });
    if (rewardError) console.error("Unable to reconcile attempt rewards", rewardError);

    const exam = Array.isArray((attempt as any).exams) ? (attempt as any).exams[0] : (attempt as any).exams;
    const { data: answerRows, error: answersError } = await supabase
      .from("student_answers")
      .select("*")
      .eq("attempt_id", attempt.id)
      .order("display_order", { ascending: true });
    if (answersError) throw new AppError(500, "Unable to load answer review.");

    const questionIds = (answerRows || []).map((row) => row.question_id);
    const { data: questions, error: questionsError } = questionIds.length
      ? await supabase
          .from("questions")
          .select("id,question_text,question_image_url,options,option_images,correct_answer,explanation,marks,negative_marks")
          .in("id", questionIds)
      : { data: [] as any[], error: null };
    if (questionsError) throw new AppError(500, "Unable to load result questions.");
    const questionMap = new Map((questions || []).map((question) => [question.id, question]));

    const review = (answerRows || []).map((row) => {
      const question = row.question_snapshot || questionMap.get(row.question_id);
      if (!question) return null;
      const optionOrder = (row.option_order as number[] | null) || [0, 1, 2, 3];
      const originalSelectedAnswer = mapDisplayedAnswerToOriginal(row.selected_answer, optionOrder);
      return {
        question_id: row.question_id,
        display_order: row.display_order,
        question_text: question.question_text,
        question_image_url: question.question_image_url,
        options: optionOrder.map((index) => question.options[index]),
        option_images: question.option_images?.length ? optionOrder.map((index) => question.option_images[index] ?? null) : null,
        selected_answer: row.selected_answer,
        selected_answer_text: row.selected_answer === null ? null : question.options[optionOrder[row.selected_answer]],
        correct_answer: optionOrder.indexOf(question.correct_answer),
        correct_answer_text: question.options[question.correct_answer],
        original_selected_answer: originalSelectedAnswer,
        is_correct: row.is_correct,
        explanation: question.explanation,
        marks_awarded: row.marks_awarded,
        response_time_seconds: row.time_taken_seconds,
        marked_for_review: row.marked_for_review
      };
    }).filter(Boolean);

    const score = Number(attempt.score || 0);
    const percentage = Number(attempt.percentage || 0);
    const passed = Boolean(attempt.passed);
    const correctCount = Number(attempt.correct_count || 0);
    const xpEarned = Number(attempt.xp_earned ?? Math.round(correctCount * 10 + percentage * 0.5 + (passed ? 25 : 0)));

    res.json({
      result: {
        attempt_id: attempt.id,
        exam_id: attempt.exam_id,
        exam_title: exam?.title || "Exam",
        score,
        total_marks: Number(exam?.total_marks || 0),
        percentage,
        pass_fail: passed ? "Pass" : "Fail",
        passed,
        correct_count: correctCount,
        incorrect_count: Number(attempt.incorrect_count || 0),
        unanswered_count: Number(attempt.unanswered_count || 0),
        accuracy: Number(attempt.accuracy || 0),
        total_time_seconds: Number(attempt.total_time_seconds || 0),
        average_response_time_seconds: Number(attempt.average_response_time_seconds || 0),
        marks_gained: Number(attempt.marks_gained || 0),
        negative_marks_obtained: Number(attempt.negative_marks_obtained || 0),
        xp_earned: xpEarned,
        questions: review
      }
    });
  } catch (error) {
    next(error);
  }
});
