import type { NextFunction, Request, Response } from "express";
import { ZodError } from "zod";

export function notFound(req: Request, res: Response) {
  res.status(404).json({ message: `Route not found: ${req.method} ${req.path}` });
}

export function errorHandler(error: any, _req: Request, res: Response, _next: NextFunction) {
  console.error(error);
  const candidateStatus = Number(error?.status || error?.statusCode || 500);
  const status = candidateStatus >= 400 && candidateStatus <= 599 ? candidateStatus : 500;
  if (error instanceof ZodError) {
    return res.status(400).json({
      message: error.issues[0]?.message || "Validation failed.",
      issues: error.issues.map((issue) => ({
        path: issue.path.join("."),
        message: issue.message
      }))
    });
  }
  res.status(status).json({
    message: status >= 500 ? "Internal server error" : error?.message || "Request failed"
  });
}
