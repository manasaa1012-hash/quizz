import assert from "node:assert/strict";
import test from "node:test";
import { calculateAbility, chooseAdaptiveDifficulty, classifyTopic, improvementRate, predictionRisk, selectAdaptiveQuestion } from "../utils/learningEngine.js";

test("ability calculation stays bounded and rewards hard correct answers", () => {
  const strong = calculateAbility(Array.from({ length: 6 }, () => ({ correct: true, difficulty: "hard" as const, responseTimeSeconds: 25 })));
  assert.ok(strong.ability >= 80 && strong.ability <= 100);
  assert.equal(strong.status, "Strong");
});
test("adaptive difficulty increases and decreases without leaving bounds", () => {
  assert.equal(chooseAdaptiveDifficulty([true,true,true,true,true], "medium", 60), "hard");
  assert.equal(chooseAdaptiveDifficulty([false,false,true,false,false], "medium", 60), "easy");
  assert.equal(chooseAdaptiveDifficulty([], "medium", 82), "hard");
});
test("topic classification thresholds are deterministic", () => {
  assert.equal(classifyTopic(39.9), "Critical");
  assert.equal(classifyTopic(55), "Weak");
  assert.equal(classifyTopic(70), "Moderate");
  assert.equal(classifyTopic(85), "Strong");
});
test("improvement and prediction risk are bounded classifications", () => {
  assert.equal(improvementRate([40,50,70,80]), 30);
  assert.equal(predictionRisk(45), "High");
  assert.equal(predictionRisk(90), "Low");
});
test("adaptive selection never repeats a used question", () => {
  const selected=selectAdaptiveQuestion([{id:"used",difficulty:"hard" as const},{id:"fresh",difficulty:"medium" as const}],new Set(["used"]),"hard");
  assert.equal(selected?.id,"fresh");
});
