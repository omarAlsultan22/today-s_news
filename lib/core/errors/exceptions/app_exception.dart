abstract class AppException implements Exception {
  final String message;
  final bool isConnection;
  final StackTrace? stackTrace;

  const AppException(this.message, this.isConnection, [this.stackTrace]);
}