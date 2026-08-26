import pino, { type LoggerOptions } from "pino";

class Logger {
    private readonly logger: pino.Logger;

    constructor() {
        const options: LoggerOptions = {
            level: process.env.LOG_LEVEL ?? "info",

            base: {
                service: "momentum-api",
            },

            timestamp: pino.stdTimeFunctions.isoTime,
        };

        if (process.env.NODE_ENV === "development") {
            options.transport = {
                target: "pino-pretty",
                options: {
                    colorize: true,
                    translateTime: "SYS:standard",
                    ignore: "pid,hostname",
                },
            };
        }

        this.logger = pino(options);
    }

    info(message: string, data?: object): void {
        if (data) {
            this.logger.info(data, message);
        } else {
            this.logger.info(message);
        }
    }

    warn(message: string, data?: object): void {
        if (data) {
            this.logger.warn(data, message);
        } else {
            this.logger.warn(message);
        }
    }

    error(
        message: string,
        error?: unknown,
        data?: object,
    ): void {
        if (error instanceof Error) {
            this.logger.error(
                {
                    err: error,
                    ...data,
                },
                message,
            );

            return;
        }

        this.logger.error(
            {
                error,
                ...data,
            },
            message,
        );
    }

    debug(message: string, data?: object): void {
        if (data) {
            this.logger.debug(data, message);
        } else {
            this.logger.debug(message);
        }
    }
}

export const logger = new Logger();