from pathlib import Path
import os
try:
    import joblib
except ImportError:  # Allows deterministic fallback logic without ML extras installed.
    joblib = None

BASE_DIR = Path(__file__).resolve().parents[1]
MODEL_PATH = Path(os.getenv("MODEL_PATH", BASE_DIR / "models" / "performance_model.joblib"))

def recommend(topics):
    ordered = sorted(topics, key=lambda x: (x.accuracy, -x.attempted))
    items = []
    for i, t in enumerate(ordered[:5]):
        if t.attempted == 0:
            continue
        priority = "high" if t.accuracy < 50 else "medium" if t.accuracy < 75 else "low"
        items.append({
            "topic": t.topic_name,
            "priority": priority,
            "reason": f"Current accuracy is {round(t.accuracy)}% across {t.attempted} attempted question(s).",
            "suggested_questions": 25 if t.accuracy < 50 else 15 if t.accuracy < 75 else 10,
            "recommendation": "Review core concepts, study recent mistakes, then complete targeted practice."
        })
    return items

def revision_plan(topics, days=7):
    weak = sorted([t for t in topics if t.attempted > 0], key=lambda x: x.accuracy)
    if not weak:
        return [{"day": i+1, "topic": "Mixed fundamentals", "activity": "Review concepts and solve 15 practice questions"} for i in range(days)]
    plan = []
    for i in range(days):
        topic = weak[i % len(weak)]
        if i == days - 1:
            activity = "Attempt a timed mixed mock test and review mistakes"
        elif topic.accuracy < 50:
            activity = "Relearn core concepts, make short notes, then solve 20-25 questions"
        else:
            activity = "Revise key formulas/concepts and solve 15 targeted questions"
        plan.append({"day": i+1, "topic": topic.topic_name, "activity": activity})
    return plan

def predict_performance(average_score, recent_score, attempts, trend, accuracy=0, average_response_time=0, topic_mastery=0):
    x = [[average_score, recent_score, attempts, trend, accuracy, average_response_time, topic_mastery]]
    if MODEL_PATH.exists() and joblib is not None:
        try:
            model = joblib.load(MODEL_PATH)
            pred = float(model.predict(x)[0])
            confidence = min(0.92, 0.58 + min(attempts, 10) * 0.03)
            return max(0.0, min(100.0, pred)), confidence
        except Exception:
            pass
    mastery = topic_mastery or accuracy or average_score
    speed_adjustment = max(-5, min(5, (60-average_response_time)/12)) if average_response_time else 0
    pred = 0.40 * recent_score + 0.30 * average_score + 0.20 * mastery + 0.10 * max(-15, min(15, trend)) + speed_adjustment
    confidence = min(0.8, 0.45 + attempts * 0.03)
    return max(0.0, min(100.0, pred)), confidence

def next_difficulty(recent_results, current="medium"):
    if not recent_results:
        return current, 0.5
    acc = sum(recent_results[-5:]) / min(len(recent_results), 5)
    if acc >= 0.8:
        return "hard", acc
    levels = ["easy", "medium", "hard"]
    index = levels.index(current) if current in levels else 1
    if acc < 0.5:
        return levels[max(0, index-1)], acc
    return current, acc

def weak_topics(topics):
    ranked=[]
    for topic in topics:
        if topic.attempted <= 0:
            continue
        severity = "critical" if topic.accuracy < 40 else "high" if topic.accuracy < 60 else "moderate" if topic.accuracy < 75 else "low"
        ranked.append({"topic_id":topic.topic_id,"topic":topic.topic_name,"severity":severity,"accuracy":round(topic.accuracy,2),"response_time":round(topic.average_time,2),"trend":round(topic.recent_trend,2),"reason":f"{round(topic.accuracy)}% accuracy with a {round(topic.recent_trend,1)} point recent trend."})
    order={"critical":0,"high":1,"moderate":2,"low":3}
    return sorted(ranked,key=lambda item:(order[item["severity"]],item["accuracy"]))

def ability_score(accuracy,difficulty_accuracy,average_response_time,recent_accuracy,consistency):
    speed=max(0,min(100,100-max(0,average_response_time-30)*1.25))
    value=accuracy*.45+difficulty_accuracy*.20+speed*.15+recent_accuracy*.15+consistency*.05
    return max(0,min(100,value))

def regression_metrics(actual, predicted):
    if not actual or len(actual) != len(predicted):
        raise ValueError("actual and predicted must be non-empty and equal length")
    errors=[a-p for a,p in zip(actual,predicted)]
    mae=sum(abs(e) for e in errors)/len(errors)
    rmse=(sum(e*e for e in errors)/len(errors))**0.5
    mean=sum(actual)/len(actual)
    denominator=sum((a-mean)**2 for a in actual)
    r2=1-(sum(e*e for e in errors)/denominator) if denominator else (1.0 if all(e==0 for e in errors) else 0.0)
    return {"mae":mae,"rmse":rmse,"r2":r2}
