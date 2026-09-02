import { Router } from "express";

import {
    createTask,
    deleteTask,
    getTask,
    getTasks,
    updateTask,
} from "../controllers/tasks_controller.js";

import { authenticate } from "../middleware/auth.middleware.js";

const tasksRouter = Router();

// -----------------------------------------------------------------------------
// GET /tasks/
// -----------------------------------------------------------------------------

// tasksRouter.get("/", (_req, res) => {
//     res.json({
//         success: true,
//         message: "Tasks API is working",
//     });
// });

// -----------------------------------------------------------------------------
// Protected routes
// -----------------------------------------------------------------------------

tasksRouter.get("/", authenticate, getTasks);
tasksRouter.get("/sync", authenticate, getTasks);
tasksRouter.get("/:id", authenticate, getTask);
tasksRouter.post("/", authenticate, createTask);
tasksRouter.patch("/:id", authenticate, updateTask);
tasksRouter.delete("/:id", authenticate, deleteTask);

export default tasksRouter;