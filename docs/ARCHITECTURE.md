# Architecture

```text
Browser / React + TypeScript
        |
        | Supabase Auth JWT
        v
Node.js / Express REST API
        |
        +--------------------------+
        |                          |
        v                          v
Supabase PostgreSQL          FastAPI AI Service
        |                          ^
        |                          |
        +---- Express -------- Configurable question AI provider
        |                          |
        |                          +-- Adaptive difficulty
        |                          +-- Recommendations
        |                          +-- Revision plan
        |                          +-- Score prediction
        |
        +-- Exams / Questions
        +-- Attempts / Answers
        +-- Analytics
        +-- Student XP / streak
        +-- Proctoring events
        +-- Proctoring reports
        +-- AI question drafts
```

## Security boundary

The frontend can authenticate directly using the Supabase anonymous key, but all quiz evaluation is server-side. The backend owns the service-role and AI provider keys and reads `correct_answer` only during submission. JWTs are verified against Supabase Auth, admin operations verify the database role, and database RLS limits direct anonymous/authenticated access.

## Adaptive learning

The AI service provides next-difficulty, ability, weak-topic, recommendations, revision plans, and prediction endpoints. Dedicated adaptive sessions persist their question sequence and ability movement.

## Proctoring

Browser events and locally derived camera face counts flow through an authenticated attempt-owned endpoint. The server selects severity, stores immutable events, and recalculates the report. Admin pages query report summaries and event timelines. Video does not cross the browser boundary.

## Predictive analytics

A small Random Forest regression model is included. It consumes:

- historical average score
- most recent score
- attempt count
- recent score trend

The included model is trained on synthetic demonstration data. Replace it with real anonymized student-performance data for research-grade evaluation.
