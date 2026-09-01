import { z } from "zod";

export const createTaskSchema = z.object({
    id: z.uuid({ version: "v4" }),

    title: z
        .string()
        .trim()
        .min(1, "Title is required")
        .max(200, "Title must be 200 characters or less"),

    description: z
        .string()
        .trim()
        .nullable()
        .default(null),

    color: z
        .string()
        .regex(
            /^[0-9A-Fa-f]{6}$/,
            "Color must be a valid RGB hex color",
        ),

    dueAt: z.coerce.date(),
});

export const updateTaskSchema = z.object({
    title: z
        .string()
        .trim()
        .min(1, "Title is required")
        .max(200, "Title must be 200 characters or less")
        .optional(),

    description: z
        .string()
        .trim()
        .nullable()
        .optional(),

    color: z
        .string()
        .regex(
            /^[0-9A-Fa-f]{6}$/,
            "Color must be a valid RGB hex color",
        )
        .optional(),

    dueAt: z.coerce.date().optional(),
});

export type CreateTaskInput = z.infer<typeof createTaskSchema>;
export type UpdateTaskInput = z.infer<typeof updateTaskSchema>;