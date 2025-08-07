import 'failures.dart';
import '../utils/logger.dart';

/// Provides global error handling utilities.
class ErrorHandler {
  const ErrorHandler._();

  /// Handles an [error] and returns a user-friendly message.
  static String handleError(Object error) {
    if (error is Failure) {
      Logger.error(error.message, error);
      return error.message;
    }
    if (error is FormatException) {
      Logger.error('Format exception: ${error.message}', error);
      return 'Invalid data format.';
    }
    Logger.error('Unexpected error', error);
    return 'An unexpected error occurred.';
  }
}
