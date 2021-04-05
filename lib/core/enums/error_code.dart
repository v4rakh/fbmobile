/// Enums for error codes
enum ErrorCode {
  /// A generic error
  GENERAL_ERROR,

  /// Errors related to connections
  SOCKET_ERROR,
  SOCKET_TIMEOUT,

  /// A REST error (response code wasn't 200 or 204)
  REST_ERROR,

  /// Custom errors
  INVALID_API_KEY
}
