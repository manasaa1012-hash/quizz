import { ChangeEvent, useState } from "react";
import { CheckCircle2, ClipboardCopy, Download, FileJson, Upload } from "lucide-react";
import { api } from "../lib/api";

const template = {
  subject: { name: "Mathematics", is_active: true },
  topics: [
    { name: "Algebra", is_active: true },
    { name: "Geometry", is_active: true }
  ],
  exam: {
    title: "Mathematics Practice Test",
    description: "A focused practice test for core mathematics topics.",
    duration_minutes: 60,
    total_marks: 4,
    passing_marks: 2,
    negative_marking: false,
    status: "draft",
    shuffle_questions: false,
    shuffle_options: false,
    allow_review: true,
    proctoring_enabled: false,
    webcam_required: false,
    camera_denied_action: "warn",
    fullscreen_required: false,
    max_tab_switches: 3,
    attempt_limit: 1,
    instructions: "Read every question carefully before answering.",
    is_active: true
  },
  questions: [
    {
      topic: "Algebra",
      question_text: "What is the value of x if 2x + 4 = 12?",
      options: ["2", "4", "6", "8"],
      correct_answer: 1,
      difficulty: "easy",
      marks: 2,
      negative_marks: 0,
      explanation: "Subtract 4 from both sides, then divide by 2.",
      is_active: true
    },
    {
      topic: "Geometry",
      question_text: "What is the sum of the interior angles of a triangle?",
      options: ["90 degrees", "180 degrees", "270 degrees", "360 degrees"],
      correct_answer: 1,
      difficulty: "easy",
      marks: 2,
      negative_marks: 0,
      explanation: "The interior angles of every triangle add up to 180 degrees.",
      is_active: true
    }
  ]
};

const defaultPrompt = `Create one valid JSON file for a QuizAI exam import. I need you to return JSON only, with no markdown fences, notes, or explanation.

Customise these values before sending this prompt:
- Subject: [SUBJECT NAME]
- Topics: [TOPIC 1, TOPIC 2, TOPIC 3]
- Exam title: [EXAM TITLE]
- Exam description: [DESCRIPTION]
- Number of questions: [QUESTION COUNT]
- Difficulty mix: [EASY / MEDIUM / HARD MIX]
- Marks per question: [MARKS]
- Duration in minutes: [DURATION]
- Passing marks: [PASSING MARKS]

Use exactly this structure and field names. Every question must have exactly 4 options. correct_answer must be the zero-based option index: 0 for A, 1 for B, 2 for C, 3 for D. Each question.topic must exactly match one name in topics. Set exam.total_marks to the sum of all question marks. Use status "draft" unless I explicitly request publication.

${JSON.stringify(template, null, 2)}`;

export default function AdminJsonImportPage() {
  const [prompt, setPrompt] = useState(defaultPrompt);
  const [fileName, setFileName] = useState("");
  const [payload, setPayload] = useState<any>(null);
  const [message, setMessage] = useState("");
  const [error, setError] = useState("");
  const [importing, setImporting] = useState(false);
  const [copied, setCopied] = useState(false);
  const [previewOpen, setPreviewOpen] = useState(false);

  async function copyPrompt() {
    try {
      await navigator.clipboard.writeText(prompt);
      setCopied(true);
      window.setTimeout(() => setCopied(false), 2000);
    } catch {
      setError("Could not copy the prompt. Select and copy it manually.");
    }
  }

  function downloadTemplate() {
    const blob = new Blob([JSON.stringify(template, null, 2)], { type: "application/json" });
    const url = URL.createObjectURL(blob);
    const link = document.createElement("a");
    link.href = url;
    link.download = "quizai-exam-template.json";
    link.click();
    URL.revokeObjectURL(url);
  }

  function readFile(event: ChangeEvent<HTMLInputElement>) {
    const file = event.target.files?.[0];
    setMessage("");
    setError("");
    setPayload(null);
    setPreviewOpen(false);
    setFileName("");
    if (!file) return;
    if (!file.name.toLowerCase().endsWith(".json")) {
      setError("Choose a .json file generated from the QuizAI template.");
      return;
    }
    const reader = new FileReader();
    reader.onload = () => {
      try {
        const imported = JSON.parse(String(reader.result));
        if (!imported || typeof imported !== "object" || Array.isArray(imported)) throw new Error();
        setPayload(imported);
        setFileName(file.name);
      } catch {
        setError("This file is not valid JSON. Ask ChatGPT to return JSON only, then download it again.");
      }
    };
    reader.onerror = () => setError("The selected file could not be read.");
    reader.readAsText(file);
  }

  async function importJson() {
    if (!payload) return;
    setImporting(true);
    setMessage("");
    setError("");
    try {
      const response = await api.post("/admin/imports/exam-json", payload);
      setMessage(response.data.message || "Exam import completed.");
      setPayload(null);
      setFileName("");
    } catch (caught: any) {
      setError(caught.message || "The JSON file could not be imported.");
    } finally {
      setImporting(false);
    }
  }

  const questionCount = Array.isArray(payload?.questions) ? payload.questions.length : 0;
  return <>
    <div className="page-header">
      <div>
        <span className="eyebrow">BULK AUTHORING</span>
        <h1>Upload using JSON</h1>
        <p>Create an exam externally with ChatGPT, then import its subject, topics, questions, and exam setup together.</p>
      </div>
    </div>
    {message && <div className="alert success">{message}</div>}
    {error && <div className="alert error">{error}</div>}

    <section className="json-import-steps">
      <article className="card json-import-step"><span>1</span><div><h2>Customize the prompt</h2><p>Edit the placeholders for your subject, topics, exam rules, and question mix.</p></div></article>
      <article className="card json-import-step"><span>2</span><div><h2>Generate outside QuizAI</h2><p>Paste it into ChatGPT and ask it to return only a JSON file.</p></div></article>
      <article className="card json-import-step"><span>3</span><div><h2>Upload and import</h2><p>Select the saved file below. QuizAI validates it before creating records.</p></div></article>
    </section>

    <div className="json-import-layout">
      <section className="card form-stack json-prompt-card">
        <div className="section-title"><div><h2>ChatGPT prompt</h2><p>Everything here is editable before you copy it.</p></div><FileJson size={22} /></div>
        <textarea className="json-prompt-editor" value={prompt} onChange={(event) => setPrompt(event.target.value)} aria-label="Customizable ChatGPT JSON generation prompt" />
        <div className="button-row">
          <button className="button" type="button" onClick={copyPrompt}>{copied ? <CheckCircle2 size={16} /> : <ClipboardCopy size={16} />}{copied ? "Copied" : "Copy prompt"}</button>
          <button className="button secondary" type="button" onClick={downloadTemplate}><Download size={16} />Download JSON template</button>
        </div>
      </section>

      <section className="card form-stack json-upload-card">
        <div><span className="eyebrow">FINAL STEP</span><h2>Upload generated JSON</h2><p>The importer creates missing topics, adds the questions to the bank, and connects them to the exam.</p></div>
        <label className="json-file-picker">
          <Upload size={22} />
          <strong>{fileName || "Choose a JSON file"}</strong>
          <small>{fileName ? "Ready to validate and import" : "Only .json files are accepted"}</small>
          <input type="file" accept="application/json,.json" onChange={readFile} />
        </label>
        {payload && <><div className="json-file-summary"><CheckCircle2 size={18} /><span><b>{payload.exam?.title || "Untitled exam"}</b><small>{payload.subject?.name || "No subject"} · {questionCount} question{questionCount === 1 ? "" : "s"}</small></span></div><button className="button secondary" type="button" onClick={() => setPreviewOpen(true)}>Preview JSON</button></>}
        <button className="button" type="button" disabled={!payload || importing} onClick={importJson}><Upload size={16} />{importing ? "Importing..." : "Validate & import exam"}</button>
        <small className="json-import-note">Tip: edit the JSON file first if you need to correct any generated content. A draft exam can be reviewed and published later from Exams.</small>
      </section>
    </div>
    {previewOpen && payload && <div className="modal-backdrop" role="presentation"><section className="card modal-card" role="dialog" aria-modal="true" aria-label="JSON file preview"><div className="section-title"><h2>JSON preview</h2><button className="button small secondary" type="button" onClick={() => setPreviewOpen(false)}>Close</button></div><pre className="json-preview">{JSON.stringify(payload, null, 2)}</pre></section></div>}
  </>;
}
