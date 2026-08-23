import type { Request, Response } from "express";

export const healthController = (_req: Request, res: Response) => {
  res.status(200).json({
    success: true,
    message: "API is healthy",
    data: {
      status: "ok",
      uptime: process.uptime(),
      timestamp: new Date().toISOString(),
    },
  });
};