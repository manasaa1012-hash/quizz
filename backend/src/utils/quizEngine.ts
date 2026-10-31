import { AppError } from "./http.js";

export type AttemptQuestion = {
  id: string;
  question_text: string;
  question_image_url?: string | null;
  options: string[];
  option_images?: (string | null)[] | null;
  correct_answer: number;
  difficulty: "easy" | "medium" | "hard";
  marks: number;
  negative_marks: number;
  explanation?: string | null;
  topic_id?: string | null;
};

export type SavedAnswerRow = {
  question_id: string;
  selected_answer: number | null;
  time_taken_seconds: number;
  marked_for_review?: boolean;
  visited?: boolean;
  display_order?: number | null;
  option_order?: number[] | null;
};

export function shuffleIndices(size: number, random = Math.random): number[] {
  const values = Array.from({ length: size }, (_, index) => index);
  for (let index = values.length - 1; index > 0; index -= 1) {
    const swapIndex = Math.floor(random() * (index + 1));
    [values[index], values[swapIndex]] = [values[swapIndex], values[index]];
  }
  return values;
}

export function mapDisplayedAnswerToOriginal(displayedAnswer: number | null, optionOrder?: number[] | null) {
  if (displayedAnswer === null || displayedAnswer === undefined) return null;
  if (!optionOrder?.length) return displayedAnswer;
  return optionOrder[displayedAnswer] ?? null;
}

export function ensureValidDisplayedAnswer(displayedAnswer: number | null) {
  if (displayedAnswer !== null && (!Number.isInteger(displayedAnswer) || displayedAnswer < 0 || displayedAnswer > 3)) {
    throw new AppError(400, "Selected answer must be null or an option index from 0 to 3");
  }
}

export function ensureAttemptOwnership(attemptUserId: string, authenticatedUserId: string) {
  if (attemptUserId !== authenticatedUserId) throw new AppError(404, "Attempt not found");
}

export function ensureAttemptCanSave(status: string, expiresAt?: string | null, now = Date.now()) {
  if (status !== "in_progress") throw new AppError(409, "Attempt is no longer editable.");
  if (expiresAt && new Date(expiresAt).getTime() <= now) {
    throw new AppError(409, "Attempt time has expired. Submit the saved progress to view the result.");
  }
}

export function buildAttemptQuestionView(
  question: AttemptQuestion,
  optionOrder?: number[] | null
) {
  const order = optionOrder?.length ? optionOrder : [0, 1, 2, 3];
  return {
    id: question.id,
    question_text: question.question_text,
    question_image_url: question.question_image_url ?? null,
    options: order.map((index) => question.options[index]),
    option_images: question.option_images?.length ? order.map((index) => question.option_images?.[index] ?? null) : null,
    difficulty: question.difficulty,
    marks: question.marks,
    negative_marks: question.negative_marks
  };
}

export function ensureAttemptCanStart(input: {
  is_published: boolean;
  status: string;
  is_active?: boolean;
  start_date?: string | null;
  end_date?: string | null;
  submitted_count: number;
  attempt_limit: number;
  now?: number;
}) {
  const now = input.now ?? Date.now();
  if (!input.is_published || input.status !== "published" || input.is_active === false) {
    throw new AppError(404, "Exam not available");
  }
  if (input.start_date && new Date(input.start_date).getTime() > now) {
    throw new AppError(403, "This exam is not open yet");
  }
  if (input.end_date && new Date(input.end_date).getTime() < now) {
    throw new AppError(403, "This exam is already closed");
  }
  if (input.submitted_count >= input.attempt_limit) {
    throw new AppError(409, "Attempt limit reached for this exam");
  }
}

export function ensureAttemptCanSubmit(status: string, submissionInProgress = false) {
  if (status === "submitted") {
    throw new AppError(409, "Attempt already submitted");
  }
  if (status !== "in_progress" || submissionInProgress) throw new AppError(409, "Attempt submission is already in progress");
}

export function computeAttemptNumber(submittedCount: number) {
  return submittedCount + 1;
}

export function summarizeSavedAnswers(
  questions: AttemptQuestion[],
  answers: SavedAnswerRow[],
  options: { negativeMarking?: boolean; maxTotalTimeSeconds?: number } = {}
) {
  const answerMap = new Map(answers.map((answer) => [answer.question_id, answer]));
  let correct = 0;
  let incorrect = 0;
  let unanswered = 0;
  let score = 0;
  let marksGained = 0;
  let negativeMarks = 0;
  let totalTimeSeconds = 0;

  let remainingTimeBudget = options.maxTotalTimeSeconds ?? Number.POSITIVE_INFINITY;
  const details = questions.map((question) => {
    const saved = answerMap.get(question.id);
    const selectedAnswer = saved?.selected_answer ?? null;
    const originalAnswer = mapDisplayedAnswerToOriginal(selectedAnswer, saved?.option_order);
    const isCorrect = originalAnswer === question.correct_answer;
    const requestedTime = Math.max(0, Number(saved?.time_taken_seconds || 0));
    const timeTaken = Math.min(requestedTime, remainingTimeBudget);
    remainingTimeBudget -= timeTaken;
    totalTimeSeconds += timeTaken;

    let marksAwarded = 0;
    if (originalAnswer === null) {
      unanswered += 1;
    } else if (isCorrect) {
      correct += 1;
      marksAwarded = Number(question.marks);
      score += marksAwarded;
      marksGained += marksAwarded;
    } else {
      incorrect += 1;
      marksAwarded = options.negativeMarking === false ? 0 : -Number(question.negative_marks || 0);
      score += marksAwarded;
      negativeMarks += Math.abs(marksAwarded);
    }

    return {
      question_id: question.id,
      selected_answer: selectedAnswer,
      original_selected_answer: originalAnswer,
      correct_answer: question.correct_answer,
      is_correct: isCorrect,
      marks_awarded: marksAwarded,
      time_taken_seconds: timeTaken,
      marked_for_review: Boolean(saved?.marked_for_review),
      visited: Boolean(saved?.visited),
      option_order: saved?.option_order ?? null,
      topic_id: question.topic_id ?? null
    };
  });

  return {
    score: Math.max(0, score),
    correct,
    incorrect,
    unanswered,
    details,
    marksGained,
    negativeMarks,
    totalTimeSeconds,
    averageResponseTimeSeconds: questions.length ? totalTimeSeconds / questions.length : 0
  };
}
