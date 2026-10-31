# Phase 4 gamification and ranking rules

## Authoritative XP

XP is calculated inside `public.apply_attempt_rewards`, using stored answer snapshots and the submitted attempt. Frontend values are never accepted. Each component is written to `xp_transactions` with a unique `(user_id, source_type, source_id, reason)` key.

- Correct answer: 10 XP
- Hard correct answer: 5 additional XP
- Completed quiz: 30 XP
- Perfect completed quiz: 100 additional XP
- First meaningful activity of a UTC day: 20 XP

The attempt row is locked and `reward_applied_at` prevents repeat processing. The XP ledger provides a second duplicate barrier.

## Levels and streaks

Levels are rows in `levels`; the highest threshold not exceeding total XP is current. Progress is measured between the current and next thresholds. Quiz submission is meaningful streak activity. More than one quiz on the same UTC date does not increase the streak. A consecutive date increments it; a gap resets it to one. Longest streak never decreases.

## Badges

Active badge definitions are evaluated after a successful reward. Supported criteria are completed quizzes, solved questions, total XP, streak, aggregate accuracy, average speed, perfect scores, subject accuracy, and global rank. The `(user_id, badge_id)` primary key prevents duplicate awards. Badge and level awards create duplicate-safe notifications.

## Leaderboard ranking

- Global/daily/weekly/monthly: XP descending, accuracy descending, quizzes completed descending, name ascending.
- Subject: average submitted score descending, aggregate accuracy descending, quizzes completed descending.
- Exam: each student's best attempt; percentage descending, completion time ascending, submission time ascending.

Daily, weekly, and monthly periods use UTC boundaries. Rankings use only persisted attempts, XP transactions, and stats—never placeholder rows. Supabase Realtime changes trigger a fresh API calculation so the server remains the ranking authority.
