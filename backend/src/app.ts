import express from "express";
import cors from "cors";
import helmet from "helmet";
import morgan from "morgan";
import { env } from "./config/env.js";
import { authRouter } from "./routes/auth.js";
import { examsRouter } from "./routes/exams.js";
import { quizRouter } from "./routes/quiz.js";
import { resultsRouter } from "./routes/results.js";
import { dashboardRouter } from "./routes/dashboard.js";
import { analyticsRouter } from "./routes/analytics.js";
import { leaderboardRouter } from "./routes/leaderboard.js";
import { aiRouter } from "./routes/ai.js";
import { proctoringRouter } from "./routes/proctoring.js";
import { adminRouter } from "./routes/admin.js";
import { profileRouter } from "./routes/profile.js";
import { attemptsRouter } from "./routes/attempts.js";
import { adaptiveRouter } from "./routes/adaptive.js";
import { gamificationRouter } from "./routes/gamification.js";
import { notificationsRouter } from "./routes/notifications.js";
import { adminGamificationRouter } from "./routes/adminGamification.js";
import { adminMultiplayerRouter, multiplayerRouter } from "./routes/multiplayer.js";
import { adminAIQuestionsRouter } from "./routes/adminAIQuestions.js";
import { presenceRouter } from "./routes/presence.js";
import { errorHandler, notFound } from "./middleware/error.js";
import { createRateLimit } from "./utils/rateLimit.js";

export const app = express();
app.use(helmet());
app.disable("x-powered-by");
app.set("trust proxy", 1);
app.use(cors({
  origin(origin, callback) {
    if (!origin || env.frontendUrls.includes(origin)) return callback(null, true);
    return callback(new Error("Origin is not allowed by CORS."));
  },
  credentials: true
}));
app.use(express.json({ limit: "1mb" }));
app.use(morgan("dev"));
app.use(createRateLimit({ windowMs: 60_000, max: 240 }));

app.get("/api/health", (_req,res)=>res.json({status:"ok",service:"quiz-backend"}));
app.use("/api/auth", authRouter);
app.use("/api/presence", presenceRouter);
app.use("/api/profile", profileRouter);
app.use("/api/exams", examsRouter);
app.use("/api/quiz", quizRouter);
app.use("/api/results", resultsRouter);
app.use("/api/attempts", attemptsRouter);
app.use("/api/adaptive", adaptiveRouter);
app.use("/api/gamification", gamificationRouter);
app.use("/api/notifications", notificationsRouter);
app.use("/api/multiplayer", multiplayerRouter);
app.use("/api/dashboard", dashboardRouter);
app.use("/api/analytics", analyticsRouter);
app.use("/api/leaderboard", leaderboardRouter);
app.use("/api/ai", aiRouter);
app.use("/api/proctoring", proctoringRouter);
app.use("/api/admin", adminRouter);
app.use("/api/admin", adminGamificationRouter);
app.use("/api/admin", adminMultiplayerRouter);
app.use("/api/admin", adminAIQuestionsRouter);

app.use(notFound);
app.use(errorHandler);
