import { z } from "zod";
import { env } from "../config/env.js";
import { AppError } from "../utils/http.js";

export const generatedQuestionSchema = z.object({
  question_text: z.string().trim().min(5).max(5000),
  options: z.array(z.string().trim().min(1).max(1000)).length(4),
  correct_answer: z.number().int().min(0).max(3),
  explanation: z.string().trim().min(1).max(3000),
  difficulty: z.enum(["easy", "medium", "hard"])
});

export const generatedQuestionsSchema = z.array(generatedQuestionSchema).min(1).max(20);
export type GeneratedQuestion = z.infer<typeof generatedQuestionSchema>;

export function validateGeneratedQuestions(value: unknown, expectedCount?: number) {
  const parsed = generatedQuestionsSchema.parse(value);
  if (expectedCount !== undefined && parsed.length !== expectedCount) {
    throw new AppError(502, `AI provider returned ${parsed.length} questions; expected ${expectedCount}.`);
  }
  return parsed;
}

function extractJson(text: string) {
  const fenced = text.match(/```(?:json)?\s*([\s\S]*?)```/i)?.[1];
  const source = (fenced || text).trim();
  try { return JSON.parse(source); }
  catch { throw new AppError(502, "AI provider returned invalid JSON."); }
}

export async function generateQuestions(input: {
  subject: string; topic: string; difficulty: "easy" | "medium" | "hard";
  count: number; questionType: string;
}) {
  if (!env.aiApiKey) {
    throw new AppError(503, "AI question generation is not configured. Set AI_PROVIDER and AI_API_KEY on the backend.");
  }
  const prompt = `Generate exactly ${input.count} ${input.questionType} questions for subject "${input.subject}", topic "${input.topic}", difficulty "${input.difficulty}". Return only a JSON array. Each object must contain question_text, exactly 4 string options, correct_answer as a zero-based integer 0-3, explanation, and difficulty. Do not include markdown.`;
  let response: Response;
  try {
    response = await fetch(env.aiApiUrl, {
      method: "POST",
      headers: { "content-type": "application/json", authorization: `Bearer ${env.aiApiKey}` },
      body: JSON.stringify({
        model: env.aiModel,
        temperature: 0.4,
        messages: [
          { role: "system", content: "You create accurate assessment questions and output strict JSON only." },
          { role: "user", content: prompt }
        ]
      }),
      signal: AbortSignal.timeout(45_000)
    });
  } catch {
    throw new AppError(502, "Unable to reach the configured AI provider.");
  }
  if (!response.ok) {
    throw new AppError(502, `AI provider request failed (${response.status}). Check backend provider configuration.`);
  }
  const payload: any = await response.json();
  const content = payload?.choices?.[0]?.message?.content;
  if (typeof content !== "string") throw new AppError(502, "AI provider returned an unsupported response shape.");
  return validateGeneratedQuestions(extractJson(content), input.count);
}
