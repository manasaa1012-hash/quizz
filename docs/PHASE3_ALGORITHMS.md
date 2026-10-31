# Phase 3 learning algorithms

## Topic ability (0–100)

Topic ability is deterministic and explainable:

```text
ability = 45% overall accuracy
        + 20% difficulty-weighted accuracy
        + 15% response-speed score
        + 15% recent-five accuracy
        +  5% consistency
```

Easy, medium, and hard correct answers receive weights `0.8`, `1.0`, and `1.25`. The speed score starts at 100 and decreases after 30 seconds per answer. Consistency is `100 - standard deviation` of binary answer outcomes. Every component and the result are clamped to 0–100.

Status thresholds are configurable constants in `backend/src/utils/learningEngine.ts`: Strong ≥80, Moderate ≥60, Weak ≥40, otherwise Critical. Ability is recalculated from submitted answer snapshots and blended 65/35 with adaptive-session evidence after each adaptive response.

## Adaptive difficulty

The first question is easy below ability 45, hard at or above 75, otherwise medium. Thereafter the latest five answers control one-step movement: accuracy ≥80% increases difficulty, 50–79% maintains it, and below 50% decreases it. The backend excludes all question IDs already used in the session and falls back to an adjacent difficulty when the desired pool is empty.

## Predictions

The demo model uses average score, recent score, attempt count, trend, accuracy, average response time, and topic mastery. Outputs are clamped to 0–100. Confidence is clamped to 0–1 and risk is Low (≥70), Moderate (≥50), or High. The next submitted exam fills `actual_score` and absolute `prediction_error`.

The bundled training pipeline uses synthetic data only to demonstrate the workflow. Its MAE, RMSE, and R² must not be presented as evidence of performance on real students. Production/research use requires consented, representative, de-identified data and an independently evaluated model.
