import { ChangeEvent, FormEvent, useEffect, useRef, useState } from "react";
import { Camera, ImagePlus, Trash2 } from "lucide-react";
import { useAuth } from "../context/AuthContext";
import { api } from "../lib/api";
import { supabase } from "../lib/supabase";

export default function ProfilePage() {
  const { profile, user, refreshProfile } = useAuth();
  const [fullName, setFullName] = useState("");
  const [institution, setInstitution] = useState("");
  const [avatarUrl, setAvatarUrl] = useState<string | null>(null);
  const [message, setMessage] = useState("");
  const [error, setError] = useState("");
  const [saving, setSaving] = useState(false);
  const [uploading, setUploading] = useState(false);
  const avatarInputRef = useRef<HTMLInputElement | null>(null);

  useEffect(() => {
    setFullName(profile?.full_name || "");
    setInstitution(profile?.institution || profile?.college || "");
    setAvatarUrl(profile?.avatar_url || null);
  }, [profile]);

  async function submit(event: FormEvent) {
    event.preventDefault();
    setSaving(true);
    setError("");
    setMessage("");

    try {
      await api.patch("/profile", {
        full_name: fullName,
        institution,
        avatar_url: avatarUrl
      });
      await refreshProfile();
      setMessage("Profile updated successfully.");
    } catch (caught: any) {
      setError(caught.message);
    } finally {
      setSaving(false);
    }
  }

  async function uploadAvatar(event: ChangeEvent<HTMLInputElement>) {
    const file = event.target.files?.[0];
    if (!file || !user) return;

    if (!["image/jpeg", "image/png", "image/webp"].includes(file.type)) {
      setError("Choose a JPG, PNG, or WebP image.");
      event.target.value = "";
      return;
    }
    if (file.size > 5 * 1024 * 1024) {
      setError("Profile pictures must be 5 MB or smaller.");
      event.target.value = "";
      return;
    }

    setUploading(true);
    setError("");
    setMessage("");

    const extension = file.name.split(".").pop() || "png";
    const path = `${user.id}/${Date.now()}.${extension}`;
    const { error: uploadError } = await supabase.storage.from("avatars").upload(path, file, {
      cacheControl: "3600",
      upsert: true
    });

    if (uploadError) {
      setError(uploadError.message);
      setUploading(false);
      return;
    }

    const { data } = supabase.storage.from("avatars").getPublicUrl(path);
    setAvatarUrl(data.publicUrl);
    setUploading(false);
    setMessage("Avatar uploaded. Save changes to update your profile.");
    event.target.value = "";
  }

  function removeAvatar() {
    setAvatarUrl(null);
    if (avatarInputRef.current) avatarInputRef.current.value = "";
    setError("");
    setMessage("Photo removed. Save changes to update your profile.");
  }

  return (
    <>
      <div className="page-header">
        <div>
          <span className="eyebrow">ACCOUNT</span>
          <h1>Profile</h1>
          <p>Manage your personal details and avatar.</p>
        </div>
      </div>

      <div className="grid-2 profile-layout">
        <section className="card profile-card profile-panel">
          <div className="profile-avatar-wrap">
            <div className="avatar profile-avatar avatar-photo">
              {avatarUrl ? <img src={avatarUrl} alt={fullName || "Profile"} /> : fullName?.[0]?.toUpperCase() || "U"}
            </div>
            <span className="profile-avatar-status">{avatarUrl ? "Photo added" : "Add a photo"}</span>
          </div>
          <div className="profile-summary">
            <span className="eyebrow">YOUR ACCOUNT</span>
            <h2>{fullName || "Your profile"}</h2>
            <p>{user?.email || profile?.email}</p>
            <div className="profile-details">
              <p><b>Role</b><span>{profile?.role}</span></p>
              <p><b>Status</b><span>{profile?.account_status || "active"}</span></p>
              <p><b>Last login</b><span>{profile?.last_login ? new Date(profile.last_login).toLocaleString() : "Not available"}</span></p>
            </div>
          </div>
        </section>

        <form className="card form-stack" onSubmit={submit}>
          <h2>Edit details</h2>
          {message && <div className="alert success">{message}</div>}
          {error && <div className="alert error">{error}</div>}
          <label>Full name<input value={fullName} onChange={(event) => setFullName(event.target.value)} required /></label>
          <label>Email<input value={user?.email || profile?.email || ""} disabled /></label>
          <label>Institution<input value={institution} onChange={(event) => setInstitution(event.target.value)} /></label>
          <div className="avatar-upload-control">
            <div className="avatar-upload-heading">
              <div><span className="form-label">Profile picture</span><small>JPG, PNG, or WebP. Maximum 5 MB.</small></div>
              {avatarUrl && <button type="button" className="text-button danger-text" onClick={removeAvatar} disabled={uploading}><Trash2 size={15} /> Remove</button>}
            </div>
            <div className="avatar-upload-preview">
              <div className="avatar avatar-upload-avatar">
                {avatarUrl ? <img src={avatarUrl} alt="Selected profile" /> : <ImagePlus size={24} />}
              </div>
              <div><strong>{avatarUrl ? "Profile picture ready" : "Add a profile picture"}</strong><small>{uploading ? "Uploading image..." : avatarUrl ? "Save your profile to apply this photo." : "Choose a clear photo so classmates can recognise you."}</small></div>
            </div>
            <input ref={avatarInputRef} className="visually-hidden" type="file" accept="image/png,image/jpeg,image/webp" onChange={uploadAvatar} disabled={uploading} />
            <button className="button secondary avatar-upload-button" type="button" onClick={() => avatarInputRef.current?.click()} disabled={uploading}><Camera size={16} />{uploading ? "Uploading..." : avatarUrl ? "Replace picture" : "Choose picture"}</button>
          </div>
          <button className="button secondary" type="button" disabled>{uploading ? "Uploading..." : "Role changes are admin-only"}</button>
          <button className="button" disabled={saving || uploading}>{saving ? "Saving..." : "Save profile"}</button>
        </form>
      </div>
    </>
  );
}
