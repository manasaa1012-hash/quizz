from pathlib import Path
import numpy as np
import joblib
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import mean_absolute_error, mean_squared_error, r2_score
import json
from sklearn.model_selection import train_test_split

rng = np.random.default_rng(42)
n = 4000

average = rng.uniform(20, 95, n)
recent = np.clip(average + rng.normal(0, 10, n), 0, 100)
attempts = rng.integers(1, 40, n)
trend = rng.normal(0, 8, n)
accuracy = np.clip(average + rng.normal(0, 12, n), 0, 100)
response_time = rng.uniform(15, 120, n)
mastery = np.clip((accuracy + recent) / 2 + rng.normal(0, 5, n), 0, 100)

target = np.clip(
    0.45 * average
    + 0.45 * recent
    + 0.10 * trend
    + np.log1p(attempts) * 1.2
    + 0.12 * accuracy + 0.08 * mastery - np.maximum(response_time-60,0)*0.03
    + rng.normal(0, 3, n),
    0, 100
)

X = np.column_stack([average, recent, attempts, trend, accuracy, response_time, mastery])
X_train, X_test, y_train, y_test = train_test_split(X, target, test_size=0.2, random_state=42)

model = RandomForestRegressor(
    n_estimators=180,
    max_depth=12,
    random_state=42,
    n_jobs=-1
)
model.fit(X_train, y_train)
pred = model.predict(X_test)
print(f"Validation MAE: {mean_absolute_error(y_test, pred):.2f}")
metrics={"mae":float(mean_absolute_error(y_test,pred)),"rmse":float(mean_squared_error(y_test,pred)**0.5),"r2":float(r2_score(y_test,pred)),"dataset":"synthetic demo data; not evidence of real-student performance"}

out = Path(__file__).resolve().parents[1] / "models" / "performance_model.joblib"
out.parent.mkdir(parents=True, exist_ok=True)
joblib.dump(model, out)
metadata={"features":["average_score","recent_score","attempts","trend","accuracy","average_response_time","topic_mastery"],"model":"RandomForestRegressor","training_data":"synthetic demonstration data"}
(out.parent/"feature_metadata.json").write_text(json.dumps(metadata,indent=2))
(out.parent/"evaluation_metrics.json").write_text(json.dumps(metrics,indent=2))
print(f"Saved model to: {out}")
