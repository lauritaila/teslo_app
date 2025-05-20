// class WrongCredentialsException implements Exception {}
// class InvalidTokenException implements Exception {}
// class ConectionTimeoutException implements Exception {}
class CustomException implements Exception {
  final String message;
  // final int? code;
  CustomException(this.message);
}