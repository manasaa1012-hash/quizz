export type LearningObservation = {
  correct: boolean;
  difficulty: "easy" | "medium" | "hard";
  responseTimeSeconds: number;
  occurredAt?: string;
};

const clamp = (value: number) => Math.max(0, Math.min(100, value));

export function classifyTopic(ability: number) {
  if (ability >= 80) return "Strong" as const;
  if (ability >= 60) return "Moderate" as const;
  if (ability >= 40) return "Weak" as const;
  return "Critical" as const;
}

export function calculateAbility(observations: LearningObservation[]) {
  if (!observations.length) return { ability: 50, trend: 0, status: "Moderate" as const };
  const accuracy = observations.filter((item) => item.correct).length / observations.length * 100;
  const weights = { easy: 0.8, medium: 1, hard: 1.25 };
  const difficultyScore = observations.reduce((sum, item) => sum + (item.correct ? 100 : 0) * weights[item.difficulty], 0)
    / observations.reduce((sum, item) => sum + weights[item.difficulty], 0);
  const averageTime = observations.reduce((sum, item) => sum + Math.max(0, item.responseTimeSeconds), 0) / observations.length;
  const speedScore = clamp(100 - Math.max(0, averageTime - 30) * 1.25);
  const recent = observations.slice(-5);
  const recentAccuracy = recent.filter((item) => item.correct).length / recent.length * 100;
  const values: number[] = observations.map((item) => item.correct ? 100 : 0);
  const variance = values.reduce((sum, value) => sum + (value - accuracy) ** 2, 0) / values.length;
  const consistency = clamp(100 - Math.sqrt(variance));
  const first = observations.slice(0, Math.min(5, observations.length));
  const firstAccuracy = first.filter((item) => item.correct).length / first.length * 100;
  const trend = recentAccuracy - firstAccuracy;
  const ability = clamp(accuracy * 0.45 + difficultyScore * 0.20 + speedScore * 0.15 + recentAccuracy * 0.15 + consistency * 0.05);
  return { ability: Number(ability.toFixed(2)), trend: Number(trend.toFixed(2)), status: classifyTopic(ability) };
}

export function chooseAdaptiveDifficulty(recentResults: boolean[], previous: "easy" | "medium" | "hard", ability = 50) {
  if (!recentResults.length) return ability >= 75 ? "hard" : ability < 45 ? "easy" : "medium";
  const recent = recentResults.slice(-5);
  const accuracy = recent.filter(Boolean).length / recent.length;
  const order = ["easy", "medium", "hard"] as const;
  const index = order.indexOf(previous);
  if (accuracy >= 0.8) return order[Math.min(2, index + 1)];
  if (accuracy < 0.5) return order[Math.max(0, index - 1)];
  return previous;
}

export function improvementRate(scores: number[]) {
  if (scores.length < 2) return 0;
  const split = Math.max(1, Math.floor(scores.length / 2));
  const average = (items: number[]) => items.reduce((sum, value) => sum + value, 0) / items.length;
  return Number((average(scores.slice(split)) - average(scores.slice(0, split))).toFixed(2));
}

export function predictionRisk(score: number) {
  return score >= 70 ? "Low" as const : score >= 50 ? "Moderate" as const : "High" as const;
}

export function selectAdaptiveQuestion<T extends { id: string; difficulty: "easy" | "medium" | "hard" }>(candidates: T[], usedIds: Set<string>, desired: "easy" | "medium" | "hard") {
  const available = candidates.filter((item) => !usedIds.has(item.id));
  const fallback = desired === "hard" ? ["hard","medium","easy"] : desired === "easy" ? ["easy","medium","hard"] : ["medium","easy","hard"];
  return fallback.map((level) => available.find((item) => item.difficulty === level)).find(Boolean) || null;
}
