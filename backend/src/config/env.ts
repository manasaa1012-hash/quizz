import "dotenv/config";

function required(name: string, fallback?: string): string {
  const value = process.env[name] || fallback;
  if (!value) {
    throw new Error(
      `Missing environment variable: ${name}. Create backend/.env from backend/.env.example and add your Supabase credentials.`
    );
  }
  return value;
}

export const env = {
  port: Number(process.env.PORT || 5000),
  frontendUrl: process.env.FRONTEND_URL || "http://localhost:5173",
  frontendUrls: (process.env.FRONTEND_URL || "http://localhost:5173")
    .split(",")
    .map((url) => url.trim())
    .filter(Boolean),
  supabaseUrl: required("SUPABASE_URL"),
  supabaseServiceRoleKey: required("SUPABASE_SERVICE_ROLE_KEY"),
  aiProvider: process.env.AI_PROVIDER || "openai",
  aiApiKey: process.env.OPENAI_API_KEY || process.env.AI_API_KEY || "",
  aiApiUrl: process.env.AI_API_URL || "https://api.openai.com/v1/chat/completions",
  aiModel: process.env.AI_MODEL || "gpt-4.1-mini"
};
