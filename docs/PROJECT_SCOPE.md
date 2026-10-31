# Project scope

This ZIP is a complete functional MVP/codebase aligned with the supplied synopsis.

Implemented:
- full frontend routing and UI
- Supabase authentication
- PostgreSQL schema and seed data
- admin content management
- timed MCQ engine
- automatic scoring
- analytics
- leaderboard and XP
- streak tracking
- browser anti-cheating logs
- explicit webcam consent and local face presence/count monitoring
- persisted proctoring risk reports and admin timelines
- approval-gated external AI question generation
- AI recommendations
- seven-day revision planning
- adaptive-difficulty API
- predictive model service
- Docker configuration
- documentation

Webcam monitoring is disabled per exam by default and requires explicit consent. It performs local presence/count detection with MediaPipe Tasks Vision; no recognition, embeddings, snapshots, or recordings are used. Production deployments must validate HTTPS, model-asset availability, consent/privacy text, and local policy before enabling it.
