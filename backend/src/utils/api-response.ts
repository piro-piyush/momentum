export class ApiResponse<T = unknown> {
    constructor(
        public readonly success: boolean,
        public readonly message: string,
        public readonly data?: T,
        public readonly errors?: unknown,
    ) { }

    static success<T>(
        message: string,
        data?: T,
    ): ApiResponse<T> {
        return new ApiResponse(true, message, data);
    }

    static error(
        message: string,
        errors?: unknown,
    ): ApiResponse {
        return new ApiResponse(false, message, undefined, errors);
    }
}