from fastapi import FastAPI
from .schemas import RecommendationRequest, RevisionRequest, PerformanceRequest, AdaptiveRequest, WeakTopicRequest, AbilityRequest
from .engines import recommend, revision_plan, predict_performance, next_difficulty, weak_topics, ability_score

app = FastAPI(
    title="QuizAI ML Service",
    version="1.0.0",
    description="Adaptive quiz, recommendation and performance prediction service."
)

@app.get("/health")
def health():
    return {"status": "ok", "service": "quiz-ai"}

@app.post("/recommendations")
def recommendations(req: RecommendationRequest):
    return {"recommendations": recommend(req.topics)}

@app.post("/revision-plan")
def make_revision_plan(req: RevisionRequest):
    return {"plan": revision_plan(req.topics, req.days)}

@app.post("/predict-performance")
def performance(req: PerformanceRequest):
    score, confidence = predict_performance(
        req.average_score, req.recent_score, req.attempts, req.trend,
        req.accuracy, req.average_response_time, req.topic_mastery
    )
    trend = "improving" if req.trend > 2 else "declining" if req.trend < -2 else "stable"
    risk = "Low" if score >= 70 else "Moderate" if score >= 50 else "High"
    return {
        "predicted_score": round(score, 2),
        "confidence": round(confidence, 2), "trend": trend, "risk_level": risk
    }

@app.post("/adaptive/next-difficulty")
def adaptive(req: AdaptiveRequest):
    difficulty, recent_accuracy = next_difficulty(req.recent_results, req.current_difficulty)
    return {
        "recommended_difficulty": difficulty,
        "recent_accuracy": round(recent_accuracy * 100, 2)
    }

@app.post("/adaptive/next-question")
def adaptive_next_question(req: AdaptiveRequest):
    difficulty, recent_accuracy = next_difficulty(req.recent_results, req.current_difficulty)
    return {"recommended_difficulty": difficulty, "recent_accuracy": round(recent_accuracy*100,2)}

@app.post("/adaptive/ability")
def adaptive_ability(req: AbilityRequest):
    score=ability_score(req.accuracy,req.difficulty_accuracy,req.average_response_time,req.recent_accuracy,req.consistency)
    return {"ability_score":round(score,2),"status":"Strong" if score>=80 else "Moderate" if score>=60 else "Weak" if score>=40 else "Critical"}

@app.post("/weak-topics")
def detect_weak_topics(req: WeakTopicRequest):
    return {"weak_topics": weak_topics(req.topics)}
