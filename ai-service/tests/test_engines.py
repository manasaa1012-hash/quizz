from app.engines import next_difficulty, predict_performance, ability_score, weak_topics, recommend, revision_plan, regression_metrics
from types import SimpleNamespace

def test_adaptive_hard():
    difficulty, _ = next_difficulty([True, True, True, True, False])
    assert difficulty == "hard"

def test_prediction_bounds():
    score, confidence = predict_performance(70, 80, 5, 4)
    assert 0 <= score <= 100
    assert 0 <= confidence <= 1

def test_adaptive_easy():
    difficulty, _ = next_difficulty([False, False, True, False], "medium")
    assert difficulty == "easy"

def test_ability_bounds():
    assert 0 <= ability_score(82, 88, 35, 90, 75) <= 100

def test_weak_topic_ranking_and_recommendations():
    topics=[SimpleNamespace(topic_id=None,topic_name="Strong",attempted=10,accuracy=90,average_time=0,recent_trend=0),SimpleNamespace(topic_id=None,topic_name="Weak",attempted=10,accuracy=35,average_time=0,recent_trend=0)]
    assert weak_topics(topics)[0]["topic"] == "Weak"
    assert recommend(topics)[0]["topic"] == "Weak"

def test_revision_plan_length():
    topics=[SimpleNamespace(topic_name="Algebra",attempted=5,accuracy=45)]
    assert len(revision_plan(topics,14)) == 14

def test_prediction_metrics():
    metrics=regression_metrics([50,70,90],[55,68,88])
    assert metrics["mae"] > 0
    assert metrics["rmse"] >= metrics["mae"]
    assert -1 <= metrics["r2"] <= 1
