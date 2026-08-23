import app from "./app.js";

const PORT = Number(process.env.PORT) || 8000;
const HOST = process.env.HOST || "0.0.0.0";

const server = app.listen(PORT, HOST, () => {
  console.log(`
🚀 Server started

   Local:   http://localhost:${PORT}
   API:     http://localhost:${PORT}/api/v1
   Health:  http://localhost:${PORT}/api/v1/health

   Environment: ${process.env.NODE_ENV || "development"}
  `);
});

const shutdown = (signal: string) => {
  console.log(`\n${signal} received. Shutting down...`);

  server.close(() => {
    console.log("Server closed.");
    process.exit(0);
  });
};

process.on("SIGTERM", () => shutdown("SIGTERM"));
process.on("SIGINT", () => shutdown("SIGINT"));