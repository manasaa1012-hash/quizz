export type Role = "student" | "admin";
export type AccountStatus = "active" | "pending_verification" | "suspended";

export interface Profile {
  id: string;
  full_name: string;
  email?: string | null;
  role: Role;
  institution?: string | null;
  college?: string | null;
  avatar_url?: string | null;
  created_at?: string;
  last_login?: string | null;
  account_status?: AccountStatus;
}

export interface Subject {
  id: string;
  name: string;
  is_active: boolean;
  created_at?: string;
  updated_at?: string;
}

export interface Topic {
  id: string;
  subject_id: string;
  name: string;
  is_active: boolean;
  created_at?: string;
  updated_at?: string;
}

export interface Question {
  id: string;
  subject_id: string;
  topic_id?: string | null;
  question_text: string;
  question_image_url?: string | null;
  options: string[];
  option_images?: (string | null)[] | null;
  correct_answer?: number;
  difficulty: "easy" | "medium" | "hard";
  marks: number;
  negative_marks: number;
  explanation?: string | null;
  is_active?: boolean;
  display_order?: number;
  created_at?: string;
}

export interface Exam {
  id: string;
  title: string;
  description?: string | null;
  subject_id?: string | null;
  subject_name?: string | null;
  duration_minutes: number;
  total_marks: number;
  passing_marks?: number;
  negative_marking?: boolean;
  start_date?: string | null;
  end_date?: string | null;
  status?: "draft" | "published" | "archived";
  shuffle_questions?: boolean;
  shuffle_options?: boolean;
  allow_review?: boolean;
  proctoring_enabled?: boolean;
  webcam_required?: boolean;
  microphone_required?: boolean;
  camera_denied_action?: "warn" | "block";
  fullscreen_required?: boolean;
  max_tab_switches?: number;
  attempt_limit?: number;
  is_published?: boolean;
  is_active?: boolean;
  question_count?: number;
  attempts_used?: number;
  instructions?: string | null;
  availability?: { can_start: boolean; status: string; message: string };
  questions?: Question[];
}

export interface AttemptSummary {
  id: string;
  exam_id: string;
  score: number;
  percentage: number;
  correct_count: number;
  incorrect_count: number;
  unanswered_count: number;
  started_at: string;
  submitted_at?: string | null;
  exams?: { title: string };
}

export interface AttemptHistoryItem {
  id: string;
  exam_id: string;
  exam_title: string;
  subject_id?: string | null;
  subject_name?: string | null;
  score: number;
  percentage: number;
  pass_fail: "Pass" | "Fail";
  started_at: string;
  submitted_at?: string | null;
  total_time_seconds?: number;
}

export interface TopicMetric {
  topic_id: string;
  topic_name: string;
  attempted: number;
  correct: number;
  accuracy: number;
}

export interface LeaderboardEntry {
  rank: number;
  user_id: string;
  full_name: string;
  total_xp: number;
  quizzes_completed: number;
  streak_days: number;
}

export interface Recommendation {
  topic: string;
  priority: "high" | "medium" | "low";
  reason: string;
  suggested_questions: number;
}
