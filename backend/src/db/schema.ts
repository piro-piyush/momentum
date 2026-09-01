import {
    pgTable,
    text,
    timestamp,
    uuid
} from "drizzle-orm/pg-core";

export const users = pgTable("users", {
    id: uuid("id")
        .primaryKey()
        .defaultRandom(),

    name: text("name")
        .notNull(),

    email: text("email")
        .notNull()
        .unique(),

    password: text("password")
        .notNull(),

    createdAt: timestamp("created_at", {
        withTimezone: true,
    })
        .defaultNow()
        .notNull(),

    updatedAt: timestamp("updated_at", {
        withTimezone: true,
    })
        .defaultNow()
        .notNull(),
});

export type User = typeof users.$inferSelect;
export type NewUser = typeof users.$inferInsert;

export const passwordResetTokens = pgTable(
    "password_reset_tokens",
    {
        id: uuid("id")
            .primaryKey()
            .defaultRandom(),

        userId: uuid("user_id")
            .notNull()
            .references(() => users.id, {
                onDelete: "cascade",
            }),

        tokenHash: text("token_hash")
            .notNull()
            .unique(),

        expiresAt: timestamp("expires_at", {
            withTimezone: true,
        }).notNull(),

        createdAt: timestamp("created_at", {
            withTimezone: true,
        })
            .defaultNow()
            .notNull(),
    },
);

// ============================================================================
// TASKS
// ============================================================================
export const tasks = pgTable("tasks", {
    id: uuid("id")
        .primaryKey()
        .defaultRandom(),

    uid: uuid("uid")
        .notNull()
        .references(() => users.id, {
            onDelete: "cascade",
        }),

    title: text("title")
        .notNull(),

    description: text("description"),

    // Flutter Color.toARGB32() value.
    color: text("color").notNull(),

    createdAt: timestamp("created_at", {
        withTimezone: true,
    })
        .defaultNow()
        .notNull(),

    updatedAt: timestamp("updated_at", {
        withTimezone: true,
    }),

    dueAt: timestamp("due_at", {
        withTimezone: true,
    })
        .notNull(),
});

export type Task = typeof tasks.$inferSelect;
export type NewTask = typeof tasks.$inferInsert;