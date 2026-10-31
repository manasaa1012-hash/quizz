from pydantic import BaseModel, Field
from typing import List

class TopicMetric(BaseModel):
    topic_id: str | None = None
    topic_name: str
    attempted: int = 0
    correct: int = 0
    accuracy: float = 0
    average_time: float = 0
    recent_trend: float = 0

class RecommendationRequest(BaseModel):
    topics: List[TopicMetric]

class RevisionRequest(BaseModel):
    topics: List[TopicMetric]
    days: int = Field(default=7, ge=1, le=30)

class PerformanceRequest(BaseModel):
    average_score: float = 0
    recent_score: float = 0
    attempts: int = 0
    trend: float = 0
    accuracy: float = 0
    average_response_time: float = 0
    topic_mastery: float = 0

class AdaptiveRequest(BaseModel):
    recent_results: List[bool]
    current_difficulty: str = "medium"
    ability_score: float = 50

class WeakTopicRequest(BaseModel):
    topics: List[TopicMetric]

class AbilityRequest(BaseModel):
    accuracy: float = 0
    difficulty_accuracy: float = 0
    average_response_time: float = 0
    recent_accuracy: float = 0
    consistency: float = 0
