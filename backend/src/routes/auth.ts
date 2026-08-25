import bcrypt from "bcryptjs";
import { eq } from "drizzle-orm";
import { Router, type Request, type Response } from "express";
import { HttpStatus } from "../constants/http-status.js";
import { db } from "../db/index.js";
import { users, type NewUser } from "../db/schema.js";
import { ApiResponse } from "../utils/api-response.js";

const authRouter = Router();

interface SignupBody {
    name: string,
    email: string,
    password: string,
}

// Public routes

authRouter.post(
    "/register",
    async (
        req: Request<{}, {}, SignupBody>,
        res: Response,
    ) => {
        try {
            const { name, email, password } = req.body;

            // Check if user already exists
            const existingUser = await db
                .select({ id: users.id })
                .from(users)
                .where(eq(users.email, email))
                .limit(1);

            if (existingUser.length > 0) {
                return res.status(HttpStatus.CONFLICT).json(
                    ApiResponse.error("User with this email already exists"),
                );
            }

            // Hash password
            const hashedPassword = await bcrypt.hash(password, 8);

            // Create new User Object
            const newUser: NewUser = {
                name, email, password: hashedPassword,
            }

            // Create user
            const [user] = await db
                .insert(users)
                .values(newUser)
                .returning({
                    id: users.id,
                    name: users.name,
                    email: users.email,
                    createdAt: users.createdAt,
                });

            return res.status(HttpStatus.CREATED).json(
                ApiResponse.success(
                    "User registered successfully",
                    user,
                ),
            );
        } catch (error) {
            console.error("Register error:", error);
            return res.status(HttpStatus.INTERNAL_SERVER_ERROR).json(
                ApiResponse.error("Failed to register user"),
            );
        }
    },
);


authRouter.post("/login", async (req, res) => {
    try {
        // Login logic...

        return res.status(HttpStatus.OK).json(
            ApiResponse.success("User logged in successfully"),
        );
    } catch (error) {
        return res.status(HttpStatus.INTERNAL_SERVER_ERROR).json(
            ApiResponse.error("Failed to login", error),
        );
    }
});

authRouter.post("/refresh", async (req, res) => {
    try {
        // Refresh token logic...

        return res.status(HttpStatus.OK).json(
            ApiResponse.success("Access token refreshed successfully"),
        );
    } catch (error) {
        return res.status(HttpStatus.UNAUTHORIZED).json(
            ApiResponse.error("Invalid or expired refresh token", error),
        );
    }
});

authRouter.post("/forgot-password", async (req, res) => {
    try {
        // Forgot password logic...

        return res.status(HttpStatus.OK).json(
            ApiResponse.success("Password reset email sent"),
        );
    } catch (error) {
        return res.status(HttpStatus.INTERNAL_SERVER_ERROR).json(
            ApiResponse.error("Failed to process password reset request", error),
        );
    }
});

authRouter.post("/reset-password", async (req, res) => {
    try {
        // Reset password logic...

        return res.status(HttpStatus.OK).json(
            ApiResponse.success("Password reset successfully"),
        );
    } catch (error) {
        return res.status(HttpStatus.INTERNAL_SERVER_ERROR).json(
            ApiResponse.error("Failed to reset password", error),
        );
    }
});

// Protected routes

authRouter.get("/me", async (req, res) => {
    try {
        // Get current user...

        return res.status(HttpStatus.OK).json(
            ApiResponse.success("Current user"),
        );
    } catch (error) {
        return res.status(HttpStatus.INTERNAL_SERVER_ERROR).json(
            ApiResponse.error("Failed to get current user", error),
        );
    }
});

authRouter.post("/logout", async (req, res) => {
    try {
        // Logout logic...

        return res.status(HttpStatus.OK).json(
            ApiResponse.success("Logged out successfully"),
        );
    } catch (error) {
        return res.status(HttpStatus.INTERNAL_SERVER_ERROR).json(
            ApiResponse.error("Failed to logout", error),
        );
    }
});

export default authRouter;