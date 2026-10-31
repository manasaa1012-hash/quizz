# API summary

Base URL: `http://localhost:5000/api`

All routes except health require a Supabase access token:

```text
Authorization: Bearer <token>
```

## Authentication
- `GET /auth/me`

## Student
- `GET /dashboard`
- `GET /exams`
- `GET /exams/:id`
- `POST /quiz/start/:examId`
- `GET /quiz/attempt/:attemptId`
- `PUT /quiz/save/:attemptId`
- `POST /quiz/submit/:attemptId`
- `GET /results/:attemptId`
- `GET /attempts` — paginated history; supports `subject_id`, `date_from`, `date_to`, `result`, `min_score`, and `max_score`
- `GET /analytics/me`
- `GET /adaptive/options`
- `POST /adaptive/sessions`
- `POST /adaptive/sessions/:id/next`
- `GET /adaptive/sessions/:id/result`
- `GET /ai/recommendations`
- `POST /ai/recommendations/regenerate`
- `PATCH /ai/recommendations/:id`
- `GET|POST /ai/revision-plan`
- `PATCH /ai/revision-plan/tasks/:id`
- `GET|POST /ai/predictions`
- `GET /leaderboard` — `scope=global|daily|weekly|monthly|subject|exam`; subject/exam scopes require the matching ID
- `GET /leaderboard/options`
- `GET /gamification/me`
- `GET /gamification/achievements`
- `GET /notifications`
- `PATCH /notifications/:id/read`
- `POST /notifications/read-all`
- `GET /ai/coach`
- `POST /proctoring/event`

## Admin
- `GET /admin/dashboard`
- `GET /admin/users`
- `GET /admin/subjects`
- `POST /admin/subjects`
- `PATCH /admin/subjects/:id`
- `DELETE /admin/subjects/:id`
- `GET /admin/topics`
- `POST /admin/topics`
- `PATCH /admin/topics/:id`
- `DELETE /admin/topics/:id`
- `GET /admin/questions`
- `GET /admin/questions/:id`
- `PATCH /admin/questions/:id`
- `DELETE /admin/questions/:id`
- `GET /admin/exams`
- `POST /admin/exams`
- `PATCH /admin/exams/:id`
- `DELETE /admin/exams/:id`
- `POST /admin/exams/:id/publish`
- `POST /admin/exams/:id/unpublish`
- `POST /admin/exams/:id/duplicate`
- `POST /admin/exams/:id/questions`
- `DELETE /admin/exams/:id/questions/:questionId`
- `PATCH /admin/exams/:id/questions/reorder`
- `POST /admin/questions`
- `GET|POST /admin/badges`
- `PATCH|DELETE /admin/badges/:id`
- `GET /admin/gamification-stats`
- `GET /proctoring/reports` — admin; exam/student/date/risk filters and pagination
- `GET /proctoring/reports/:attemptId` — admin; report calculation and chronological event timeline
- `GET /admin/ai-questions/config`
- `GET /admin/ai-questions/drafts`
- `POST /admin/ai-questions/generate`
- `PATCH /admin/ai-questions/drafts/:id`
- `POST /admin/ai-questions/drafts/:id/approve`
- `POST /admin/ai-questions/drafts/:id/save`

`POST /proctoring/event` accepts an active owned attempt, a server-whitelisted event type, and a bounded JSON `details` object. Severity and risk are server-owned. AI draft saving requires the distinct `draft → approved → saved` state transition.

## AI service (`:8000`)
- `GET /health`
- `POST /recommendations`
- `POST /revision-plan`
- `POST /predict-performance`
- `POST /adaptive/next-difficulty`
- `POST /adaptive/next-question`
- `POST /adaptive/ability`
- `POST /weak-topics`
