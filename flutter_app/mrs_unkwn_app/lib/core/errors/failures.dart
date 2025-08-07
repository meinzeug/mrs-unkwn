/// Base class for failures in the application.
abstract class Failure {
  /// Message describing the failure.
  final String message;

  /// Creates a new failure with an optional message.
  const Failure([this.message = '']);
}

/// Represents a server-side failure.
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server Failure']);
}

/// Represents a network connectivity failure.
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Network Failure']);
}

/// Represents an authentication failure.
class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication Failure']);
}
