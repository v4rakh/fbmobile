import '../enums/error_code.dart';

class ServiceException implements Exception {
  final ErrorCode code;
  final String message;

  ServiceException({this.code = ErrorCode.GENERAL_ERROR, this.message = ''});

  String toString() {
    return "$code: $message";
  }
}
