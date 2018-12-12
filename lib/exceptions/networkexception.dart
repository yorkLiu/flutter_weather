
/// Network Exception
class NetworkException extends Exception{
  factory NetworkException([var message]) => Exception(message);

  final String message;

  @override
  String toString() {
    if (message == null) return "NetworkException";
    return "NetworkException: $message";
  }
}