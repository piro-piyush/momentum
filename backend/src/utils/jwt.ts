import jwt from "jsonwebtoken";

const JWT_SECRET = process.env.JWT_SECRET;

if (!JWT_SECRET) {
    throw new Error("JWT_SECRET is not configured");
}

const JWT_ISSUER = "momentum-api";
const JWT_AUDIENCE = "momentum-app";

export interface AccessTokenPayload {
    sub: string;
}

export const generateAccessToken = (userId: string): string => {
    return jwt.sign(
        {
            sub: userId,
        },
        JWT_SECRET,
        {
            algorithm: "HS256",
            // expiresIn: "15m",
            issuer: JWT_ISSUER,
            audience: JWT_AUDIENCE,
        },
    );
};

export const verifyAccessToken = (
    token: string,
): AccessTokenPayload => {
    try {
        const payload = jwt.verify(token, JWT_SECRET, {
            algorithms: ["HS256"],
            issuer: JWT_ISSUER,
            audience: JWT_AUDIENCE,
        });

        if (
            typeof payload !== "object" ||
            payload === null ||
            typeof payload.sub !== "string"
        ) {
            throw new Error("Invalid token payload");
        }

        return {
            sub: payload.sub,
        };
    } catch (error) {
        if (error instanceof jwt.TokenExpiredError) {
            throw new Error("Access token has expired");
        }

        if (error instanceof jwt.JsonWebTokenError) {
            throw new Error("Invalid access token");
        }

        throw error;
    }
};