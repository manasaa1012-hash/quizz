import { Router } from "express";
import { requireAuth } from "../middleware/auth.js";
import { getProfileById } from "../utils/db.js";

export const authRouter = Router();

authRouter.get("/me", requireAuth, async (req, res, next) => {
  try {
    const profile = await getProfileById(req.authUser!.id);
    res.json({ user: req.authUser, profile });
  } catch (error) {
    next(error);
  }
});
