// SocketException
// Unauthorised exception

class ApiException implements Exception {
  final String? message;

  ApiException(this.message);
}

class UnauthorisedException extends ApiException {
  UnauthorisedException() : super("Invalid Credentials");
}

class ServerError extends ApiException {
  ServerError() : super("Server Error");
}
