// Utility functions for standardized API responses
export interface ApiResponse<T = unknown> {
  success: boolean;
  data?: T;
  error?: unknown;
  message: string;
  timestamp: string;
  pagination?: unknown;
}

export const success = <T>(
  data: T,
  message = 'OK',
  _statusCode = 200,
): ApiResponse<T> => ({
  success: true,
  data,
  message,
  timestamp: new Date().toISOString(),
});

export const error = (
  message: string,
  _statusCode = 500,
  details?: unknown,
): ApiResponse => {
  const response: ApiResponse = {
    success: false,
    message,
    timestamp: new Date().toISOString(),
  };
  if (details !== undefined) {
    response.error = details;
  }
  return response;
};

export const paginated = <T>(
  data: T,
  pagination: unknown,
  message = 'OK',
  _statusCode = 200,
): ApiResponse<T> => ({
  success: true,
  data,
  pagination,
  message,
  timestamp: new Date().toISOString(),
});

