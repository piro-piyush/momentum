import type { NextFunction, Request, Response } from "express";

import { HttpStatus } from "../constants/http-status.js";
import { ApiResponse } from "../utils/api-response.js";
import { verifyAccessToken } from "../utils/jwt.js";

export interface AuthenticatedRequest extends Request {
    userId: string;
}

export const authenticate = (
    req: Request,
    res: Response,
    next: NextFunction,
) => {
    try {
        const authorization = req.headers.authorization;

        if (!authorization) {
            return res.status(HttpStatus.UNAUTHORIZED).json(
                ApiResponse.error("Authentication required"),
            );
        }

        const [scheme, token] = authorization.split(" ");

        if (scheme !== "Bearer" || !token) {
            return res.status(HttpStatus.UNAUTHORIZED).json(
                ApiResponse.error("Invalid authorization header"),
            );
        }

        const payload = verifyAccessToken(token);

        if (!payload.sub) {
            return res.status(HttpStatus.UNAUTHORIZED).json(
                ApiResponse.error("Invalid access token"),
            );
        }

        (req as AuthenticatedRequest).userId = payload.sub;

        next();
    } catch (error) {
        console.error("Authentication error:", error);

        return res.status(HttpStatus.UNAUTHORIZED).json(
            ApiResponse.error("Invalid or expired access token"),
        );
    }
};