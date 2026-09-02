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
    createdAt: z.coerce.date(),
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
    dueAt: z.coerce.date().optional(),
    updatedAt: z.coerce.date(),
});

export type CreateTaskInput = z.infer<typeof createTaskSchema>;
export type UpdateTaskInput = z.infer<typeof updateTaskSchema>;

export const syncTaskSchema = z.object({
    id: z.uuid(),

    title: z.string().trim().min(1).max(255),

    description: z.string().nullable().optional(),

    color: z.number().int(),

    createdAt: z.coerce.date(),

    updatedAt: z.coerce.date().nullable().optional(),

    dueAt: z.coerce.date(),

    isNew: z.boolean(),

    isDeleted: z.boolean(),
});

export const syncTasksSchema = z.object({
    lastSyncedAt: z.coerce.date().nullable().optional(),

    tasks: z.array(syncTaskSchema),
});

export type SyncTaskInput = z.infer<typeof syncTaskSchema>;