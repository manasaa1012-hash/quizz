import { useEffect, useMemo, useRef, useState } from "react";
import { useNavigate, useParams } from "react-router-dom";
import { AlertTriangle, Camera, ChevronLeft, ChevronRight, Clock3, Flag, LogOut, Save, Send, Trash2 } from "lucide-react";
import { api } from "../lib/api";
import type { Exam } from "../types";
import { FaceLandmarker, FilesetResolver } from "@mediapipe/tasks-vision";

// Served by Vite from frontend/public/models. This avoids sending student video
// or model-loading requests to a third-party model host.
const FACE_LANDMARKER_MODEL = "/models/face_landmarker.task";

type AnswerState = {
  selected_answer: number | null;
  marked_for_review: boolean;
  visited: boolean;
  time_taken_seconds: number;
};

type AttemptQuestion = {
  id: string;
  question_text: string;
  question_image_url?: string | null;
  options: string[];
  option_images?: (string | null)[] | null;
  difficulty: "easy" | "medium" | "hard";
  marks: number;
  negative_marks: number;
  display_order: number;
  answer_state: AnswerState;
};

type AttemptPayload = {
  attempt: {
    id: string;
    status: string;
    attempt_number: number;
    started_at: string;
    expires_at?: string | null;
    remaining_seconds: number;
  };
  exam: {
    id: string;
    title: string;
    description?: string | null;
    duration_minutes: number;
    total_marks: number;
    passing_marks?: number;
    allow_review?: boolean;
    proctoring_enabled?: boolean;
    webcam_required?: boolean;
    camera_denied_action?: "warn" | "block";
    fullscreen_required?: boolean;
    head_turn_yaw_threshold?: number;
    head_turn_duration_seconds?: number;
    max_tab_switches?: number;
    instructions?: string | null;
    questions: AttemptQuestion[];
  };
};

function formatTime(seconds: number) {
  const hours = Math.floor(seconds / 3600).toString().padStart(2, "0");
  const minutes = Math.floor((seconds % 3600) / 60).toString().padStart(2, "0");
  const remainder = (seconds % 60).toString().padStart(2, "0");
  return hours === "00" ? `${minutes}:${remainder}` : `${hours}:${minutes}:${remainder}`;
}

function buildAnswerMap(questions: AttemptQuestion[]) {
  return Object.fromEntries(
    questions.map((question) => [
      question.id,
      {
        selected_answer: question.answer_state.selected_answer,
        marked_for_review: question.answer_state.marked_for_review,
        visited: Boolean(question.answer_state.visited),
        time_taken_seconds: Number(question.answer_state.time_taken_seconds || 0)
      }
    ])
  ) as Record<string, AnswerState>;
}

export default function QuizPage() {
  const { examId } = useParams();
  const navigate = useNavigate();
  const [payload, setPayload] = useState<AttemptPayload | null>(null);
  const [attemptId, setAttemptId] = useState("");
  const [answers, setAnswers] = useState<Record<string, AnswerState>>({});
  const [currentIndex, setCurrentIndex] = useState(0);
  const [secondsLeft, setSecondsLeft] = useState(0);
  const [error, setError] = useState("");
  const [saving, setSaving] = useState(false);
  const [submitting, setSubmitting] = useState(false);
  const [saveMessage, setSaveMessage] = useState("");
  const [events, setEvents] = useState(0);
  const [examConfig, setExamConfig] = useState<Exam | null>(null);
  const [preparing, setPreparing] = useState(false);
  const [cameraState, setCameraState] = useState<"inactive" | "active" | "denied" | "unsupported">("inactive");
  const [faceStatus, setFaceStatus] = useState("Not checked");
  const [cameraError, setCameraError] = useState("");
  const [headYaw, setHeadYaw] = useState<number | null>(null);
  const videoRef = useRef<HTMLVideoElement | null>(null);
  const landmarkCanvasRef = useRef<HTMLCanvasElement | null>(null);
  const streamRef = useRef<MediaStream | null>(null);
  const startRequestedRef = useRef(false);
  const faceMissingSinceRef = useRef<number | null>(null);
  const lastFaceEventRef = useRef<Record<string, number>>({});
  const headBaselineRef = useRef<number | null>(null);
  const headTurnSinceRef = useRef<number | null>(null);
  const pauseTriggeredRef = useRef(false);
  const enteredAtRef = useRef(Date.now());
  const activeQuestionIdRef = useRef<string>("");
  const autosaveRef = useRef<number | null>(null);
  const answersRef = useRef<Record<string, AnswerState>>({});
  const savingRef = useRef(false);
  const submittingRef = useRef(false);

  useEffect(() => {
    if (!examId) return;
    const heartbeat = () => { void api.post("/presence/heartbeat", { current_exam_id: examId }).catch(() => {}); };
    heartbeat();
    const interval = window.setInterval(heartbeat, 30_000);
    return () => {
      window.clearInterval(interval);
      void api.post("/presence/heartbeat", { current_exam_id: null }).catch(() => {});
    };
  }, [examId]);

  useEffect(() => {
    answersRef.current = answers;
  }, [answers]);

  function stopCamera() {
    const stream = streamRef.current;
    stream?.getTracks().forEach(track => track.stop());
    streamRef.current = null;
    if (videoRef.current) videoRef.current.srcObject = null;
    setCameraState("inactive");
    setHeadYaw(null);
  }

  function drawLandmarks(landmarks: Array<{ x: number; y: number }>) {
    const video = videoRef.current; const canvas = landmarkCanvasRef.current;
    if (!video || !canvas || !landmarks.length) return;
    const width = video.clientWidth; const height = video.clientHeight;
    if (!width || !height) return;
    canvas.width = width; canvas.height = height;
    const context = canvas.getContext("2d"); if (!context) return;
    context.clearRect(0, 0, width, height);
    context.fillStyle = "#8b5cf6"; context.strokeStyle = "rgba(196,181,253,.8)"; context.lineWidth = 1;
    const important = [10, 33, 133, 263, 362, 1, 234, 454, 152];
    for (const index of important) {
      const point = landmarks[index]; if (!point) continue;
      context.beginPath(); context.arc(point.x * width, point.y * height, index === 1 ? 3.5 : 2, 0, Math.PI * 2); context.fill();
    }
    const pairs = [[33, 133], [263, 362], [33, 263], [234, 454], [10, 152], [1, 10], [1, 152]];
    for (const [from, to] of pairs) { const a = landmarks[from]; const b = landmarks[to]; if (!a || !b) continue; context.beginPath(); context.moveTo(a.x * width, a.y * height); context.lineTo(b.x * width, b.y * height); context.stroke(); }
  }

  function describeCameraError(error: unknown) {
    const name = error instanceof DOMException ? error.name : "";
    if (!window.isSecureContext && !["localhost", "127.0.0.1", "::1"].includes(window.location.hostname)) return "Camera access requires HTTPS. Open this site over HTTPS and try again.";
    if (name === "NotAllowedError" || name === "SecurityError") return "Camera permission was blocked. Allow camera access in your browser site settings, then try again.";
    if (name === "NotFoundError" || name === "DevicesNotFoundError") return "No camera was found. Connect or enable a camera, then try again.";
    if (name === "NotReadableError" || name === "TrackStartError") return "Your camera is busy in another application. Close the other application and try again.";
    if (name === "OverconstrainedError") return "This camera does not support the requested settings. Try another camera.";
    return "Unable to start the camera. Check your browser permissions and camera connection.";
  }

  async function requestCamera() {
    setCameraError("");
    setError("");
    if (!navigator.mediaDevices?.getUserMedia) {
      setCameraState("unsupported");
      setCameraError("This browser does not support camera access. Use a current Chrome, Edge, Firefox, or Safari browser.");
      return false;
    }
    if (!window.isSecureContext && !["localhost", "127.0.0.1", "::1"].includes(window.location.hostname)) {
      setCameraState("unsupported");
      setCameraError("Camera access requires HTTPS. Open this site over HTTPS and try again.");
      return false;
    }
    try {
      stopCamera();
      const stream = await navigator.mediaDevices.getUserMedia({
        video: { facingMode: { ideal: "user" }, width: { ideal: 640 }, height: { ideal: 480 } }, audio: false
      });
      streamRef.current = stream;
      setCameraState("active");
      return true;
    } catch (caught) {
      setCameraState("denied");
      setCameraError(describeCameraError(caught));
      return false;
    }
  }

  async function beginExam(config: Exam) {
    if (!examId || startRequestedRef.current) return;
    setPreparing(true);
    setError("");
    try {
      if (config.fullscreen_required && !document.fullscreenElement) {
        await document.documentElement.requestFullscreen().catch(() => { setError("Fullscreen could not be enabled. Check your browser settings and try again."); });
      }
      if (config.webcam_required && !streamRef.current && config.camera_denied_action === "block") {
        setError("Camera permission is required for this exam. Enable the camera before starting.");
        return;
      }
      if (config.webcam_required && streamRef.current && videoRef.current) {
        setFaceStatus("Calibrating forward-facing position...");
        const vision = await FilesetResolver.forVisionTasks("https://cdn.jsdelivr.net/npm/@mediapipe/tasks-vision@1.0.1/wasm");
        const calibration = await FaceLandmarker.createFromOptions(vision, { baseOptions: { modelAssetPath: FACE_LANDMARKER_MODEL }, runningMode: "VIDEO", numFaces: 1 });
        const result = calibration.detectForVideo(videoRef.current, performance.now());
        calibration.close();
        const face = result.faceLandmarks[0];
        if (!face) { setError("Keep one face visible to calibrate before starting."); return; }
        const eyeMid = (face[33].x + face[263].x) / 2;
        const eyeDistance = Math.max(0.001, Math.abs(face[263].x - face[33].x));
        headBaselineRef.current = Math.atan((face[1].x - eyeMid) / eyeDistance) * 180 / Math.PI;
        setFaceStatus("Forward-facing position calibrated");
      }
      startRequestedRef.current = true;
      const start = await api.post(`/quiz/start/${examId}`);
      const id = start.data.attempt.id as string;
      const attempt = await api.get(`/quiz/attempt/${id}`);
      const data = attempt.data as AttemptPayload;
      setPayload(data);
      setAttemptId(data.attempt.id);
      setSecondsLeft(data.attempt.remaining_seconds);
      setAnswers(buildAnswerMap(data.exam.questions));
      setCurrentIndex(0);
      activeQuestionIdRef.current = data.exam.questions[0]?.id || "";
      enteredAtRef.current = Date.now();
      if (config.webcam_required && !streamRef.current && data.exam.proctoring_enabled) {
        api.post("/proctoring/event", { attempt_id: data.attempt.id, event_type: "camera_denied", details: { action: config.camera_denied_action } }).catch(() => undefined);
        setEvents(value => value + 1);
      }
    } catch (err: any) {
      startRequestedRef.current = false;
      setError(err.message);
    } finally {
      setPreparing(false);
    }
  }

  useEffect(() => {
    if (!examId) return;
    let active = true;
    api.get(`/exams/${examId}`).then(response => {
      if (!active) return;
      const config = response.data.exam as Exam;
      setExamConfig(config);
      if (!config.webcam_required) void beginExam(config);
    }).catch((err: any) => active && setError(err.message));
    return () => { active = false; };
  }, [examId]);

  useEffect(() => () => { stopCamera(); }, []);

  useEffect(() => {
    const video = videoRef.current;
    if (!video || !streamRef.current) return;
    video.srcObject = streamRef.current;
    const play = () => { void video.play().catch(() => setCameraError("Camera preview could not start. Press Enable camera again.")); };
    video.addEventListener("loadedmetadata", play, { once: true });
    play();
    return () => video.removeEventListener("loadedmetadata", play);
  }, [cameraState, payload, examConfig?.webcam_required]);

  const questions = payload?.exam.questions || [];
  const currentQuestion = questions[currentIndex];

  useEffect(() => {
    if (!attemptId || !currentQuestion) return;
    activeQuestionIdRef.current = currentQuestion.id;
    enteredAtRef.current = Date.now();
    setAnswers((previous) => ({
      ...previous,
      [currentQuestion.id]: {
        selected_answer: previous[currentQuestion.id]?.selected_answer ?? null,
        marked_for_review: previous[currentQuestion.id]?.marked_for_review ?? false,
        visited: true,
        time_taken_seconds: previous[currentQuestion.id]?.time_taken_seconds ?? 0
      }
    }));
  }, [attemptId, currentQuestion?.id]);

  useEffect(() => {
    if (!attemptId || secondsLeft <= 0 || submitting) return;
    const timer = window.setInterval(() => {
      setSecondsLeft((value) => {
        if (value <= 1) {
          window.clearInterval(timer);
          void handleSubmit(true);
          return 0;
        }
        return value - 1;
      });
    }, 1000);
    return () => window.clearInterval(timer);
  }, [attemptId, secondsLeft, submitting]);

  useEffect(() => {
    if (attemptId && payload && secondsLeft === 0 && !submittingRef.current) {
      void handleSubmit(true);
    }
  }, [attemptId, payload, secondsLeft]);

  function withCurrentQuestionTime(source: Record<string, AnswerState>) {
    const activeQuestionId = activeQuestionIdRef.current;
    if (!activeQuestionId || !source[activeQuestionId]) return source;
    const delta = Math.max(0, Math.round((Date.now() - enteredAtRef.current) / 1000));
    return {
      ...source,
      [activeQuestionId]: {
        ...source[activeQuestionId],
        visited: true,
        time_taken_seconds: source[activeQuestionId].time_taken_seconds + delta
      }
    };
  }

  function resetQuestionTimer() {
    enteredAtRef.current = Date.now();
  }

  async function saveProgress(manual = false) {
    if (!attemptId || !questions.length || savingRef.current || submittingRef.current) return;
    const snapshot = withCurrentQuestionTime(answersRef.current);
    setAnswers(snapshot);
    savingRef.current = true;
    setSaving(true);
    try {
      await api.put(`/quiz/save/${attemptId}`, {
        answers: questions.map((question) => ({
          question_id: question.id,
          selected_answer: snapshot[question.id]?.selected_answer ?? null,
          marked_for_review: snapshot[question.id]?.marked_for_review ?? false,
          visited: snapshot[question.id]?.visited ?? false,
          time_taken_seconds: snapshot[question.id]?.time_taken_seconds ?? 0
        }))
      });
      resetQuestionTimer();
      if (manual) {
        setSaveMessage("Progress saved.");
        window.setTimeout(() => setSaveMessage(""), 2000);
      }
    } catch (err: any) {
      setError(err.message);
    } finally {
      savingRef.current = false;
      setSaving(false);
    }
  }

  useEffect(() => {
    if (!attemptId || !questions.length) return;
    autosaveRef.current = window.setInterval(() => {
      void saveProgress(false);
    }, 15000);
    return () => {
      if (autosaveRef.current) window.clearInterval(autosaveRef.current);
    };
  }, [attemptId, questions.length]);

  useEffect(() => {
    if (!attemptId || !payload?.exam.proctoring_enabled) return;
    const report = (eventType: string, details: Record<string, unknown> = {}) => {
      setEvents((value) => value + 1);
      api.post("/proctoring/event", { attempt_id: attemptId, event_type: eventType, details }).catch(() => {});
    };

    let focusLosses: number[] = [];
    const handleBlur = () => {
      const now = Date.now();
      focusLosses = [...focusLosses.filter(value => now - value < 60_000), now];
      report("window_blur", { focus_losses_last_minute: focusLosses.length });
      if (focusLosses.length === 3) report("repeated_focus_loss", { threshold: 3, window_seconds: 60 });
    };
    const handleVisibility = () => {
      if (document.visibilityState === "hidden") {
        report("visibility_hidden", { visibility_state: document.visibilityState });
        report("tab_switch", { visibility_state: document.visibilityState });
      }
    };
    const handleCopy = () => report("copy_attempt");
    const handlePaste = () => report("paste_attempt");
    const handleContext = () => report("context_menu");
    const handleKey = (event: KeyboardEvent) => {
      const key = event.key.toLowerCase();
      if ((event.ctrlKey || event.metaKey) && ["c", "v", "x", "p", "u"].includes(key)) {
        report("prohibited_shortcut", { key, ctrl: event.ctrlKey, meta: event.metaKey });
      }
    };
    const handleFullscreen = () => {
      if (payload?.exam.fullscreen_required && !document.fullscreenElement) {
        report("fullscreen_exit");
      }
    };
    const handleBeforeUnload = () => {
      void saveProgress(false);
    };

    window.addEventListener("blur", handleBlur);
    window.addEventListener("beforeunload", handleBeforeUnload);
    document.addEventListener("visibilitychange", handleVisibility);
    document.addEventListener("copy", handleCopy);
    document.addEventListener("paste", handlePaste);
    document.addEventListener("contextmenu", handleContext);
    document.addEventListener("fullscreenchange", handleFullscreen);
    document.addEventListener("keydown", handleKey);

    return () => {
      window.removeEventListener("blur", handleBlur);
      window.removeEventListener("beforeunload", handleBeforeUnload);
      document.removeEventListener("visibilitychange", handleVisibility);
      document.removeEventListener("copy", handleCopy);
      document.removeEventListener("paste", handlePaste);
      document.removeEventListener("contextmenu", handleContext);
      document.removeEventListener("fullscreenchange", handleFullscreen);
      document.removeEventListener("keydown", handleKey);
    };
  }, [attemptId, payload?.exam.fullscreen_required, payload?.exam.proctoring_enabled]);

  useEffect(() => {
    if (!attemptId || !payload?.exam.webcam_required || !streamRef.current) return;
    const video = videoRef.current;
    if (video) { video.srcObject = streamRef.current; void video.play().catch(() => undefined); }
    const report = (eventType: string, details: Record<string, unknown>) => {
      const now = Date.now();
      if (now - (lastFaceEventRef.current[eventType] || 0) < 10_000) return;
      lastFaceEventRef.current[eventType] = now;
      setEvents(value => value + 1);
      api.post("/proctoring/event", { attempt_id: attemptId, event_type: eventType, details }).catch(() => undefined);
    };
    let detector: FaceLandmarker | null = null;
    let interval: number | null = null;
    let cancelled = false;
    const check = async () => {
      if (!detector || !video || video.readyState < 2) return;
      try {
        const faces = detector.detectForVideo(video, performance.now()).faceLandmarks;
        if (faces.length === 1) {
          setFaceStatus("Face detected");
          faceMissingSinceRef.current = null;
          const face = faces[0];
          drawLandmarks(face);
          const eyeMid = (face[33].x + face[263].x) / 2;
          const eyeDistance = Math.max(0.001, Math.abs(face[263].x - face[33].x));
          // A calibrated landmark-based yaw estimate: normalizing nose displacement
          // by inter-eye distance makes it insensitive to distance from the webcam.
          const yaw = Math.atan((face[1].x - eyeMid) / eyeDistance) * 180 / Math.PI - (headBaselineRef.current || 0);
          setHeadYaw(Number(yaw.toFixed(1)));
          const yawThreshold = Number(payload.exam.head_turn_yaw_threshold || 25);
          const durationSeconds = Number(payload.exam.head_turn_duration_seconds || 2);
          if (Math.abs(yaw) > yawThreshold) {
            const started = headTurnSinceRef.current ?? Date.now();
            headTurnSinceRef.current = started;
            if (Date.now() - started >= durationSeconds * 1000 && !pauseTriggeredRef.current) {
              pauseTriggeredRef.current = true;
              const response = await api.post("/proctoring/event", { attempt_id: attemptId, event_type: "head_turn_sustained", details: { yaw_degrees: Number(yaw.toFixed(1)), threshold_degrees: yawThreshold, duration_seconds: durationSeconds } });
              if (response.data?.paused) { stopCamera(); navigate(`/app/exams/${payload.exam.id}`, { state: { proctoringPaused: true } }); }
            }
          } else headTurnSinceRef.current = null;
        } else if (faces.length === 0) {
          setFaceStatus("Face not detected");
          const started = faceMissingSinceRef.current ?? Date.now();
          faceMissingSinceRef.current = started;
          report("face_missing", { face_count: 0 });
          if (Date.now() - started >= 15_000) report("prolonged_face_absence", { duration_seconds: Math.round((Date.now() - started) / 1000) });
        } else {
          setFaceStatus("Multiple faces detected");
          faceMissingSinceRef.current = null;
          report("multiple_faces", { face_count: faces.length });
        }
      } catch { setFaceStatus("Detection unavailable"); }
    };
    const track = streamRef.current.getVideoTracks()[0];
    const stopped = () => { setCameraState("inactive"); report("camera_stopped", { reason: "video_track_ended" }); };
    track?.addEventListener("ended", stopped);
    void (async () => {
      try {
        const vision = await FilesetResolver.forVisionTasks("https://cdn.jsdelivr.net/npm/@mediapipe/tasks-vision@1.0.1/wasm");
        detector = await FaceLandmarker.createFromOptions(vision, {
          baseOptions: { modelAssetPath: FACE_LANDMARKER_MODEL },
          runningMode: "VIDEO", numFaces: 2, minFaceDetectionConfidence: 0.5, minFacePresenceConfidence: 0.5, minTrackingConfidence: 0.5
        });
        if (cancelled) { detector.close(); detector = null; return; }
        setFaceStatus("Detector active");
        interval = window.setInterval(() => void check(), 500);
        void check();
      } catch {
        setCameraState("unsupported");
        setFaceStatus("Detection unavailable");
        report("camera_detection_unavailable", { component: "mediapipe_tasks_vision" });
      }
    })();
    return () => {
      cancelled = true;
      if (interval) window.clearInterval(interval);
      detector?.close();
      const canvas = landmarkCanvasRef.current;
      canvas?.getContext("2d")?.clearRect(0, 0, canvas.width, canvas.height);
      track?.removeEventListener("ended", stopped);
    };
  }, [attemptId, payload?.exam.webcam_required]);

  function updateAnswer(questionId: string, patch: Partial<AnswerState>) {
    setAnswers((previous) => ({
      ...previous,
      [questionId]: {
        selected_answer: previous[questionId]?.selected_answer ?? null,
        marked_for_review: previous[questionId]?.marked_for_review ?? false,
        visited: previous[questionId]?.visited ?? false,
        time_taken_seconds: previous[questionId]?.time_taken_seconds ?? 0,
        ...patch
      }
    }));
  }

  function moveToQuestion(index: number) {
    const bounded = Math.min(Math.max(index, 0), questions.length - 1);
    const snapshot = withCurrentQuestionTime(answers);
    setAnswers(snapshot);
    setCurrentIndex(bounded);
  }

  async function handleSubmit(force = false) {
    if (!attemptId || !questions.length || submittingRef.current) return;
    if (!force && !window.confirm("Submit the exam now? You won't be able to edit it after submission.")) return;

    const snapshot = withCurrentQuestionTime(answersRef.current);
    setAnswers(snapshot);
    submittingRef.current = true;
    setSubmitting(true);

    try {
      const response = await api.post(`/quiz/submit/${attemptId}`, {
        answers: questions.map((question) => ({
          question_id: question.id,
          selected_answer: snapshot[question.id]?.selected_answer ?? null,
          marked_for_review: snapshot[question.id]?.marked_for_review ?? false,
          visited: snapshot[question.id]?.visited ?? false,
          time_taken_seconds: snapshot[question.id]?.time_taken_seconds ?? 0
        }))
      });
      stopCamera();
      navigate(`/app/result/${attemptId}`, { state: response.data.result });
    } catch (err: any) {
      setError(err.message);
      submittingRef.current = false;
      setSubmitting(false);
    }
  }

  async function handleQuit() {
    if (!examId || submittingRef.current) return;
    if (!window.confirm("Quit this exam? Your current answers will be saved and you can resume later if the exam is still available.")) return;
    await saveProgress(false);
    stopCamera();
    navigate(`/app/exams/${examId}`);
  }

  const summary = useMemo(() => {
    const values = questions.map((question) => answers[question.id]);
    const answered = values.filter((answer) => answer?.selected_answer !== null && answer?.selected_answer !== undefined).length;
    const marked = values.filter((answer) => answer?.marked_for_review).length;
    const visited = values.filter((answer) => answer?.visited).length;
    return {
      answered,
      marked,
      visited,
      unanswered: questions.length - answered
    };
  }, [answers, questions]);

  function getPaletteClass(questionId: string, index: number) {
    const state = answers[questionId];
    const answered = state?.selected_answer !== null && state?.selected_answer !== undefined;
    const classes = [
      !state?.visited ? "not-visited"
        : answered && state.marked_for_review ? "answered-marked"
        : state.marked_for_review ? "marked"
        : answered ? "answered"
        : "visited-unanswered"
    ];
    if (index === currentIndex) classes.push("active");
    return classes.join(" ");
  }

  if (examConfig?.webcam_required && !payload) {
    return (
      <div className="center-screen proctor-consent-wrap">
        <section className="card proctor-consent" aria-labelledby="camera-consent-title">
          <Camera size={38} aria-hidden="true" />
          <h1 id="camera-consent-title">Camera consent required</h1>
          <p>This exam uses your camera to check whether no face, one face, or multiple faces are visible during the attempt.</p>
          <ul>
            <li>No facial recognition or identity matching is performed.</li>
            <li>Frames are processed locally in your browser.</li>
            <li>Raw video is not uploaded or continuously stored; only event metadata is sent.</li>
            <li>If permission is denied, this exam will {examConfig.camera_denied_action === "block" ? "not start" : "show a warning and continue"}.</li>
          </ul>
          {cameraState === "active" && <video ref={videoRef} className="proctor-preview" muted playsInline autoPlay aria-label="Live camera preview before exam start" />}
          {cameraError && <div className="alert error">{cameraError}</div>}
          {error && <div className="alert error">{error}</div>}
          <div className="button-row">
            {cameraState !== "active" && <button className="button" disabled={preparing} onClick={() => void requestCamera()}><Camera size={17} /> Enable camera</button>}
            {cameraState === "active" && <button className="button" disabled={preparing} onClick={() => void beginExam(examConfig)}><Camera size={17} /> {preparing ? "Starting exam..." : "Start proctored exam"}</button>}
            {cameraState !== "active" && examConfig.camera_denied_action === "warn" && <button className="button secondary" disabled={preparing} onClick={() => void beginExam(examConfig)}>Continue without camera</button>}
            <button className="button secondary" onClick={() => navigate(`/app/exams/${examConfig.id}`)}>Cancel</button>
          </div>
        </section>
      </div>
    );
  }

  if (error && !payload) {
    return <div className="center-screen">{error}</div>;
  }

  if (!payload || !currentQuestion) {
    return <div className="center-screen">Preparing exam...</div>;
  }

  const currentState = answers[currentQuestion.id] || {
    selected_answer: null,
    marked_for_review: false,
    visited: true,
    time_taken_seconds: 0
  };

  return (
    <div className="quiz-page">
      <div className="quiz-top">
        <div>
          <strong>{payload.exam.title}</strong>
          <small>Question {currentIndex + 1} of {questions.length}</small>
        </div>
        <div className="quiz-top-right">
          {payload.exam.webcam_required && <span className={`proctor-status ${cameraState === "active" ? "ok" : "warn"}`}><Camera size={15} />{cameraState === "active" ? "Camera active" : cameraState === "unsupported" ? "Camera active · detection unsupported" : "Camera unavailable"} · {faceStatus}{headYaw !== null ? ` · yaw ${headYaw}°` : ""}</span>}
          {events > 0 && <span className="warning-pill"><AlertTriangle size={15} />{events} monitored event(s)</span>}
          <span className={`timer${secondsLeft <= 300 ? " timer-warning" : ""}`}><Clock3 size={17} />{formatTime(secondsLeft)}</span>
          <button className="button secondary" onClick={() => void handleQuit()} disabled={submitting}>
            <LogOut size={16} />
            Quit
          </button>
          <button className="button danger" onClick={() => void handleSubmit(false)} disabled={submitting}>
            <Send size={16} />
            Submit
          </button>
        </div>
      </div>

      {payload.exam.webcam_required && <video ref={videoRef} className="proctor-video" muted playsInline autoPlay aria-label="Your proctoring camera preview" />}
      {payload.exam.webcam_required && <canvas ref={landmarkCanvasRef} className="proctor-landmarks" aria-label="Face landmark overlay" />}

      <div className="quiz-body">
        <aside className="question-palette">
          <h3>Questions</h3>
          <div className="quiz-summary">
            <span>Answered: {summary.answered}</span>
            <span>Marked: {summary.marked}</span>
            <span>Visited: {summary.visited}</span>
          </div>
          <div>
            {questions.map((question, index) => (
              <button
                key={question.id}
                className={getPaletteClass(question.id, index)}
                onClick={() => moveToQuestion(index)}
              >
                {index + 1}
              </button>
            ))}
          </div>
          <div className="palette-legend">
            <span><i className="legend not-visited" /> Not visited</span>
            <span><i className="legend visited-unanswered" /> Unanswered</span>
            <span><i className="legend answered" /> Answered</span>
            <span><i className="legend marked" /> Review</span>
            <span><i className="legend answered-marked" /> Answered + review</span>
          </div>
        </aside>

        <section className="question-stage">
          <div className="question-info">
            <span>{currentQuestion.difficulty}</span>
            <span>{currentQuestion.marks} mark(s)</span>
            {currentQuestion.negative_marks > 0 && <span>-{currentQuestion.negative_marks} negative</span>}
          </div>

          {error && <div className="alert error">{error}</div>}
          {saveMessage && <div className="alert success">{saveMessage}</div>}

          <h2>{currentQuestion.question_text}</h2>
          {currentQuestion.question_image_url && (
            <img
              className="media-preview"
              src={currentQuestion.question_image_url}
              alt="Question"
            />
          )}

          <div className="options">
            {currentQuestion.options.map((option, index) => (
              <button
                key={index}
                className={currentState.selected_answer === index ? "selected" : ""}
                onClick={() => updateAnswer(currentQuestion.id, { selected_answer: index, visited: true })}
              >
                <b>{String.fromCharCode(65 + index)}</b>
                <span className="option-content">
                  {option}
                  {currentQuestion.option_images?.[index] && (
                    <img src={currentQuestion.option_images[index] || ""} alt={`Option ${String.fromCharCode(65 + index)}`} />
                  )}
                </span>
              </button>
            ))}
          </div>

          <div className="quiz-actions-row">
            <button
              className="button secondary"
              onClick={() => updateAnswer(currentQuestion.id, { selected_answer: null, visited: true })}
            >
              <Trash2 size={16} />
              Clear Response
            </button>
            <button
              className={`button secondary${currentState.marked_for_review ? " flagged" : ""}`}
              onClick={() =>
                updateAnswer(currentQuestion.id, {
                  marked_for_review: !currentState.marked_for_review,
                  visited: true
                })
              }
            >
              <Flag size={16} />
              {currentState.marked_for_review ? "Remove Review Flag" : "Mark for Review"}
            </button>
            <button className="button secondary" onClick={() => void saveProgress(true)} disabled={saving}>
              <Save size={16} />
              {saving ? "Saving..." : "Save Answer"}
            </button>
          </div>

          <div className="quiz-nav">
            <button className="button secondary" disabled={currentIndex === 0} onClick={() => moveToQuestion(currentIndex - 1)}>
              <ChevronLeft size={17} />
              Previous
            </button>
            {currentIndex < questions.length - 1 ? (
              <button className="button" onClick={() => moveToQuestion(currentIndex + 1)}>
                Next
                <ChevronRight size={17} />
              </button>
            ) : (
              <button className="button" onClick={() => void handleSubmit(false)} disabled={submitting}>
                Finish Exam
              </button>
            )}
          </div>
        </section>
      </div>
    </div>
  );
}
