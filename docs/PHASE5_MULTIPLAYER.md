# Phase 5 multiplayer

## Runtime model

Multiplayer uses the existing Supabase project, profile identities, question bank, exams, XP ledger, levels, badges, leaderboard stats, and notifications. The Express API authenticates every action and calls service-role-only database functions for atomic mutations. Clients subscribe to Postgres Changes on `multiplayer_rooms`, `multiplayer_participants`, `multiplayer_answers`, and `multiplayer_results`; an event triggers an authoritative API refresh.

The room state machine is `lobby → countdown → question → reveal → question … → finished`. `starts_at`, `question_started_at`, `question_ends_at`, and `reveal_ends_at` are database timestamps. Clients render timers against those timestamps and call the idempotent advance operation only at a boundary or after the final answer; local timers never decide the state.

## Scoring and XP

A wrong answer earns 0. A correct answer earns `1000 + floor(500 × remaining milliseconds / allotted milliseconds)`, from 1000 through 1500 points. PostgreSQL derives elapsed time from its own clock and the room's question timestamp. Final ordering is score descending, correct answers descending, average response time ascending, then join time.

Each saved result awards 25 participation XP plus 75/40/20 XP for first/second/third. The unique XP ledger key `(user, source_type, source_id, reason)` and unique room result prevent repeat rewards. Total XP, level, eligible total-XP badges, and result notifications are updated server-side.

## Security and recovery

RLS exposes room state only to public-room discovery, active members, or admins. There are no client mutation policies. Only backend RPCs can join, start, answer, advance, or finish. Open lobbies expire after two hours. The answer RPC locks the room, checks active membership and the server deadline, reads the correct answer privately, computes score, and relies on a unique participant/question constraint. Answer rows are client-readable only during reveal/finish; unrevealed question responses cannot leak correctness.

Refresh/reconnect restores state through `GET /api/multiplayer/rooms/:code`. A running game remains server-controlled if the host disconnects. Before start, an explicit host leave transfers host to the oldest active participant; an empty lobby closes. Admins can terminate stuck or abusive rooms at `/admin/multiplayer`.
