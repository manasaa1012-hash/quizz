# Database design

## profiles
Application profile for each Supabase Auth user.

## subjects / topics
Academic hierarchy used for analytics and recommendations.

## exams
Assessment metadata, duration, marks and publication state.

## questions
MCQ data. `options` is a JSON array of exactly four strings. `correct_answer` uses zero-based indexing.

## exam_attempts
One row per started quiz. Stores final score and counts when submitted.

## student_answers
Stores selected option, correctness, awarded marks and response time.
Each attempt row also stores its display order, option permutation, review/visit state, and a question snapshot so later question-bank edits cannot change an active attempt or historical review.

## performance_metrics
Aggregated topic-level attempted/correct counts, accuracy and time.

## student_stats
Leaderboard/gamification totals: XP, level, completed quizzes, current/longest streak, solved/correct counts, response time and perfect scores.

## proctoring_events
Immutable audit log for browser and local face-count events. It stores the attempt/user, server-approved event type and severity, structured details, and timestamp. Students have no mutation policy.

## proctoring_reports
One recalculated, server-owned report per attempt with the clamped 0–100 score, risk level, event counts, and explainable point contributions.

## ai_question_drafts
Admin-owned generated content with subject/topic, strict four-option question shape, provider, and `draft`, `approved`, or `saved` workflow state. Saved rows reference their Question Bank record.

## badges / student_badges
Achievement definitions and earned achievements.

## notifications
Per-user notices with read state, optional in-app links, and duplicate-safe event keys.

## Phase 4 gamification data

- `xp_transactions`: immutable, source-keyed XP ledger.
- `levels`: configurable XP thresholds and names.
- `badges` / `student_badges`: configurable criteria and unique student awards.
- `leaderboard_snapshots`: optional persisted rank checkpoints for future rank-change analysis.
- `notifications`: realtime badge, level, exam, revision and future multiplayer-invite notices.

## Phase 3 learning data

- `student_topic_ability`: explainable topic mastery score and status.
- `performance_predictions`: prediction inputs, confidence, risk, next actual score, and error.
- `recommendations`: persisted actionable advice with completion/dismissal state.
- `revision_plans` / `revision_plan_tasks`: persisted 7/14/30-day plans and task workflow.
- `adaptive_sessions` / `adaptive_session_questions`: non-repeating adaptive sequence, responses, difficulty, and ability movement.

## Security model

- RLS limits students to their own profile-derived records and published catalog data.
- Correct answers and scoring mutations are performed only by the backend service role.
- Avatar objects are writable only inside the authenticated user's folder.
- Question media is writable only by active admins inside their own storage folder.
- Auth synchronization preserves an administrator-applied suspended account state.
- Exam starts are serialized per student/exam pair, submissions are atomically claimed, and XP/stat/badge rewards are applied exactly once by a database function and unique ledger keys.
