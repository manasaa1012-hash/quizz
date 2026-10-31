export const PROCTOR_EVENT_CONFIG = {
  tab_switch: { weight: 10, severity: "medium" },
  visibility_hidden: { weight: 10, severity: "medium" },
  window_blur: { weight: 5, severity: "low" },
  fullscreen_exit: { weight: 10, severity: "medium" },
  copy_attempt: { weight: 15, severity: "high" },
  paste_attempt: { weight: 15, severity: "high" },
  context_menu: { weight: 3, severity: "low" },
  prohibited_shortcut: { weight: 8, severity: "medium" },
  repeated_focus_loss: { weight: 12, severity: "high" },
  face_missing: { weight: 15, severity: "high" },
  prolonged_face_absence: { weight: 20, severity: "critical" },
  multiple_faces: { weight: 25, severity: "critical" },
  camera_denied: { weight: 10, severity: "medium" },
  camera_stopped: { weight: 15, severity: "high" },
  camera_detection_unavailable: { weight: 0, severity: "info" }
  ,head_turn_sustained: { weight: 20, severity: "high" }
} as const;

export type ProctorEventType = keyof typeof PROCTOR_EVENT_CONFIG;

export function isProctorEventType(value: string): value is ProctorEventType {
  return Object.prototype.hasOwnProperty.call(PROCTOR_EVENT_CONFIG, value);
}

export function classifyRisk(score: number) {
  if (score <= 20) return "Low";
  if (score <= 50) return "Moderate";
  if (score <= 75) return "Suspicious";
  return "High Risk";
}

export function calculateRisk(events: Array<{ event_type: string }>) {
  const counts: Record<string, number> = {};
  const contributions: Record<string, number> = {};
  let rawScore = 0;
  for (const event of events) {
    if (!isProctorEventType(event.event_type)) continue;
    const count = (counts[event.event_type] || 0) + 1;
    counts[event.event_type] = count;
    const base = PROCTOR_EVENT_CONFIG[event.event_type].weight;
    const multiplier = Math.min(2, 1 + (count - 1) * 0.25);
    const points = Math.round(base * multiplier);
    contributions[event.event_type] = (contributions[event.event_type] || 0) + points;
    rawScore += points;
  }
  const riskScore = Math.max(0, Math.min(100, rawScore));
  return {
    riskScore,
    riskLevel: classifyRisk(riskScore),
    counts,
    calculation: { raw_score: rawScore, clamped_score: riskScore, repeat_multiplier: "1 + 0.25 per recurrence, capped at 2x", contributions }
  };
}
