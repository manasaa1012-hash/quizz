import { BrowserRouter, Route, Routes } from "react-router-dom";
import { AuthProvider } from "./context/AuthContext";
import { RequireAuth } from "./components/RequireAuth";
import { Layout } from "./components/Layout";
import LandingPage from "./pages/LandingPage";
import ForgotPasswordPage from "./pages/ForgotPasswordPage";
import LoginPage from "./pages/LoginPage";
import RegisterPage from "./pages/RegisterPage";
import ResetPasswordPage from "./pages/ResetPasswordPage";
import StudentDashboard from "./pages/StudentDashboard";
import ExamsPage from "./pages/ExamsPage";
import ExamDetailPage from "./pages/ExamDetailPage";
import AttemptsPage from "./pages/AttemptsPage";
import QuizPage from "./pages/QuizPage";
import ResultPage from "./pages/ResultPage";
import AnalyticsPage from "./pages/AnalyticsPage";
import LeaderboardPage from "./pages/LeaderboardPage";
import RecommendationsPage from "./pages/RecommendationsPage";
import ProfilePage from "./pages/ProfilePage";
import AdminDashboard from "./pages/AdminDashboard";
import AdminExamsPage from "./pages/AdminExamsPage";
import AdminQuestionsPage from "./pages/AdminQuestionsPage";
import AdminSubjectsPage from "./pages/AdminSubjectsPage";
import AdminTopicsPage from "./pages/AdminTopicsPage";
import AdminUsersPage from "./pages/AdminUsersPage";
import AdaptivePage from "./pages/AdaptivePage";
import RevisionPlanPage from "./pages/RevisionPlanPage";
import PredictionsPage from "./pages/PredictionsPage";
import AchievementsPage from "./pages/AchievementsPage";
import NotificationsPage from "./pages/NotificationsPage";
import AdminBadgesPage from "./pages/AdminBadgesPage";
import AdminMultiplayerPage from "./pages/AdminMultiplayerPage";
import AdminProctoringPage from "./pages/AdminProctoringPage";
import AdminProctoringDetailPage from "./pages/AdminProctoringDetailPage";
import AdminAIQuestionsPage from "./pages/AdminAIQuestionsPage";
import AdminJsonImportPage from "./pages/AdminJsonImportPage";
import MultiplayerHomePage from "./pages/MultiplayerHomePage";
import CreateMultiplayerPage from "./pages/CreateMultiplayerPage";
import JoinMultiplayerPage from "./pages/JoinMultiplayerPage";
import MultiplayerRoomPage from "./pages/MultiplayerRoomPage";

export default function App() {
  return (
    <BrowserRouter>
      <AuthProvider>
        <Routes>
          <Route path="/" element={<LandingPage />} />
          <Route path="/login" element={<LoginPage />} />
          <Route path="/register" element={<RegisterPage />} />
          <Route path="/forgot-password" element={<ForgotPasswordPage />} />
          <Route path="/reset-password" element={<ResetPasswordPage />} />

          <Route element={<RequireAuth />}>
            <Route element={<Layout />}>
              <Route path="/app" element={<StudentDashboard />} />
              <Route path="/app/exams" element={<ExamsPage />} />
              <Route path="/app/exams/:id" element={<ExamDetailPage />} />
              <Route path="/app/attempts" element={<AttemptsPage />} />
              <Route path="/app/quiz/:examId" element={<QuizPage />} />
              <Route path="/app/result/:attemptId" element={<ResultPage />} />
              <Route path="/app/analytics" element={<AnalyticsPage />} />
              <Route path="/app/leaderboard" element={<LeaderboardPage />} />
              <Route path="/app/recommendations" element={<RecommendationsPage />} />
              <Route path="/app/adaptive" element={<AdaptivePage />} />
              <Route path="/app/revision-plan" element={<RevisionPlanPage />} />
              <Route path="/app/predictions" element={<PredictionsPage />} />
              <Route path="/app/achievements" element={<AchievementsPage />} />
              <Route path="/app/notifications" element={<NotificationsPage />} />
              <Route path="/app/profile" element={<ProfilePage />} />
              <Route path="/app/multiplayer" element={<MultiplayerHomePage />} />
              <Route path="/app/multiplayer/create" element={<CreateMultiplayerPage />} />
              <Route path="/app/multiplayer/join" element={<JoinMultiplayerPage />} />
              <Route path="/app/multiplayer/:roomCode" element={<MultiplayerRoomPage />} />
            </Route>
          </Route>

          <Route element={<RequireAuth admin />}>
            <Route element={<Layout admin />}>
              <Route path="/admin" element={<AdminDashboard />} />
              <Route path="/admin/subjects" element={<AdminSubjectsPage />} />
              <Route path="/admin/topics" element={<AdminTopicsPage />} />
              <Route path="/admin/questions" element={<AdminQuestionsPage />} />
              <Route path="/admin/exams" element={<AdminExamsPage />} />
              <Route path="/admin/users" element={<AdminUsersPage />} />
              <Route path="/admin/badges" element={<AdminBadgesPage />} />
              <Route path="/admin/multiplayer" element={<AdminMultiplayerPage />} />
              <Route path="/admin/proctoring" element={<AdminProctoringPage />} />
              <Route path="/admin/proctoring/:attemptId" element={<AdminProctoringDetailPage />} />
              <Route path="/admin/ai-questions" element={<AdminAIQuestionsPage />} />
              <Route path="/admin/json-import" element={<AdminJsonImportPage />} />
            </Route>
          </Route>
        </Routes>
      </AuthProvider>
    </BrowserRouter>
  );
}
