import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../../constants.dart';
import '../../core/enums/error_code.dart';
import '../../core/error/rest_service_exception.dart';
import '../../core/error/service_exception.dart';
import '../../core/services/api_error_converter.dart';
import '../models/rest/rest_error.dart';
import '../util/logger.dart';

class Api implements ApiErrorConverter {
  final Logger _logger = getLogger();

  static const String _errorNoConnection = 'No internet connection';
  static const String _errorTimeout = 'Request timed out';
  static const String _formDataApiKey = 'apikey';
  static const String _applicationJson = "application/json";

  String _url = "";
  String _apiKey = "";

  Map<String, String> _headers = {"Content-Type": _applicationJson, "Accept": _applicationJson};
  Duration _timeout = Duration(seconds: Constants.apiRequestTimeoutLimit);

  Future<http.Response> fetch<T>(String route) async {
    try {
      _logger
          .d("Requesting GET API endpoint '${_url + route}' with headers '$_headers' and maximum timeout '$_timeout'");
      var response = await http.get(_url + route, headers: _headers).timeout(_timeout);
      handleRestErrors(response);
      return response;
    } on TimeoutException {
      throw ServiceException(code: ErrorCode.SOCKET_TIMEOUT, message: _errorTimeout);
    } on SocketException {
      throw ServiceException(code: ErrorCode.SOCKET_ERROR, message: _errorNoConnection);
    }
  }

  Future<http.Response> post<T>(String route,
      {Map<String, String> fields, List<File> files, Map<String, String> additionalFiles}) async {
    try {
      var uri = Uri.parse(_url + route);
      var request = http.MultipartRequest('POST', uri)
        ..headers['Content-Type'] = _applicationJson
        ..headers["Accept"] = _applicationJson;

      if (_apiKey.isNotEmpty) {
        request.fields[_formDataApiKey] = _apiKey;
      }

      if (fields != null && fields.isNotEmpty) {
        request.fields.addAll(fields);
      }

      if (files != null && files.isNotEmpty) {
        files.forEach((element) async {
          request.files.add(await http.MultipartFile.fromPath('file[${files.indexOf(element) + 1}]', element.path));
        });
      }

      if (additionalFiles != null && additionalFiles.length > 0) {
        List<String> keys = additionalFiles.keys.toList();
        additionalFiles.forEach((key, value) {
          var index = files != null ? files.length + keys.indexOf(key) + 1 : keys.indexOf(key) + 1;
          request.files.add(http.MultipartFile.fromString('file[$index]', value, filename: key));
        });
      }

      _logger.d("Requesting POST API endpoint '${uri.toString()}' and ${request.files.length} files");
      var multiResponse = await request.send();
      var response = await http.Response.fromStream(multiResponse);
      handleRestErrors(response);
      return response;
    } on TimeoutException {
      throw ServiceException(code: ErrorCode.SOCKET_TIMEOUT, message: _errorTimeout);
    } on SocketException {
      throw ServiceException(code: ErrorCode.SOCKET_ERROR, message: _errorNoConnection);
    }
  }

  void setUrl(String url) {
    _url = url + Constants.apiUrlSuffix;
  }

  void removeUrl() {
    _url = "";
  }

  void setTimeout(Duration timeout) {
    _timeout = timeout;
  }

  void addApiKeyAuthorization(apiKey) {
    _apiKey = apiKey;
  }

  void removeApiKeyAuthorization() {
    _apiKey = "";
  }

  /// if there's a JSON response body in error case, the RestServiceException will
  /// have a json decoded object. Replace this with a custom
  /// conversion method by overwriting the interface if needed
  void handleRestErrors(http.Response response) {
    if (response != null) {
      if (response.statusCode != HttpStatus.ok && response.statusCode != HttpStatus.noContent) {
        if (response.headers.containsKey(HttpHeaders.contentTypeHeader)) {
          ContentType responseContentType = ContentType.parse(response.headers[HttpHeaders.contentTypeHeader]);

          if (ContentType.json.primaryType == responseContentType.primaryType &&
              ContentType.json.subType == responseContentType.subType) {
            var parsedBody = convert(response);
            throw new RestServiceException(response.statusCode, responseBody: parsedBody);
          }
        }

        throw new RestServiceException(response.statusCode);
      }
    }
  }

  @override
  convert(http.Response response) {
    return RestError.fromJson(json.decode(response.body));
  }
}
