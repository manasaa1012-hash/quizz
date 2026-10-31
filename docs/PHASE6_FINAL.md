# Phase 6 finalization

Migration `009_phase6_proctoring_ai_final.sql` adds per-exam webcam policy, structured proctor events, persisted risk reports, AI question drafts, indexes, RLS, and final question-media policy tightening.

## Risk weights

Server configuration lives in `backend/src/utils/riskScore.ts`: tab/visibility change 10, fullscreen exit 10, copy/paste 15, missing face 15, prolonged absence 20, and multiple faces 25. Window blur, context menu, selected shortcuts, camera denial/stoppage, and repeated focus loss have documented supplementary weights. Each recurrence adds 25% up to 2×; the total is clamped to 100.

## Webcam processing

Consent occurs before attempt start. `getUserMedia` is never called silently. Frames are passed directly from the local video element to pinned MediaPipe Tasks Vision approximately every three seconds. Only count/status event metadata is transmitted. No recognition, identity embeddings, snapshots, or recordings are created. WASM/model loading failures are surfaced and logged with zero risk weight; exact asset URLs and self-hosting guidance are in the root README.

## AI authoring

The backend calls a configurable OpenAI-compatible chat-completions endpoint. `AI_API_KEY` is optional at process startup; when absent, only generation is unavailable. Every response is parsed and validated for question text, four options, a zero-based correct answer, explanation, and difficulty before drafts are inserted. An admin must edit/review, approve, and separately save each draft.

## Verification

Run the commands in the root README. Database/RLS behavior and realtime flows still require a configured Supabase integration environment; local unit tests do not substitute for that deployment-level test.
