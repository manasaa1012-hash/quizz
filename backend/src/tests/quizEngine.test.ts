import assert from "node:assert/strict";
import test from "node:test";
import {
  buildAttemptQuestionView,
  ensureAttemptCanSave,
  ensureAttemptCanStart,
  ensureAttemptCanSubmit,
  ensureAttemptOwnership,
  ensureValidDisplayedAnswer,
  mapDisplayedAnswerToOriginal,
  shuffleIndices,
  summarizeSavedAnswers
} from "../utils/quizEngine.js";
import { AppError } from "../utils/http.js";

test("shuffleIndices returns every index exactly once", () => {
  const sequence = [0.8, 0.1, 0.3, 0.5];
  let pointer = 0;
  const shuffled = shuffleIndices(4, () => sequence[pointer++] ?? 0);

  assert.equal(shuffled.length, 4);
  assert.deepEqual([...shuffled].sort((a, b) => a - b), [0, 1, 2, 3]);
});

test("buildAttemptQuestionView respects option order", () => {
  const question = {
    id: "q1",
    question_text: "Question",
    options: ["A", "B", "C", "D"],
    correct_answer: 2,
    difficulty: "medium" as const,
    marks: 2,
    negative_marks: 0.5
  };

  const view = buildAttemptQuestionView(question, [2, 0, 3, 1]);
  assert.deepEqual(view.options, ["C", "A", "D", "B"]);
});

test("mapDisplayedAnswerToOriginal remaps shuffled answer indexes", () => {
  assert.equal(mapDisplayedAnswerToOriginal(1, [2, 0, 3, 1]), 0);
  assert.equal(mapDisplayedAnswerToOriginal(null, [2, 0, 3, 1]), null);
});

test("summarizeSavedAnswers scores correct, wrong, and unanswered responses", () => {
  const questions = [
    {
      id: "q1",
      question_text: "One",
      options: ["A", "B", "C", "D"],
      correct_answer: 1,
      difficulty: "easy" as const,
      marks: 2,
      negative_marks: 0.5,
      topic_id: "t1"
    },
    {
      id: "q2",
      question_text: "Two",
      options: ["A", "B", "C", "D"],
      correct_answer: 3,
      difficulty: "medium" as const,
      marks: 3,
      negative_marks: 1,
      topic_id: "t2"
    },
    {
      id: "q3",
      question_text: "Three",
      options: ["A", "B", "C", "D"],
      correct_answer: 0,
      difficulty: "hard" as const,
      marks: 5,
      negative_marks: 2,
      topic_id: "t3"
    }
  ];

  const summary = summarizeSavedAnswers(questions, [
    { question_id: "q1", selected_answer: 2, option_order: [3, 2, 1, 0], time_taken_seconds: 12, visited: true },
    { question_id: "q2", selected_answer: 0, option_order: [1, 3, 0, 2], time_taken_seconds: 20, visited: true },
    { question_id: "q3", selected_answer: null, option_order: [0, 1, 2, 3], time_taken_seconds: 8, visited: true }
  ]);

  assert.equal(summary.correct, 1);
  assert.equal(summary.incorrect, 1);
  assert.equal(summary.unanswered, 1);
  assert.equal(summary.score, 1);
  assert.equal(summary.marksGained, 2);
  assert.equal(summary.negativeMarks, 1);
  assert.equal(summary.totalTimeSeconds, 40);
  assert.equal(summary.averageResponseTimeSeconds, 40 / 3);
});

test("ensureAttemptCanStart rejects closed or over-limit exams", () => {
  assert.throws(
    () =>
      ensureAttemptCanStart({
        is_published: true,
        status: "published",
        is_active: true,
        submitted_count: 2,
        attempt_limit: 2
      }),
    (error: unknown) => error instanceof AppError && error.status === 409
  );

  assert.throws(
    () =>
      ensureAttemptCanStart({
        is_published: true,
        status: "published",
        is_active: true,
        end_date: "2020-01-01T00:00:00.000Z",
        submitted_count: 0,
        attempt_limit: 1,
        now: Date.parse("2026-08-18T00:00:00.000Z")
      }),
    (error: unknown) => error instanceof AppError && error.status === 403
  );
});

test("negative marking can be disabled per exam", () => {
  const questions = [{
    id: "q1", question_text: "One", options: ["A", "B", "C", "D"], correct_answer: 0,
    difficulty: "easy" as const, marks: 2, negative_marks: 0.5
  }];
  const summary = summarizeSavedAnswers(
    questions,
    [{ question_id: "q1", selected_answer: 1, time_taken_seconds: 3 }],
    { negativeMarking: false }
  );
  assert.equal(summary.incorrect, 1);
  assert.equal(summary.score, 0);
  assert.equal(summary.negativeMarks, 0);
  assert.equal(summary.details[0].marks_awarded, 0);
});

test("response time is capped by the server-provided attempt budget", () => {
  const questions = [0, 1].map((index) => ({
    id: `q${index}`, question_text: "Question", options: ["A", "B", "C", "D"], correct_answer: 0,
    difficulty: "easy" as const, marks: 1, negative_marks: 0
  }));
  const summary = summarizeSavedAnswers(
    questions,
    questions.map((question) => ({ question_id: question.id, selected_answer: null, time_taken_seconds: 9999 })),
    { maxTotalTimeSeconds: 60 }
  );
  assert.equal(summary.totalTimeSeconds, 60);
});

test("duplicate submission and expired autosave are rejected", () => {
  assert.throws(
    () => ensureAttemptCanSubmit("submitted"),
    (error: unknown) => error instanceof AppError && error.status === 409
  );
  assert.throws(
    () => ensureAttemptCanSave("submitted", null),
    (error: unknown) => error instanceof AppError && error.status === 409
  );
  assert.throws(
    () => ensureAttemptCanSave("in_progress", "2020-01-01T00:00:00.000Z", Date.parse("2020-01-01T00:00:01.000Z")),
    (error: unknown) => error instanceof AppError && error.status === 409
  );
});

test("unauthorized attempt access and invalid option indexes are rejected", () => {
  assert.throws(
    () => ensureAttemptOwnership("owner", "other-user"),
    (error: unknown) => error instanceof AppError && error.status === 404
  );
  assert.throws(
    () => ensureValidDisplayedAnswer(4),
    (error: unknown) => error instanceof AppError && error.status === 400
  );
  assert.doesNotThrow(() => ensureValidDisplayedAnswer(null));
});
