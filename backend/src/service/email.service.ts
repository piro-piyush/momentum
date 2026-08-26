import { Resend } from "resend";

import { logger } from "../utils/logger.js";

const resend = new Resend(process.env.RESEND_API_KEY);

const FROM_EMAIL =
    process.env.MAIL_FROM ?? "Momentum <onboarding@resend.dev>";

const FRONTEND_URL =
    process.env.FRONTEND_URL ?? "http://localhost:3000";

export interface SendPasswordResetEmailParams {
    email: string;
    resetToken: string;
}

export const emailService = {
    sendPasswordResetEmail: async ({
        email,
        resetToken,
    }: SendPasswordResetEmailParams): Promise<void> => {
        const resetUrl =
            `${FRONTEND_URL}/reset-password?token=${encodeURIComponent(resetToken)}`;

        const { error } = await resend.emails.send({
            from: FROM_EMAIL,
            to: email,
            subject: "Reset your Momentum password",
            html: `
                <!DOCTYPE html>
                <html>
                    <head>
                        <meta charset="UTF-8" />
                        <meta
                            name="viewport"
                            content="width=device-width, initial-scale=1.0"
                        />
                        <title>Reset your Momentum password</title>
                    </head>

                    <body
                        style="
                            margin: 0;
                            padding: 0;
                            background-color: #f5f5f5;
                            font-family: Arial, Helvetica, sans-serif;
                        "
                    >
                        <div
                            style="
                                max-width: 600px;
                                margin: 40px auto;
                                background: #ffffff;
                                border-radius: 12px;
                                padding: 40px;
                                box-sizing: border-box;
                            "
                        >
                            <h1
                                style="
                                    margin: 0 0 24px;
                                    color: #111111;
                                    font-size: 28px;
                                "
                            >
                                Reset your password
                            </h1>

                            <p
                                style="
                                    color: #555555;
                                    font-size: 16px;
                                    line-height: 1.6;
                                "
                            >
                                We received a request to reset your Momentum
                                account password.
                            </p>

                            <p
                                style="
                                    color: #555555;
                                    font-size: 16px;
                                    line-height: 1.6;
                                "
                            >
                                Click the button below to create a new
                                password.
                            </p>

                            <div style="margin: 32px 0;">
                                <a
                                    href="${resetUrl}"
                                    style="
                                        display: inline-block;
                                        padding: 14px 24px;
                                        background-color: #111111;
                                        color: #ffffff;
                                        text-decoration: none;
                                        border-radius: 8px;
                                        font-size: 16px;
                                        font-weight: 600;
                                    "
                                >
                                    Reset Password
                                </a>
                            </div>

                            <p
                                style="
                                    color: #777777;
                                    font-size: 14px;
                                    line-height: 1.6;
                                "
                            >
                                This link will expire in 15 minutes.
                            </p>

                            <p
                                style="
                                    color: #777777;
                                    font-size: 14px;
                                    line-height: 1.6;
                                "
                            >
                                If you didn't request a password reset, you
                                can safely ignore this email.
                            </p>

                            <hr
                                style="
                                    margin: 32px 0;
                                    border: 0;
                                    border-top: 1px solid #eeeeee;
                                "
                            />

                            <p
                                style="
                                    margin: 0;
                                    color: #999999;
                                    font-size: 12px;
                                "
                            >
                                © ${new Date().getFullYear()} Momentum
                            </p>
                        </div>
                    </body>
                </html>
            `,
        });

        if (error) {
            logger.error("Failed to send password reset email", {
                email,
                error,
            });

            throw new Error("Failed to send password reset email");
        }

        logger.info("Password reset email sent", {
            email,
        });
    },
};