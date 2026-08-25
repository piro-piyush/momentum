import { Router } from "express";
import authRouter from "./auth.js";
import { healthRouter } from "./health.routes.js";
export const apiRouter = Router();

apiRouter.use('/auth', authRouter);

apiRouter.get("/", (_req, res) => {
  res.json({
    success: true,
    message: "Welcome to the API",
    version: "v1",
  });
});

apiRouter.use("/health", healthRouter);