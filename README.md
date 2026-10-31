# QuizAI — AI-Powered Quiz and Exam Platform

QuizAI is a full-stack assessment platform for timed exams, adaptive learning, analytics, gamification, realtime multiplayer quizzes, privacy-aware proctoring, and administrator-reviewed AI question generation. Scores, XP, multiplayer results, and proctoring risk are calculated by trusted backend/database code rather than accepted from the browser.

## Features

### Student experience

- Supabase Auth registration, email verification, login, password reset, and profile management
- Published exam catalog, availability windows, attempt limits, instructions, timers, autosave, review flags, and automatic submission
- Server-authoritative scoring with optional negative marking and safe post-submission answer review
- Attempt history, analytics, strong/weak topics, adaptive practice, recommendations, revision plans, and bounded score predictions
- XP ledger, levels, streaks, badges, achievements, realtime leaderboards, and notifications
- Realtime multiplayer rooms with lobby/readiness, timed questions, server scoring, rankings, and XP
- Explicit webcam consent plus local face presence/count monitoring for configured proctored exams

### Administration

- Real database dashboard metrics for users, exams, questions, attempts, average score, active multiplayer rooms, suspicious/high-risk cases, registrations, and submissions
- User status management and subject, topic, question, image-question, exam, badge, and multiplayer administration
- Search/filter/pagination on large management and proctoring views
- Proctoring report list and per-attempt chronological evidence/risk calculation
- AI question generation as drafts with mandatory preview/edit/approve/save workflow

## Architecture

```text
React/Vite browser
  ├─ Supabase Auth + Realtime (anon key, RLS)
  └─ Bearer-authenticated REST → Express/TypeScript backend
                                  ├─ Supabase service role (server only)
                                  ├─ FastAPI learning service
                                  └─ Configurable AI question provider

Supabase PostgreSQL
  ├─ catalog, attempts, immutable answer snapshots, analytics
  ├─ XP/badges/notifications and multiplayer state/results
  └─ proctoring events/reports and AI drafts
```

Webcam frames remain in the browser and are processed by MediaPipe Tasks Vision. Only event metadata is sent to the backend. Facial recognition, identity matching, embeddings, and continuous raw-video storage are not implemented.

## Repository layout

```text
frontend/             React + TypeScript + Vite UI
backend/              Express + TypeScript REST API
ai-service/           FastAPI learning/prediction service and model training
supabase/migrations/  Ordered PostgreSQL/RLS migrations
supabase/seed/        Catalog/demo content (never Auth users)
docs/                 API, database, architecture, and phase notes
docker-compose.yml    Three local application services
```

## Prerequisites

- Node.js 20+ and npm
- Python 3.11–3.13 (3.12 recommended; pinned Pydantic does not support Python 3.14)
- A Supabase project
- Docker with Compose, optional
- HTTPS in deployment for camera access (`localhost` is allowed during development)

## Supabase setup

Create a project, then apply every migration in numeric order using the Supabase SQL editor or CLI:

```text
001_initial_schema.sql
002_phase1_foundation.sql
003_phase2_exam_engine.sql
004_phase1_security_hardening.sql
005_phase2_exam_engine_hardening.sql
006_phase3_personalized_learning.sql
007_phase4_gamification_notifications.sql
008_phase5_multiplayer.sql
009_phase6_proctoring_ai_final.sql
010_seed_keys.sql
```

Then apply `supabase/seed/seed.sql`, and optionally run `supabase/seed/validate_seed.sql` to verify the seeded subject, topic, question, difficulty, and exam-mapping counts. The seed creates academic/demo content only. It intentionally does not invent Supabase Auth users or credentials.

Enable Realtime for the tables added to the publication by migrations 007 and 008. Confirm the migration statements succeeded in your Supabase project.

### Create an administrator

Register a real user through the UI, copy that user's UUID from Supabase Auth, and run:

```sql
UPDATE public.profiles
SET role='admin'
WHERE id='<USER_UUID>';
```

## Environment configuration

Copy each example before running locally:

```bash
cp frontend/.env.example frontend/.env
cp backend/.env.example backend/.env
```

Frontend:

```env
VITE_SUPABASE_URL=https://YOUR_PROJECT.supabase.co
VITE_SUPABASE_ANON_KEY=YOUR_ANON_KEY
VITE_API_URL=/api
```

During development, Vite forwards `/api` to `http://127.0.0.1:5000`, so login works when opening the frontend through localhost or the computer's LAN address. Docker Compose sets the proxy target to `http://backend:5000`. Restart Vite after changing environment configuration. For production, configure your web server to forward `/api` to the backend, or set `VITE_API_URL` to the deployed API URL and include the frontend origin in the backend's `FRONTEND_URL` allowlist.

Backend (never expose the service-role or AI key through a `VITE_` variable):

```env
PORT=5000
FRONTEND_URL=http://localhost:5173
SUPABASE_URL=https://YOUR_PROJECT.supabase.co
SUPABASE_SERVICE_ROLE_KEY=YOUR_SERVICE_ROLE_KEY
AI_PROVIDER=openai
OPENAI_API_KEY=your_openai_api_key
AI_API_URL=https://api.openai.com/v1/chat/completions
AI_MODEL=gpt-4.1-mini
```

The OpenAI key is used only by the backend for question generation and learning-coach features; never place it in a frontend `VITE_` variable. `AI_API_KEY` is also accepted for compatibility. If no key is configured or the provider request fails, learning-coach features use local fallback suggestions; question generation returns a safe `503` configuration message. Generated questions are always stored as drafts and never auto-published.

## Run locally

Terminal 1:

```bash
cd backend
npm install
npm run dev
```

Terminal 2:

```bash
cd frontend
npm install
npm run dev
```

Open `http://localhost:5173`. The backend health endpoint is `http://localhost:5000/api/health`.

### Docker

Create the frontend and backend `.env` files first, then run:

```bash
docker compose up --build
```

## Testing and builds

```bash
cd backend && npm test && npm run build
cd ../frontend && npm run build
cd ../ai-service && .venv/bin/python -m pip check && .venv/bin/python -m pytest -q
```

Windows PowerShell equivalent:

```powershell
cd backend; npm.cmd test; npm.cmd run build
cd ..\frontend; npm.cmd run build
cd ..\ai-service; .\.venv-win\Scripts\python.exe -m pip check; .\.venv-win\Scripts\python.exe -m pytest tests -q
```

The included prediction model is trained on synthetic demonstration data. Current recorded demonstration metrics are MAE `2.6046`, RMSE `3.3362`, and R² `0.9807`; they are not evidence of real-student accuracy. Retrain and validate on representative, consented production data before making consequential decisions.

## Proctoring behavior and privacy

Admins configure browser proctoring, fullscreen, webcam requirement, and camera-denial action (`warn` or `block`) per exam. Webcam exams display a consent screen before creating/resuming the attempt or requesting permission. The browser uses pinned `@mediapipe/tasks-vision` 1.0.1 every three seconds to count faces locally. WASM loads from `https://cdn.jsdelivr.net/npm/@mediapipe/tasks-vision@1.0.1/wasm` and the BlazeFace model loads from `https://storage.googleapis.com/mediapipe-models/face_detector/blaze_face_short_range/float16/1/blaze_face_short_range.tflite`; allow those origins in deployment CSP/firewalls, or self-host the same assets and update the two URLs in `QuizPage.tsx`. Raw frames are not uploaded.

Browser monitoring records visibility/tab changes, blur, fullscreen exit, copy, paste, context menu, selected shortcuts, and repeated focus loss without blocking ordinary accessibility interactions. The server owns the event whitelist/severity and recalculates a 0–100 report after each accepted event. Risk bands are Low (0–20), Moderate (21–50), Suspicious (51–75), and High Risk (76–100). Repeated behavior escalates by 25% per recurrence up to 2×.

## Security model

- Supabase access tokens are verified server-side with `auth.getUser`; admin routes also require the persisted admin profile role.
- Helmet, origin-allowlisted CORS, JSON size limits, route rate limiting, Zod validation, and safe 5xx errors are enabled.
- The service-role key and AI key are backend-only.
- Students cannot insert/update/delete proctoring records through RLS.
- Correct answers are withheld during active attempts. Scoring, negative marks, attempt limits, XP, badges, and multiplayer outcomes are server/database authoritative.
- Question media is limited to JPEG/PNG/WebP, 7 MiB, and an authenticated admin-owned folder. Avatars are limited to 5 MiB and the authenticated user's folder.

## Known limitations

- Browser anti-cheating is an audit/deterrence layer, not a guarantee; OS-level activity cannot be fully observed by a web page.
- Local face counting requires WebAssembly and access to the pinned MediaPipe WASM/model origins. Loading failure is surfaced and logged; self-host the assets for offline or tightly restricted deployments.
- Camera/fullscreen APIs require user permission and a secure context in production.
- No snapshots or recordings are stored. Adding either requires explicit product configuration, retention/access controls, legal review, and new consent text.
- AI output can be inaccurate; administrator review and explicit approval are mandatory.
- The model is demonstration-trained with synthetic data and is not production-calibrated.
- The frontend production bundle currently emits a non-fatal chunk-size optimization warning.
#   q u i z z  
 