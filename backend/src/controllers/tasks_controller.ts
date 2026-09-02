import { and, eq } from "drizzle-orm";
import type { Request, Response } from "express";
import { z } from "zod";
import { HttpStatus } from "../constants/http-status.js";
import { db } from "../db/index.js";
import { tasks, type NewTask } from "../db/schema.js";
import { ApiResponse } from "../utils/api-response.js";
import { logger } from "../utils/logger.js";
import {
    createTaskSchema,
    syncTasksSchema,
    updateTaskSchema,
} from "../validation/task.schema.js";

const taskIdSchema = z.object({
    id: z.uuid({ version: "v4" }),
});

// -----------------------------------------------------------------------------
// GET /tasks
// -----------------------------------------------------------------------------

export const getTasks = async (
    req: Request,
    res: Response,
) => {
    try {


        const userTasks = await db
            .select()
            .from(tasks)
            .where(eq(tasks.uid, req.userId!));

        res.status(HttpStatus.OK).json(
            ApiResponse.success(
                "Tasks fetched successfully",
                userTasks,
            ),
        );
    } catch (error) {
        logger.error("Get tasks error", error);

        res.status(HttpStatus.INTERNAL_SERVER_ERROR).json(
            ApiResponse.error(
                "Failed to fetch tasks",
                error,
            ),
        );
    }
};

// -----------------------------------------------------------------------------
// GET /tasks/:id
// -----------------------------------------------------------------------------

export const getTask = async (
    req: Request,
    res: Response,
) => {
    try {
        const validation = taskIdSchema.safeParse(req.params);

        if (!validation.success) {
            res.status(HttpStatus.BAD_REQUEST).json(
                ApiResponse.error(
                    "Invalid task ID",
                    z.treeifyError(validation.error),
                ),
            );
            return;
        }

        const { id } = validation.data;

        const [task] = await db
            .select()
            .from(tasks)
            .where(eq(tasks.id, id))
            .limit(1);

        if (!task) {
            res.status(HttpStatus.NOT_FOUND).json(
                ApiResponse.error("Task not found"),
            );
            return;
        }

        if (task.uid !== req.userId) {
            res.status(HttpStatus.FORBIDDEN).json(
                ApiResponse.error("You do not have access to this task"),
            );
            return;
        }

        res.status(HttpStatus.OK).json(
            ApiResponse.success(
                "Task fetched successfully",
                task,
            ),
        );
    } catch (error) {
        logger.error("Get task error", error);

        res.status(HttpStatus.INTERNAL_SERVER_ERROR).json(
            ApiResponse.error(
                "Failed to fetch task",
                error,
            ),
        );
    }
};

// -----------------------------------------------------------------------------
// POST /tasks
// -----------------------------------------------------------------------------

export const createTask = async (
    req: Request,
    res: Response,
) => {
    try {
        const validation = createTaskSchema.safeParse(req.body);

        if (!validation.success) {
            res.status(HttpStatus.BAD_REQUEST).json(
                ApiResponse.error(
                    "Invalid task data",
                    z.treeifyError(validation.error),
                ),
            );
            return;
        }

        const data = validation.data;

        const newTask: NewTask = {
            id: data.id,
            uid: req.userId!,
            title: data.title,
            description: data.description,

            dueAt: data.dueAt,

        };

        const [task] = await db
            .insert(tasks)
            .values(newTask)
            .returning();

        if (!task) {
            res.status(HttpStatus.INTERNAL_SERVER_ERROR).json(
                ApiResponse.error("Failed to create task"),
            );
            return;
        }

        res.status(HttpStatus.CREATED).json(
            ApiResponse.success(
                "Task created successfully",
                task,
            ),
        );
    } catch (error) {
        logger.error("Create task error", error);

        res.status(HttpStatus.INTERNAL_SERVER_ERROR).json(
            ApiResponse.error(
                "Failed to create task",
                error,
            ),
        );
    }
};

// -----------------------------------------------------------------------------
// PATCH /tasks/:id
// -----------------------------------------------------------------------------

export const updateTask = async (
    req: Request,
    res: Response,
) => {
    try {
        const idValidation = taskIdSchema.safeParse(req.params);

        if (!idValidation.success) {
            res.status(HttpStatus.BAD_REQUEST).json(
                ApiResponse.error(
                    "Invalid task ID",
                    z.treeifyError(idValidation.error),
                ),
            );
            return;
        }

        const validation = updateTaskSchema.safeParse(req.body);

        if (!validation.success) {
            res.status(HttpStatus.BAD_REQUEST).json(
                ApiResponse.error(
                    "Invalid task data",
                    z.treeifyError(validation.error),
                ),
            );
            return;
        }

        const { id } = idValidation.data;
        const data = validation.data;

        const [existingTask] = await db
            .select()
            .from(tasks)
            .where(eq(tasks.id, id))
            .limit(1);

        if (!existingTask) {
            res.status(HttpStatus.NOT_FOUND).json(
                ApiResponse.error("Task not found"),
            );
            return;
        }

        if (existingTask.uid !== req.userId) {
            res.status(HttpStatus.FORBIDDEN).json(
                ApiResponse.error("You do not have access to this task"),
            );
            return;
        }

        const [task] = await db
            .update(tasks)
            .set({
                ...data,
                updatedAt: new Date(),
            })
            .where(eq(tasks.id, id))
            .returning();

        if (!task) {
            res.status(HttpStatus.INTERNAL_SERVER_ERROR).json(
                ApiResponse.error("Failed to update task"),
            );
            return;
        }

        res.status(HttpStatus.OK).json(
            ApiResponse.success(
                "Task updated successfully",
                task,
            ),
        );
    } catch (error) {
        logger.error("Update task error", error);

        res.status(HttpStatus.INTERNAL_SERVER_ERROR).json(
            ApiResponse.error(
                "Failed to update task",
                error,
            ),
        );
    }
};

// -----------------------------------------------------------------------------
// DELETE /tasks/:id
// -----------------------------------------------------------------------------

export const deleteTask = async (
    req: Request,
    res: Response,
) => {
    try {
        const validation = taskIdSchema.safeParse(req.params);

        if (!validation.success) {
            res.status(HttpStatus.BAD_REQUEST).json(
                ApiResponse.error(
                    "Invalid task ID",
                    z.treeifyError(validation.error),
                ),
            );
            return;
        }

        const { id } = validation.data;

        const [existingTask] = await db
            .select({
                id: tasks.id,
                uid: tasks.uid,
            })
            .from(tasks)
            .where(eq(tasks.id, id))
            .limit(1);

        if (!existingTask) {
            res.status(HttpStatus.NOT_FOUND).json(
                ApiResponse.error("Task not found"),
            );
            return;
        }

        if (existingTask.uid !== req.userId) {
            res.status(HttpStatus.FORBIDDEN).json(
                ApiResponse.error("You do not have access to this task"),
            );
            return;
        }

        const [deletedTask] = await db
            .delete(tasks)
            .where(eq(tasks.id, id))
            .returning({
                id: tasks.id,
            });

        if (!deletedTask) {
            res.status(HttpStatus.INTERNAL_SERVER_ERROR).json(
                ApiResponse.error("Failed to delete task"),
            );
            return;
        }

        res.status(HttpStatus.OK).json(
            ApiResponse.success(
                "Task deleted successfully",
                deletedTask,
            ),
        );
    } catch (error) {
        logger.error("Delete task error", error);

        res.status(HttpStatus.INTERNAL_SERVER_ERROR).json(
            ApiResponse.error(
                "Failed to delete task",
                error,
            ),
        );
    }
};

export const syncTasks = async (
    req: Request,
    res: Response,
): Promise<void> => {
    try {
        const userId = req.userId;

        if (!userId) {
            res.status(HttpStatus.UNAUTHORIZED).json(
                ApiResponse.error("Unauthorized"),
            );
            return;
        }

        const result = syncTasksSchema.safeParse(req.body);

        if (!result.success) {
            res.status(HttpStatus.BAD_REQUEST).json(
                ApiResponse.error(
                    "Invalid sync payload",
                    z.treeifyError(result.error),
                ),
            );
            return;
        }

        const { tasks: localTasks } = result.data;

        await db.transaction(async (tx) => {
            for (const localTask of localTasks) {
                // New task
                if (localTask.isNew) {
                    await tx.insert(tasks).values({
                        id: localTask.id,
                        uid: userId,
                        title: localTask.title,
                        description: localTask.description ?? null,
                        createdAt: localTask.createdAt,
                        updatedAt: localTask.updatedAt ?? localTask.createdAt,
                        dueAt: localTask.dueAt,
                    });

                    continue;
                }

                // Deleted task
                if (localTask.isDeleted) {
                    await tx
                        .delete(tasks)
                        .where(
                            and(
                                eq(tasks.id, localTask.id),
                                eq(tasks.uid, userId),
                            ),
                        );

                    continue;
                }

                // Updated task
                await tx
                    .update(tasks)
                    .set({
                        title: localTask.title,
                        description: localTask.description ?? null,
                        dueAt: localTask.dueAt,
                        updatedAt: localTask.updatedAt ?? new Date(),
                    })
                    .where(
                        and(
                            eq(tasks.id, localTask.id),
                            eq(tasks.uid, userId),
                        ),
                    );
            }
        });

        // Get the latest version of the user's tasks
        const updatedTasks = await db
            .select()
            .from(tasks)
            .where(eq(tasks.uid, userId));

        res.status(HttpStatus.OK).json(
            ApiResponse.success("Task Synced success", updatedTasks,),
        );
    } catch (error) {
        logger.error("Failed to sync tasks", error);

        res.status(HttpStatus.INTERNAL_SERVER_ERROR).json(
            ApiResponse.error("Failed to sync tasks"),
        );
    }
};