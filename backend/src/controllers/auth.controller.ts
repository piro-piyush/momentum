import bcrypt from "bcryptjs";
import { eq } from "drizzle-orm";
import type { Request, Response } from "express";

import { HttpStatus } from "../constants/http-status.js";
import { db } from "../db/index.js";
import { users, type NewUser } from "../db/schema.js";
import type {
    AuthUser,
    LoginBody,
    RegisterBody,
} from "../models/auth.model.js";
import { ApiResponse } from "../utils/api-response.js";
import { generateAccessToken } from "../utils/jwt.js";
export const register = async (
    req: Request<{}, {}, RegisterBody>,
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
                ApiResponse.error(
                    "User with this email already exists",
                ),
            );
        }

        // Hash password
        const hashedPassword = await bcrypt.hash(password, 8);

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
            return res.status(HttpStatus.INTERNAL_SERVER_ERROR).json(
                ApiResponse.error("Failed to create user"),
            );
        }

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
                    user,
                    accessToken,
                },
            ),
        );
    } catch (error) {
        console.error("Login error:", error);

        return res.status(HttpStatus.INTERNAL_SERVER_ERROR).json(
            ApiResponse.error("Failed to login"),
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
        console.error("Get current user error:", error);

        return res.status(HttpStatus.INTERNAL_SERVER_ERROR).json(
            ApiResponse.error("Failed to get current user"),
        );
    }
};