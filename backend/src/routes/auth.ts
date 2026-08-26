import { Router } from "express";
import {
    // forgotPassword,
    getMe,
    login,
    // logout,
    // refresh,
    register,
    // resetPassword,
} from "../controllers/auth.controller.js";
import { authenticate } from "../middleware/auth.middleware.js";

const authRouter = Router();

// Public routes
authRouter.post("/register", register);
authRouter.post("/login", login);
// authRouter.post("/refresh", refresh);
// authRouter.post("/forgot-password", forgotPassword);
// authRouter.post("/reset-password", resetPassword);

// Protected routes
authRouter.get("/me", authenticate, getMe);
// authRouter.post("/logout", logout);

export default authRouter;