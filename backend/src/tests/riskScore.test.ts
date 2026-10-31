import assert from "node:assert/strict";
import test from "node:test";
import { calculateRisk, classifyRisk } from "../utils/riskScore.js";

test("risk classifications match the documented boundaries", () => {
  assert.equal(classifyRisk(20), "Low");
  assert.equal(classifyRisk(21), "Moderate");
  assert.equal(classifyRisk(51), "Suspicious");
  assert.equal(classifyRisk(76), "High Risk");
});

test("risk weights escalate repeated behavior and clamp to 100", () => {
  const basic = calculateRisk([{ event_type: "tab_switch" }, { event_type: "copy_attempt" }]);
  assert.equal(basic.riskScore, 25);
  assert.equal(basic.riskLevel, "Moderate");
  const repeated = calculateRisk(Array.from({ length: 10 }, () => ({ event_type: "multiple_faces" })));
  assert.equal(repeated.riskScore, 100);
  assert.ok(repeated.calculation.raw_score > 100);
});

test("unknown client event types cannot affect risk", () => {
  assert.equal(calculateRisk([{ event_type: "made_up" }]).riskScore, 0);
});
