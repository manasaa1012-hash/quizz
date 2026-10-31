import { ArrowRight, BarChart3, BrainCircuit, Medal, ShieldCheck } from "lucide-react";
import { Link } from "react-router-dom";
import learningHero from "../assets/landing-learning-hero.png";

export default function LandingPage() {
  return (
    <div className="landing">
      <header className="topbar">
        <div className="brand dark">Quiz<span>AI</span></div>
        <div className="top-actions">
          <Link className="ghost-link" to="/login">Login</Link>
          <Link className="button" to="/register">Get Started</Link>
        </div>
      </header>

      <section className="hero">
        <div>
          <span className="eyebrow">AI-POWERED ADAPTIVE LEARNING</span>
          <h1>Smarter quizzes. Better insights. Faster improvement.</h1>
          <p>
            Adaptive assessments, real-time analytics, personalized revision plans,
            gamification and secure online examination tools in one platform.
          </p>
          <div className="hero-actions">
            <Link className="button large" to="/register">
              Start Learning <ArrowRight size={18} />
            </Link>
            <Link className="button secondary large" to="/login">Sign In</Link>
          </div>
        </div>
        <div className="hero-visual">
          <img src={learningHero} alt="Student learning with personalized AI insights" />
        </div>
      </section>

      <section className="features">
        {[
          [BrainCircuit, "Adaptive Quizzes", "Difficulty adjusts using performance and recent answers."],
          [BarChart3, "Deep Analytics", "Track scores, accuracy, topic mastery and progress."],
          [Medal, "Gamification", "XP, streaks and leaderboards keep learning engaging."],
          [ShieldCheck, "Secure Assessments", "Browser event monitoring and suspicious activity logs."]
        ].map(([Icon, title, text]: any) => (
          <article className="feature-card" key={title}>
            <Icon />
            <h3>{title}</h3>
            <p>{text}</p>
          </article>
        ))}
      </section>
    </div>
  );
}
