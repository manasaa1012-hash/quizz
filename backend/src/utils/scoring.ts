export interface SubmittedAnswer {
  question_id: string;
  selected_answer: number | null;
  time_taken_seconds?: number;
}

export interface DbQuestion {
  id: string;
  correct_answer: number;
  marks: number;
  negative_marks: number;
  topic_id?: string | null;
}

export function scoreQuiz(questions: DbQuestion[], submitted: SubmittedAnswer[]) {
  const answerMap = new Map(submitted.map(a => [a.question_id, a]));
  let score = 0, correct = 0, incorrect = 0, unanswered = 0;
  const details = questions.map(q => {
    const answer = answerMap.get(q.id);
    const selected = answer?.selected_answer ?? null;
    const isCorrect = selected === q.correct_answer;
    if (selected === null) unanswered++;
    else if (isCorrect) { correct++; score += Number(q.marks); }
    else { incorrect++; score -= Number(q.negative_marks || 0); }
    return {
      question_id: q.id,
      selected_answer: selected,
      is_correct: isCorrect,
      marks_awarded: selected === null ? 0 : isCorrect ? Number(q.marks) : -Number(q.negative_marks || 0),
      time_taken_seconds: Math.max(0, Number(answer?.time_taken_seconds || 0)),
      topic_id: q.topic_id || null
    };
  });
  return { score: Math.max(0, score), correct, incorrect, unanswered, details };
}
