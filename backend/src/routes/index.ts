import { Router } from "express";
import { healthRouter } from "./health.routes.js";

export const apiRouter = Router();

apiRouter.get("/", (_req, res) => {
  res.json({
    success: true,
    message: "Welcome to the API",
    version: "v1",
  });
});

apiRouter.use("/health", healthRouter);