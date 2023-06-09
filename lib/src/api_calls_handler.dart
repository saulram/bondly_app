// ignore_for_file: constant_identifier_names

import "dart:async";
import "dart:convert";
import 'dart:io' show SocketException, IOException;

import 'package:bondly_app/config/environment.dart';
import 'package:flutter/foundation.dart';
import "package:http/http.dart" as http;
import 'package:logger/logger.dart';

const String jsonContentType = "application/json";
const String formContentType = "application/x-www-form-urlencoded";

class ServerErrorException implements Exception {}
class ServiceNotFoundException implements Exception {}
class UnauthorizedException implements Exception {}

enum Methods {
  POST,
  GET,
  DELETE,
  PUT;
}

// Base Service API.
abstract class CallsHandler {
  final String _appVersion;
  final String _buildNumber;

  CallsHandler(this._appVersion, this._buildNumber);

  /// In case we need to add more web specific headers
  Map<String, String> get _webHeaders {
    Map<String, String> headers = commonHeaders;

    return headers;
  }

  /// In case we need to add more mobile specific headers
  Map<String, String> get _mobileHeaders {
    Map<String, String> headers = commonHeaders;

    return headers;
  }

  Map<String, String> get commonHeaders {
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      "Device-Application-Version": _appVersion,
      "Device-Build-Number": _buildNumber,
    };
    return headers;
  }

  @visibleForTesting
  Map<String, String> get baseHeaders {
    if(kIsWeb) return _webHeaders;

    return _mobileHeaders;
  }

  void logRequest(String method, String url, String? requestBody) {
    Logger().i('API start [$method] $url, request:');
    Logger().i(requestBody);
  }

  void logResponse(http.Response response) {
    try {
      var data = jsonDecode(response.body);
      dynamic detail = data ?? data["error"];
      Logger().i("API end [${response.request?.method.toUpperCase()}] "
          "${response.statusCode} ${response.request?.url} "
          "success: ${data['success']} detail: $detail");
    } catch(e) {
      Logger().i("API end [${response.request?.method.toUpperCase()}] "
          "${response.statusCode} ${response.request?.url} "
          "success: false detail: ${e.toString()}");
    }
  }

  void throwOnFailureCode(http.Response response) {
    /// Log this response
    logResponse(response);

    switch (response.statusCode) {
      case 403: throw UnauthorizedException();
      case 404: throw ServiceNotFoundException();
      case >= 500: throw ServerErrorException();
    }
  }

  String _bookendSlash(String path) {
    if (path.substring(path.length - 1) != "/") {
      path = "$path/";
    }
    if (path.substring(0, 1) != "/") {
      path = "/$path";
    }
    return path;
  }
}

class ApiCallsHandler extends CallsHandler {

  ApiCallsHandler(
    String appVersion,
    String buildNumber,
  ) : super(appVersion, buildNumber);

  final http.Client _baseClient = http.Client();
  http.Client get _client {
    return _baseClient;
  }

  /// -----------------------------------------------------------------------
  /// Http methods.
  /// -----------------------------------------------------------------------

  Future<http.Response> post(
      String path,
      {Map<String, dynamic>? data,
      Map<String, String>? extraHeaders}
  ) async {
    return _enqueueCall(path, Methods.POST, params: data, extraHeaders: extraHeaders);
  }

  Future<http.Response> get(
      String path,
      {Map<String, dynamic>? params,
      Map<String, String>? extraHeaders}
  ) async {
   return _enqueueCall(path, Methods.GET, params: params, extraHeaders: extraHeaders);
  }

  Future<http.Response> delete(
      String path,
      {Map<String, dynamic>? params,
      Map<String, String>? extraHeaders}
  ) async {
    return _enqueueCall(path, Methods.DELETE, params: params, extraHeaders: extraHeaders,);
  }

  Uri _bondlyUri(String path, {Map<String, dynamic>? params}) {
    Uri baseUri = Uri.parse(Environment.baseUrl);
    String basePath = baseUri.path;
    return Uri.parse(Environment.baseUrl).replace(
      path: _bookendSlash(basePath + path),
      queryParameters: params,
    );
  }

  Future<http.Response> _enqueueCall(
      String path,
      Methods method,
      {Map<String, dynamic>? params,
      Map<String, String>? extraHeaders}
  ) async {
    Uri uri = _bondlyUri(path);

    String payload = "";
    if (params != null) {
      payload = jsonEncode(params);
    }

    if (extraHeaders != null) {
      extraHeaders.addAll(baseHeaders);
    } else {
      extraHeaders = baseHeaders;
    }

    try {
      /// Log this request to LogEntries
      logRequest(uri.toString(), method.toString(), params?.toString());

      http.Response response;
      switch (method) {
        case Methods.POST:
          response = await _client.post(uri, body: payload, headers: extraHeaders);
        case Methods.GET:
          response = await _client.get(uri, headers: extraHeaders);
        case Methods.DELETE:
          response = await _client.delete(uri, body: payload, headers: extraHeaders);
        case Methods.PUT:
          response = await _client.put(uri, body: payload, headers: extraHeaders);
      }
      throwOnFailureCode(response);
      return response;
    } on http.ClientException catch (e) {
      throw SocketException("ClientException has occurred: $e");
    } on IOException catch (e) {
      throw SocketException("IOException has occurred: $e");
    }
  }
}
