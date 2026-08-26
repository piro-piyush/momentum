import type { User } from "../db/schema.js";

export interface RegisterBody {
    name: string;
    email: string;
    password: string;
}

export interface LoginBody {
    email: string;
    password: string;
}
export interface ForgetPasswordBody {
    email: string;
}
export interface ResetPasswordBody {
    token: string;
    password: string;
}

export type AuthUser = Pick<
    User,
    "id" | "name" | "email" | "createdAt"
>;