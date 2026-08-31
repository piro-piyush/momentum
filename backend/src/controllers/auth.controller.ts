import bcrypt from "bcryptjs";
import { eq } from "drizzle-orm";
import type { Request, Response } from "express";
import { HttpStatus } from "../constants/http-status.js";
import { db } from "../db/index.js";
import { passwordResetTokens, users, type NewUser } from "../db/schema.js";
import type {
    AuthUser,
    ForgetPasswordBody,
    LoginBody,
    RegisterBody,
    ResetPasswordBody,
} from "../models/auth.model.js";
import { ApiResponse } from "../utils/api-response.js";
import { generateAccessToken, verifyAccessToken } from "../utils/jwt.js";
import { logger } from "../utils/logger.js";

import crypto from "node:crypto";
import { emailService } from "../service/email.service.js";

export const register = async (
    req: Request<{}, {}, RegisterBody>,
    res: Response,
) => {
    try {
        const { name, email, password } = req.body;

        // Check if user already exists
        const existingUser = await db
            .select({
                id: users.id,
            })
            .from(users)
            .where(eq(users.email, email))
            .limit(1);

        if (existingUser.length > 0) {
            return res.status(HttpStatus.CONFLICT).json(
                ApiResponse.error(
                    "User with this email already exists",
                ),
            );
        }

        // Hash password
        const hashedPassword = await bcrypt.hash(
            password,
            12,
        );

        const newUser: NewUser = {
            name,
            email,
            password: hashedPassword,
        };

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

        if (!user) {
            return res.status(
                HttpStatus.INTERNAL_SERVER_ERROR,
            ).json(
                ApiResponse.error(
                    "Failed to create user",
                ),
            );
        }

        // Generate access token
        const accessToken = generateAccessToken(user.id);

        return res.status(HttpStatus.CREATED).json(
            ApiResponse.success(
                "User registered successfully",
                {
                    ...user,
                    token: accessToken,
                },
            ),
        );
    } catch (error) {
        logger.error("Register error", error, {
            email: req.body.email,
        });

        return res.status(
            HttpStatus.INTERNAL_SERVER_ERROR,
        ).json(
            ApiResponse.error(
                "Failed to register user", error
            ),
        );
    }
};
export const login = async (
    req: Request<{}, {}, LoginBody>,
    res: Response,
) => {
    try {
        const { email, password } = req.body;

        // Find user by email
        const [existingUser] = await db
            .select({
                id: users.id,
                name: users.name,
                email: users.email,
                password: users.password,
                createdAt: users.createdAt,
            })
            .from(users)
            .where(eq(users.email, email))
            .limit(1);

        // User doesn't exist
        if (!existingUser) {
            return res.status(HttpStatus.UNAUTHORIZED).json(
                ApiResponse.error("Invalid email or password"),
            );
        }

        // Verify password
        const passwordMatched = await bcrypt.compare(
            password,
            existingUser.password,
        );

        if (!passwordMatched) {
            return res.status(HttpStatus.UNAUTHORIZED).json(
                ApiResponse.error("Invalid email or password"),
            );
        }

        // Generate access token
        const accessToken = generateAccessToken(existingUser.id);

        // Safe user response
        const user: AuthUser = {
            id: existingUser.id,
            name: existingUser.name,
            email: existingUser.email,
            createdAt: existingUser.createdAt,
        };

        return res.status(HttpStatus.OK).json(
            ApiResponse.success(
                "User logged in successfully",
                {
                    ...user,
                    token: accessToken,
                },
            ),
        );
    } catch (error) {
        logger.error("Login error", error, {
            email: req.body.email,
        });

        return res.status(HttpStatus.INTERNAL_SERVER_ERROR).json(
            ApiResponse.error("Failed to login", error),
        );
    }
};

export const getMe = async (
    req: Request,
    res: Response,
) => {
    try {
        if (!req.userId) {
            return res.status(HttpStatus.UNAUTHORIZED).json(
                ApiResponse.error("Authentication required"),
            );
        }

        const [user] = await db
            .select({
                id: users.id,
                name: users.name,
                email: users.email,
                createdAt: users.createdAt,
            })
            .from(users)
            .where(eq(users.id, req.userId))
            .limit(1);

        if (!user) {
            return res.status(HttpStatus.NOT_FOUND).json(
                ApiResponse.error("User not found"),
            );
        }

        const userResponse: AuthUser = user;

        return res.status(HttpStatus.OK).json(
            ApiResponse.success(
                "Current user",
                userResponse,
            ),
        );
    } catch (error) {
        logger.error("Get current user error", error, {
            userId: req.userId,
        });

        return res.status(HttpStatus.INTERNAL_SERVER_ERROR).json(
            ApiResponse.error("Failed to get current user", error),
        );
    }
};
export const tokenIsValid = async (
    req: Request,
    res: Response,
) => {
    try {
        const authHeader = req.header("Authorization");

        if (!authHeader) {
            return res.status(HttpStatus.UNAUTHORIZED).json(
                ApiResponse.success("Token validation result", {
                    valid: false,
                }),
            );
        }

        const [scheme, token] = authHeader.split(" ");

        if (scheme !== "Bearer" || !token) {
            return res.status(HttpStatus.UNAUTHORIZED).json(
                ApiResponse.success("Token validation result", {
                    valid: false,
                }),
            );
        }

        // Verify JWT signature, issuer, audience and expiration
        const payload = verifyAccessToken(token);

        // JWT must contain a user ID
        if (!payload.sub) {
            return res.status(HttpStatus.UNAUTHORIZED).json(
                ApiResponse.success("Token validation result", {
                    valid: false,
                }),
            );
        }

        // Check whether user still exists in database
        const [user] = await db
            .select({
                id: users.id,
            })
            .from(users)
            .where(eq(users.id, payload.sub))
            .limit(1);

        // JWT is valid but user doesn't exist anymore
        if (!user) {
            return res.status(HttpStatus.UNAUTHORIZED).json(
                ApiResponse.success("Token validation result", {
                    valid: false,
                }),
            );
        }

        return res.status(HttpStatus.OK).json(
            ApiResponse.success("Token is valid", {
                valid: true,
                userId: user.id,
            }),
        );
    } catch (error) {
        logger.error("Token validation error", error);

        return res.status(HttpStatus.UNAUTHORIZED).json(
            ApiResponse.success("Token validation result", {
                valid: false,
            }),
        );
    }
};
export const forgotPassword = async (
    req: Request<{}, {}, ForgetPasswordBody>,
    res: Response,
) => {
    try {
        const { email } = req.body;

        const [user] = await db
            .select({
                id: users.id,
                email: users.email,
            })
            .from(users)
            .where(eq(users.email, email))
            .limit(1);

        /*
         * Always return the same response whether the
         * email exists or not.
         *
         * This prevents email enumeration.
         */
        if (!user) {
            return res.status(HttpStatus.OK).json(
                ApiResponse.success(
                    "If an account exists with this email, a password reset link has been sent.",
                ),
            );
        }

        // Generate secure random token
        const resetToken = crypto
            .randomBytes(32)
            .toString("hex");

        // Store only the hash in database
        const tokenHash = crypto
            .createHash("sha256")
            .update(resetToken)
            .digest("hex");

        // Token expires in 15 minutes
        const expiresAt = new Date(
            Date.now() + 15 * 60 * 1000,
        );

        // Remove previous reset tokens
        await db
            .delete(passwordResetTokens)
            .where(
                eq(
                    passwordResetTokens.userId,
                    user.id,
                ),
            );

        // Store new reset token
        await db
            .insert(passwordResetTokens)
            .values({
                userId: user.id,
                tokenHash,
                expiresAt,
            });

        // Send password reset email
        await emailService.sendPasswordResetEmail({
            email: user.email,
            resetToken,
        });

        logger.info("Password reset requested", {
            userId: user.id,
            email: user.email,
        });

        return res.status(HttpStatus.OK).json(
            ApiResponse.success(
                "If an account exists with this email, a password reset link has been sent.",
            ),
        );
    } catch (error) {
        logger.error("Forgot password error", error);

        return res.status(HttpStatus.INTERNAL_SERVER_ERROR).json(
            ApiResponse.error(
                "Failed to process password reset request", error
            ),
        );
    }
};
export const resetPassword = async (
    req: Request<
        {},
        {},
        ResetPasswordBody
    >,
    res: Response,
) => {
    try {
        const { token, password } = req.body;

        if (!token || !password) {
            return res.status(HttpStatus.BAD_REQUEST).json(
                ApiResponse.error(
                    "Token and password are required",
                ),
            );
        }

        // Hash token received from client
        const tokenHash = crypto
            .createHash("sha256")
            .update(token)
            .digest("hex");

        // Find valid reset token
        const [resetRecord] = await db
            .select({
                id: passwordResetTokens.id,
                userId: passwordResetTokens.userId,
                expiresAt: passwordResetTokens.expiresAt,
            })
            .from(passwordResetTokens)
            .where(
                eq(
                    passwordResetTokens.tokenHash,
                    tokenHash,
                ),
            )
            .limit(1);

        // Invalid token
        if (!resetRecord) {
            return res.status(HttpStatus.BAD_REQUEST).json(
                ApiResponse.error(
                    "Invalid or expired password reset token",
                ),
            );
        }

        // Expired token
        if (resetRecord.expiresAt.getTime() < Date.now()) {
            await db
                .delete(passwordResetTokens)
                .where(
                    eq(
                        passwordResetTokens.id,
                        resetRecord.id,
                    ),
                );

            return res.status(HttpStatus.BAD_REQUEST).json(
                ApiResponse.error(
                    "Invalid or expired password reset token",
                ),
            );
        }

        // Hash new password
        const hashedPassword = await bcrypt.hash(
            password,
            12,
        );

        // Update password
        await db
            .update(users)
            .set({
                password: hashedPassword,
                updatedAt: new Date(),
            })
            .where(eq(users.id, resetRecord.userId));

        // Delete token so it cannot be reused
        await db
            .delete(passwordResetTokens)
            .where(
                eq(
                    passwordResetTokens.id,
                    resetRecord.id,
                ),
            );

        return res.status(HttpStatus.OK).json(
            ApiResponse.success(
                "Password reset successfully",
            ),
        );
    } catch (error) {
        logger.error("Reset password error", error);

        return res.status(HttpStatus.INTERNAL_SERVER_ERROR).json(
            ApiResponse.error(
                "Failed to reset password", error
            ),
        );
    }
};