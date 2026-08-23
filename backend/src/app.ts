import express from "express";
import helmet from "helmet";
import morgan from "morgan";

import { errorMiddleware } from "./middlewares/error.middleware.js";
import { notFoundMiddleware } from "./middlewares/not-found.middleware.js";
import { apiRouter } from "./routes/index.js";

const app = express();

// ─────────────────────────────────────────────
// Security
// ─────────────────────────────────────────────

app.disable("x-powered-by");
app.use(helmet());

// ─────────────────────────────────────────────
// Middleware
// ─────────────────────────────────────────────

app.use(express.json({ limit: "1mb" }));
app.use(express.urlencoded({ extended: true }));

if (process.env.NODE_ENV !== "test") {
  app.use(morgan("dev"));
}

// ─────────────────────────────────────────────
// API Routes
// ─────────────────────────────────────────────

app.use("/api/v1", apiRouter);

// ─────────────────────────────────────────────
// 404
// ─────────────────────────────────────────────

app.use(notFoundMiddleware);

// ─────────────────────────────────────────────
// Error Handler
// ─────────────────────────────────────────────

app.use(errorMiddleware);

export default app;