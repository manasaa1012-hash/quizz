import { Router } from "express";
import { z } from "zod";
import { requireAuth } from "../middleware/auth.js";
import { supabase } from "../config/supabase.js";
import { AppError } from "../utils/http.js";
import { getProfileById } from "../utils/db.js";

const updateProfileSchema = z.object({
  full_name: z.string().trim().min(2).max(120).optional(),
  institution: z.string().trim().max(160).nullable().optional(),
  avatar_url: z.string().url().nullable().optional()
});

export const profileRouter = Router();
profileRouter.use(requireAuth);

profileRouter.get("/", async (req, res, next) => {
  try {
    const profile = await getProfileById(req.authUser!.id);
    res.json({ profile });
  } catch (error) {
    next(error);
  }
});

profileRouter.patch("/", async (req, res, next) => {
  try {
    const body = updateProfileSchema.parse(req.body);
    if (Object.keys(body).length === 0) {
      throw new AppError(400, "No profile changes were provided.");
    }

    const institution = body.institution === undefined ? undefined : body.institution || null;
    const payload = {
      ...(body.full_name !== undefined ? { full_name: body.full_name } : {}),
      ...(body.avatar_url !== undefined ? { avatar_url: body.avatar_url || null } : {}),
      ...(body.institution !== undefined
        ? {
            institution,
            college: institution
          }
        : {})
    };

    const { error } = await supabase.from("profiles").update(payload).eq("id", req.authUser!.id);
    if (error) throw new AppError(500, "Unable to update profile.");

    const profile = await getProfileById(req.authUser!.id);
    res.json({ profile, message: "Profile updated successfully." });
  } catch (error) {
    next(error);
  }
});
