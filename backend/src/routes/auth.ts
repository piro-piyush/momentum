import { Router } from "express";

import {
    forgotPassword,
    getMe,
    login,
    register,
    resetPassword,
    tokenIsValid,
} from "../controllers/auth.controller.js";

import { authenticate } from "../middleware/auth.middleware.js";

const authRouter = Router();

// -----------------------------------------------------------------------------
// GET /auth/
// -----------------------------------------------------------------------------

authRouter.get("/", (_req, res) => {
    res.json({
        success: true,
        message: "Auth API is working",
    });
});

// -----------------------------------------------------------------------------
// Public routes
// -----------------------------------------------------------------------------

authRouter.post("/register", register);
authRouter.post("/login", login);
authRouter.post("/forgot-password", forgotPassword);
authRouter.post("/reset-password", resetPassword);
authRouter.get("/token-is-valid", tokenIsValid);

// -----------------------------------------------------------------------------
// Protected routes
// -----------------------------------------------------------------------------

authRouter.get("/me", authenticate, getMe);

// authRouter.post("/logout", authenticate, logout);

export default authRouter;