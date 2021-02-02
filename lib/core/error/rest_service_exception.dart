import '../enums/error_code.dart';
import 'service_exception.dart';

class RestServiceException extends ServiceException {
  final int statusCode;
  final dynamic responseBody;

  RestServiceException(this.statusCode, {this.responseBody, String message})
      : super(code: ErrorCode.REST_ERROR, message: message);

  String toString() {
    return "$code $statusCode $message";
  }
}
