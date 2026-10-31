import axios from "axios";
import { env } from "../config/env.js";

type TopicMetric = {
  topic_name: string;
  attempted?: number;
  accuracy?: number;
  average_time?: number;
  recent_trend?: number;
};

type AttemptFeatures = {
  average_score?: number;
  recent_score?: number;
  attempts?: number;
  trend?: number;
  accuracy?: number;
  average_response_time?: number;
  topic_mastery?: number;
};

const coachSchema = {
  name: "quiz_ai_coach",
  strict: true,
  schema: {
    type: "object",
    additionalProperties: false,
    required: ["recommendations", "prediction", "revision_plan", "weak_topics"],
    properties: {
      recommendations: {
        type: "array",
        items: {
          type: "object",
          additionalProperties: false,
          required: ["topic", "priority", "reason", "suggested_questions", "recommendation"],
          properties: {
            topic: { type: "string" },
            priority: { type: "string", enum: ["high", "medium", "low"] },
            reason: { type: "string" },
            suggested_questions: { type: "integer", minimum: 1, maximum: 100 },
            recommendation: { type: "string" }
          }
        }
      },
      prediction: {
        type: "object",
        additionalProperties: false,
        required: ["predicted_score", "confidence", "trend", "risk_level"],
        properties: {
          predicted_score: { type: "number", minimum: 0, maximum: 100 },
          confidence: { type: "number", minimum: 0, maximum: 1 },
          trend: { type: "string", enum: ["improving", "stable", "declining"] },
          risk_level: { type: "string", enum: ["Low", "Moderate", "High"] }
        }
      },
      revision_plan: {
        type: "array",
        items: {
          type: "object",
          additionalProperties: false,
          required: ["day", "topic", "activity"],
          properties: {
            day: { type: "integer", minimum: 1, maximum: 30 },
            topic: { type: "string" },
            activity: { type: "string" }
          }
        }
      },
      weak_topics: {
        type: "array",
        items: {
          type: "object",
          additionalProperties: false,
          required: ["topic", "severity", "accuracy", "response_time", "trend", "reason"],
          properties: {
            topic: { type: "string" },
            severity: { type: "string", enum: ["critical", "high", "moderate", "low"] },
            accuracy: { type: "number", minimum: 0, maximum: 100 },
            response_time: { type: "number", minimum: 0 },
            trend: { type: "number" },
            reason: { type: "string" }
          }
        }
      }
    }
  }
};

function fallbackCoach(topicMetrics: TopicMetric[], attemptFeatures: AttemptFeatures) {
  const sorted = [...topicMetrics].sort((a, b) => (a.accuracy || 0) - (b.accuracy || 0));
  return {
    recommendations: sorted.slice(0, 3).map((t, i) => ({
      topic: t.topic_name,
      priority: i === 0 ? "high" : "medium",
      reason: `Your current accuracy in ${t.topic_name} is ${Math.round(t.accuracy || 0)}%.`,
      suggested_questions: (t.accuracy || 0) < 50 ? 25 : 15,
      recommendation: "Review core concepts, then complete focused practice questions."
    })),
    prediction: {
      predicted_score: Math.max(0, Math.min(100, attemptFeatures.average_score || 0)),
      confidence: 0.55,
      trend: (attemptFeatures.trend || 0) > 2 ? "improving" : (attemptFeatures.trend || 0) < -2 ? "declining" : "stable",
      risk_level: (attemptFeatures.average_score || 0) >= 75 ? "Low" : (attemptFeatures.average_score || 0) >= 50 ? "Moderate" : "High"
    },
    weak_topics: sorted.filter(t => (t.accuracy || 0) < 60).map(t => ({
      topic: t.topic_name,
      severity: (t.accuracy || 0) < 40 ? "critical" : "high",
      accuracy: t.accuracy || 0,
      response_time: t.average_time || 0,
      trend: t.recent_trend || 0,
      reason: `Accuracy is ${Math.round(t.accuracy || 0)}% with a ${Number(t.recent_trend || 0).toFixed(1)} point recent trend.`
    })),
    revision_plan: Array.from({ length: 7 }, (_, i) => ({
      day: i + 1,
      topic: sorted[i % Math.max(sorted.length, 1)]?.topic_name || "Mixed revision",
      activity: i === 6 ? "Attempt a full mock quiz" : "Review concepts and solve practice questions"
    }))
  };
}

export async function getAICoach(topicMetrics: TopicMetric[], attemptFeatures: AttemptFeatures) {
  if (!env.aiApiKey) return fallbackCoach(topicMetrics, attemptFeatures);
  try {
    const response = await axios.post(env.aiApiUrl, {
      model: env.aiModel,
      messages: [
        { role: "system", content: "You are a supportive quiz-learning coach. Use only the supplied learning data. Return practical, concise advice." },
        { role: "user", content: `Create a seven-day study plan, focused recommendations, weak-topic analysis, and a cautious score estimate from this JSON data: ${JSON.stringify({ topics: topicMetrics, performance: attemptFeatures })}` }
      ],
      response_format: { type: "json_schema", json_schema: coachSchema },
      temperature: 0.3
    }, {
      timeout: 45_000,
      headers: { authorization: `Bearer ${env.aiApiKey}` }
    });
    const content = response.data?.choices?.[0]?.message?.content;
    if (typeof content !== "string") throw new Error("AI response did not contain structured content.");
    return JSON.parse(content);
  } catch {
    return fallbackCoach(topicMetrics, attemptFeatures);
  }
}
