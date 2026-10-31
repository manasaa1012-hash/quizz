import assert from "node:assert/strict";
import test from "node:test";
import { validateGeneratedQuestions } from "../services/questionGenerator.js";

const valid = { question_text: "Which value is prime?", options: ["4", "6", "7", "8"], correct_answer: 2, explanation: "Seven has two factors.", difficulty: "easy" };
test("AI question output accepts the required strict shape", () => assert.equal(validateGeneratedQuestions([valid], 1)[0].correct_answer, 2));
test("AI question output rejects missing options and out-of-range answers", () => {
  assert.throws(() => validateGeneratedQuestions([{ ...valid, options: ["1", "2"], correct_answer: 9 }]));
});
