import type { ReactNode } from "react";
import { useEffect, useState } from "react";
import {
  Activity,
  ArrowRight,
  Award,
  BookOpen,
  BrainCircuit,
  CheckCircle2,
  ClipboardList,
  Crown,
  Flame,
  Medal,
  Sparkles,
  Target,
  TrendingUp,
  Trophy,
  XCircle
} from "lucide-react";
import { Link } from "react-router-dom";
import { Line, LineChart, ResponsiveContainer, Tooltip, XAxis, YAxis } from "recharts";
import { EmptyState } from "../components/EmptyState";
import { MetricCard } from "../components/MetricCard";
import { ProgressRing } from "../components/ProgressRing";
import { useAuth } from "../context/AuthContext";
import { api } from "../lib/api";

type DashboardResponse = {
  stats: {
    quizzes_completed: number;
    total_xp: number;
    streak_days: number;
  };
  questions_attempted: number;
  correct_count: number;
  incorrect_count: number;
  average_percentage: number;
  best_percentage: number;
  latest_attempt?: {
    id: string;
    exam_title: string;
    percentage: number;
    submitted_at?: string | null;
  } | null;
  recent_attempts: Array<{
    id: string;
    exam_title: string;
    percentage: number;
    submitted_at?: string | null;
  }>;
};

type AnalyticsTopic = {
  topic_id?: string;
  topic_name?: string;
  status?: string;
  ability_score?: number;
  accuracy?: number;
};

type RecommendationItem = {
  id?: string;
  recommendation?: string;
  reason?: string;
  priority?: string;
  topics?: { name?: string | null } | null;
};

type RevisionTask = {
  id: string;
  activity?: string;
  scheduled_date?: string;
  day_number?: number;
  status?: "pending" | "completed" | "skipped";
  topics?: { name?: string | null } | null;
};

type InsightsState = {
  analytics?: {
    topic_performance?: AnalyticsTopic[];
    score_over_time?: Array<{ label: string; score: number }>;
  };
  prediction?: {
    predicted_score?: number;
    risk_level?: string;
    trend?: string;
    confidence?: number;
  } | null;
  plan?: {
    tasks?: RevisionTask[];
    completion_percentage?: number;
  } | null;
  game?: {
    stats?: {
      total_xp?: number;
      longest_streak?: number;
    };
    level?: {
      current?: { level_number?: number; name?: string };
      next?: { level_number?: number };
      xp_to_next?: number;
      progress_percentage?: number;
    };
    global_rank?: number;
    recent_achievement?: {
      name?: string;
      earned_at?: string;
    } | null;
    badges?: Array<{ id: string; name?: string; earned?: boolean; earned_at?: string | null }>;
  } | null;
  weekly?: Array<{
    user_id: string;
    full_name?: string;
    rank?: number;
    period_xp?: number;
  }>;
  recommendations?: RecommendationItem[];
};

function formatShortDate(value?: string | null) {
  if (!value) return "Just now";
  return new Date(value).toLocaleDateString(undefined, { day: "numeric", month: "short", year: "numeric" });
}

function scoreTone(score: number) {
  if (score >= 75) return "good";
  if (score >= 40) return "warn";
  return "danger";
}

function scoreMessage(score: number) {
  if (score >= 75) return "Strong momentum";
  if (score >= 40) return "Room to improve";
  return "Needs attention";
}

function DashboardSectionHeader({
  title,
  description,
  action
}: {
  title: string;
  description: string;
  action?: ReactNode;
}) {
  return (
    <div className="dashboard-section-heading">
      <div>
        <h2>{title}</h2>
        <p>{description}</p>
      </div>
      {action}
    </div>
  );
}

function MetricChip({ label, value, tone = "neutral" }: { label: string; value: string; tone?: "neutral" | "success" | "warning" | "primary" }) {
  return (
    <div className={`metric-chip ${tone}`}>
      <span>{label}</span>
      <strong>{value}</strong>
    </div>
  );
}

export default function StudentDashboard() {
  const { profile } = useAuth();
  const [data, setData] = useState<DashboardResponse | null>(null);
  const [insights, setInsights] = useState<InsightsState | null>(null);

  useEffect(() => {
    api.get("/dashboard")
      .then((response) => setData(response.data))
      .catch(() => setData(null));

    Promise.all([
      api.get("/analytics/me"),
      api.get("/ai/predictions"),
      api.get("/ai/revision-plan"),
      api.get("/gamification/me"),
      api.get("/leaderboard", { params: { scope: "weekly" } }),
      api.get("/ai/recommendations")
    ])
      .then(([analytics, predictions, plan, game, weekly, recommendations]) => setInsights({
        analytics: analytics.data,
        prediction: predictions.data.predictions?.[0] || null,
        plan: plan.data,
        game: game.data,
        weekly: weekly.data.leaderboard || [],
        recommendations: recommendations.data.recommendations || []
      }))
      .catch(() => setInsights(null));
  }, []);

  const firstName = profile?.full_name?.split(" ")[0] || "Student";
  const quizzesCompleted = data?.stats?.quizzes_completed ?? 0;
  const totalXp = Number(insights?.game?.stats?.total_xp ?? data?.stats?.total_xp ?? 0);
  const streakDays = data?.stats?.streak_days ?? 0;
  const averageScore = Math.round(data?.average_percentage ?? 0);
  const bestPercentage = Math.round(data?.best_percentage ?? 0);
  const questionsAttempted = data?.questions_attempted ?? 0;
  const correctAnswers = data?.correct_count ?? 0;
  const incorrectAnswers = data?.incorrect_count ?? 0;
  const accuracy = questionsAttempted ? Math.round((correctAnswers / questionsAttempted) * 100) : 0;
  const weakTopics = (insights?.analytics?.topic_performance || []).filter((topic) => topic.status === "Weak" || topic.status === "Critical");
  const strongTopics = (insights?.analytics?.topic_performance || []).filter((topic) => topic.status === "Strong");
  const currentLevel = insights?.game?.level?.current;
  const nextLevel = insights?.game?.level?.next;
  const xpToNext = Number(insights?.game?.level?.xp_to_next ?? 0);
  const progressPercent = Number(insights?.game?.level?.progress_percentage ?? 0);
  const weeklyRow = (insights?.weekly || []).find((row) => row.user_id === profile?.id);
  const recentAchievement = insights?.game?.recent_achievement;
  const earnedBadges = (insights?.game?.badges || []).filter((badge) => badge.earned);
  const latestAttempt = data?.latest_attempt || null;
  const nextTask = (insights?.plan?.tasks || []).find((task) => task.status !== "completed");
  const nextRecommendation = insights?.recommendations?.[0];
  const latestScoreTone = scoreTone(Math.round(latestAttempt?.percentage ?? 0));

  return (
    <div className="student-dashboard">
      <section className="dashboard-hero card">
        <div className="dashboard-hero-copy">
          <span className="eyebrow">STUDENT DASHBOARD</span>
          <h2>Hello, {firstName}</h2>
          <p>Track completed exams, accuracy, and your next best study move.</p>
          <div className="dashboard-hero-actions">
            <Link className="button" to="/app/exams">Browse Exams</Link>
            <div className="dashboard-status-note">
              <Sparkles size={16} />
              <span>{currentLevel ? `Level ${currentLevel.level_number} · ${currentLevel.name}` : "Learning profile updating"}</span>
            </div>
          </div>
        </div>
        <div className="dashboard-hero-side">
          <MetricChip label="Average score" value={`${averageScore}%`} tone="primary" />
          <MetricChip label="Best result" value={`${bestPercentage}%`} tone="success" />
          <MetricChip label="Weekly rank" value={weeklyRow?.rank ? `#${weeklyRow.rank}` : "Unranked"} tone="warning" />
        </div>
      </section>

      <div className="metrics dashboard-metrics">
        <MetricCard icon={ClipboardList} title="Quizzes completed" value={quizzesCompleted} subtitle={quizzesCompleted ? `${Math.min(quizzesCompleted, 5)} recent tracked` : "Start your first exam"} accent="primary" />
        <MetricCard icon={Award} title="Total XP" value={`${totalXp} XP`} subtitle={nextLevel ? `${xpToNext} XP to next level` : "Top level reached"} accent="violet" />
        <MetricCard icon={Flame} title="Current streak" value={`${streakDays} day${streakDays === 1 ? "" : "s"}`} subtitle={streakDays ? "Keep the momentum going" : "Complete an exam today"} accent="warning" />
        <MetricCard icon={CheckCircle2} title="Average score" value={`${averageScore}%`} subtitle={scoreMessage(averageScore)} accent={averageScore >= 60 ? "success" : "danger"} />
      </div>

      <div className="dashboard-grid dashboard-grid-top">
        <section className="card learning-progress-card">
          <DashboardSectionHeader
            title={`Level ${currentLevel?.level_number || 1} · ${currentLevel?.name || "Starter"}`}
            description="A compact view of your current standing and what it takes to level up."
            action={<Link to="/app/achievements">Achievements</Link>}
          />
          <div className="learning-progress-overview">
            <div>
              <strong className="learning-progress-xp">{totalXp} XP</strong>
              <p>{nextLevel ? `${xpToNext} XP to Level ${nextLevel.level_number}` : "You have reached the highest configured level."}</p>
            </div>
            <div className="progress progress-premium" aria-label="Level progress">
              <span style={{ width: `${progressPercent}%` }} />
            </div>
          </div>
          <div className="metric-chip-grid">
            <MetricChip label="Progress" value={`${Math.round(progressPercent)}%`} tone="primary" />
            <MetricChip label="Global rank" value={insights?.game?.global_rank ? `#${insights.game.global_rank}` : "Unranked"} tone="neutral" />
            <MetricChip label="Weekly rank" value={weeklyRow?.rank ? `#${weeklyRow.rank}` : "Unranked"} tone="warning" />
            <MetricChip label="Longest streak" value={`${insights?.game?.stats?.longest_streak || 0} days`} tone="success" />
          </div>
        </section>

        <section className={`card latest-result-card ${latestScoreTone}`}>
          <DashboardSectionHeader
            title="Latest Result"
            description="Your newest submitted exam stays front and center for quick review."
            action={latestAttempt ? <Link to={`/app/result/${latestAttempt.id}`}>Open Result Review</Link> : undefined}
          />
          {latestAttempt ? (
            <div className="latest-result-content">
              <div>
                <span className="result-kicker">{formatShortDate(latestAttempt.submitted_at)}</span>
                <h3>{latestAttempt.exam_title}</h3>
                <p>{Math.round(latestAttempt.percentage)}% scored on your most recent completed exam.</p>
              </div>
              <div className="latest-result-meta">
                <div className="result-score-orb">
                  <strong>{Math.round(latestAttempt.percentage)}%</strong>
                  <span>{Math.round(latestAttempt.percentage) >= 40 ? "Completed" : "Review needed"}</span>
                </div>
                <Link className="button secondary" to={`/app/result/${latestAttempt.id}`}>
                  <Trophy size={17} />
                  Open Result Review
                </Link>
              </div>
            </div>
          ) : (
            <EmptyState
              icon={Activity}
              title="No completed attempt yet"
              description="Start an exam to build your performance history and generate smarter guidance."
              action={<Link className="button small" to="/app/exams">Start an Exam</Link>}
            />
          )}
        </section>
      </div>

      <div className="dashboard-grid dashboard-grid-middle">
        <section className="card performance-card">
          <DashboardSectionHeader
            title="Performance Overview"
            description="A fast read on volume, accuracy, and exam performance quality."
            action={<Link to="/app/attempts">View attempts</Link>}
          />
          <div className="performance-layout">
            <ProgressRing value={accuracy} label="accuracy" caption={`${correctAnswers} correct out of ${questionsAttempted || 0}`} tone={accuracy >= 60 ? "success" : accuracy >= 40 ? "warning" : "primary"} />
            <div className="performance-metrics">
              <div className="performance-stat success">
                <span><CheckCircle2 size={16} /> Correct answers</span>
                <strong>{correctAnswers}</strong>
              </div>
              <div className="performance-stat danger">
                <span><XCircle size={16} /> Incorrect answers</span>
                <strong>{incorrectAnswers}</strong>
              </div>
              <div className="performance-stat">
                <span><ClipboardList size={16} /> Questions attempted</span>
                <strong>{questionsAttempted}</strong>
              </div>
              <div className="performance-stat primary">
                <span><TrendingUp size={16} /> Best percentage</span>
                <strong>{bestPercentage}%</strong>
              </div>
            </div>
          </div>
          {insights?.analytics?.score_over_time?.length ? (
            <div className="dashboard-mini-chart">
              <ResponsiveContainer width="100%" height={200}>
                <LineChart data={insights.analytics.score_over_time}>
                  <XAxis dataKey="label" tickLine={false} axisLine={false} />
                  <YAxis domain={[0, 100]} tickLine={false} axisLine={false} width={34} />
                  <Tooltip />
                  <Line type="monotone" dataKey="score" stroke="#6b5cff" strokeWidth={3} dot={false} />
                </LineChart>
              </ResponsiveContainer>
            </div>
          ) : (
            <div className="dashboard-inline-empty">Complete quizzes to build your progress trend.</div>
          )}
        </section>

        <section className="card badges-card">
          <DashboardSectionHeader
            title="Badges & Achievements"
            description="Your latest recognition and how your learning momentum is stacking up."
            action={<Link to="/app/achievements">View all</Link>}
          />
          {recentAchievement ? (
            <div className="achievement-spotlight">
              <div className="achievement-icon"><Award size={22} /></div>
              <div>
                <strong>{recentAchievement.name}</strong>
                <p>Earned {formatShortDate(recentAchievement.earned_at)}</p>
              </div>
            </div>
          ) : (
            <div className="dashboard-inline-empty">Complete learning milestones to unlock badges.</div>
          )}
          <div className="metric-chip-grid compact">
            <MetricChip label="Earned badges" value={`${earnedBadges.length}`} tone="warning" />
            <MetricChip label="Strong topics" value={`${strongTopics.length}`} tone="success" />
            <MetricChip label="Weak topics" value={`${weakTopics.length}`} tone={weakTopics.length ? "warning" : "neutral"} />
          </div>
        </section>
      </div>

      <div className="dashboard-grid dashboard-grid-bottom">
        <section className="card leaderboard-preview-card">
          <DashboardSectionHeader
            title="Leaderboard Preview"
            description="A quick look at the current weekly standings."
            action={<Link to="/app/leaderboard">Open leaderboard</Link>}
          />
          {(insights?.weekly || []).length ? (
            <div className="leaderboard-preview-list">
              {(insights?.weekly || []).slice(0, 5).map((entry) => {
                const isCurrentUser = entry.user_id === profile?.id;
                return (
                  <div className={`leaderboard-preview-row${isCurrentUser ? " current" : ""}`} key={entry.user_id}>
                    <div className="leaderboard-rank">
                      {entry.rank === 1 ? <Crown size={16} /> : entry.rank && entry.rank <= 3 ? <Medal size={16} /> : <span>#{entry.rank || "-"}</span>}
                    </div>
                    <div className="leaderboard-student">
                      <strong>{entry.full_name || "Student"}</strong>
                      <small>{isCurrentUser ? "You" : "Weekly learner"}</small>
                    </div>
                    <strong className="leaderboard-points">{entry.period_xp || 0} XP</strong>
                  </div>
                );
              })}
            </div>
          ) : (
            <EmptyState icon={Trophy} title="No weekly rankings yet" description="Complete learning activities to appear on this leaderboard." />
          )}
        </section>

        <section className="card up-next-card">
          <DashboardSectionHeader
            title="Up Next"
            description="Continue with the most relevant next step from your existing learning data."
            action={nextTask ? <Link to="/app/revision-plan">Open plan</Link> : <Link to="/app/recommendations">AI Coach</Link>}
          />
          {nextTask ? (
            <div className="up-next-panel">
              <div className="up-next-copy">
                <span className="up-next-tag">Revision task</span>
                <h3>{nextTask.topics?.name || `Day ${nextTask.day_number || 1}`}</h3>
                <p>{nextTask.activity || "Review concepts and solve targeted questions."}</p>
                <small>Scheduled for {formatShortDate(nextTask.scheduled_date)}</small>
              </div>
              <Link className="button secondary" to="/app/revision-plan">
                Continue
                <ArrowRight size={16} />
              </Link>
            </div>
          ) : nextRecommendation ? (
            <div className="up-next-panel">
              <div className="up-next-copy">
                <span className="up-next-tag">Recommended focus</span>
                <h3>{nextRecommendation.topics?.name || "AI Coach guidance"}</h3>
                <p>{nextRecommendation.recommendation || nextRecommendation.reason || "Complete a quiz to generate tailored study guidance."}</p>
                <small>{nextRecommendation.priority ? `${nextRecommendation.priority} priority` : "Personalized action"}</small>
              </div>
              <Link className="button secondary" to="/app/recommendations">
                Continue
                <ArrowRight size={16} />
              </Link>
            </div>
          ) : (
            <EmptyState icon={BrainCircuit} title="No next step generated yet" description="Complete a quiz to unlock personalized recommendations and revision tasks." action={<Link className="button small" to="/app/exams">Browse Exams</Link>} />
          )}
        </section>
      </div>

      <div className="dashboard-grid dashboard-grid-support">
        <section className="card recent-attempts-card">
          <DashboardSectionHeader
            title="Recent Attempts"
            description="Your latest submitted exams with quick score visibility."
            action={<Link to="/app/attempts">See full history</Link>}
          />
          {!data?.recent_attempts?.length ? (
            <div className="dashboard-inline-empty">No completed exams yet. Your first result will show up here.</div>
          ) : (
            <div className="recent-attempts-list">
              {data.recent_attempts.map((attempt) => (
                <div className="attempt-row premium" key={attempt.id}>
                  <div>
                    <strong>{attempt.exam_title}</strong>
                    <small>{attempt.submitted_at ? new Date(attempt.submitted_at).toLocaleString() : "Submitted recently"}</small>
                  </div>
                  <div className={`score-pill ${scoreTone(Math.round(attempt.percentage))}`}>{Math.round(attempt.percentage)}%</div>
                </div>
              ))}
            </div>
          )}
        </section>

        <section className="card topic-ability-card">
          <DashboardSectionHeader
            title="Topic Ability"
            description="A compact summary of where you are strongest and where to focus next."
            action={<Link to="/app/adaptive">Adaptive practice</Link>}
          />
          <div className="topic-ability-summary">
            <MetricChip label="Strong topics" value={`${strongTopics.length}`} tone="success" />
            <MetricChip label="Weak or critical" value={`${weakTopics.length}`} tone={weakTopics.length ? "warning" : "neutral"} />
          </div>
          <div className="topic-list">
            {(insights?.analytics?.topic_performance || []).slice(0, 3).map((topic, index) => (
              <div className="topic-list-row" key={topic.topic_id || `${topic.topic_name}-${index}`}>
                <div>
                  <strong>{topic.topic_name || "Topic"}</strong>
                  <small>{topic.status || "Unrated"}</small>
                </div>
                <div className="topic-list-score">
                  <span>{topic.accuracy ?? 0}%</span>
                  <small>Ability {topic.ability_score ?? 0}</small>
                </div>
              </div>
            ))}
            {!insights?.analytics?.topic_performance?.length && <div className="dashboard-inline-empty">Complete more quizzes to unlock topic-level insight.</div>}
          </div>
        </section>
      </div>
    </div>
  );
}
