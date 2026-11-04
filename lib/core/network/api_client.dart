import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:demo_access_refresh_token_app/core/constants/app_constants.dart';
import 'package:demo_access_refresh_token_app/core/exceptions/app_exception.dart';
import 'package:demo_access_refresh_token_app/core/storage/token_storage.dart';

class ApiClient {
  final http.Client _client;

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  Map<String, String> _buildHeaders({Map<String, String>? extraHeaders, bool requireAuth = true}) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (requireAuth) {
      final token = TokenStorage.getAccessToken();
      if (token != null && token.isNotEmpty) {
        final tokenType = TokenStorage.getTokenType();
        headers['Authorization'] = '$tokenType $token';
      }
    }

    if (extraHeaders != null) {
      headers.addAll(extraHeaders);
    }
    return headers;
  }

  Future<dynamic> get(
    String url, {
    Map<String, String>? headers,
    bool requireAuth = true,
  }) async {
    try {
      final uri = Uri.parse(url);
      final finalHeaders = _buildHeaders(extraHeaders: headers, requireAuth: requireAuth);

      _logRequest('GET', uri, finalHeaders, null);

      final response = await _client
          .get(uri, headers: finalHeaders)
          .timeout(const Duration(seconds: AppConstants.connectionTimeoutSeconds));

      return _processResponse(response);
    } on SocketException {
      throw NetworkException();
    } on TimeoutException {
      throw NetworkException('Request timed out. Please check your connection.');
    } catch (e) {
      if (e is AppException) rethrow;
      throw AppException(e.toString());
    }
  }

  Future<dynamic> post(
    String url, {
    dynamic body,
    Map<String, String>? headers,
    bool requireAuth = true,
  }) async {
    try {
      final uri = Uri.parse(url);
      final finalHeaders = _buildHeaders(extraHeaders: headers, requireAuth: requireAuth);
      final encodedBody = body != null ? jsonEncode(body) : null;

      _logRequest('POST', uri, finalHeaders, encodedBody);

      final response = await _client
          .post(uri, headers: finalHeaders, body: encodedBody)
          .timeout(const Duration(seconds: AppConstants.connectionTimeoutSeconds));

      return _processResponse(response);
    } on SocketException {
      throw NetworkException();
    } on TimeoutException {
      throw NetworkException('Request timed out. Please check your connection.');
    } catch (e) {
      if (e is AppException) rethrow;
      throw AppException(e.toString());
    }
  }

  Future<dynamic> put(
    String url, {
    dynamic body,
    Map<String, String>? headers,
    bool requireAuth = true,
  }) async {
    try {
      final uri = Uri.parse(url);
      final finalHeaders = _buildHeaders(extraHeaders: headers, requireAuth: requireAuth);
      final encodedBody = body != null ? jsonEncode(body) : null;

      _logRequest('PUT', uri, finalHeaders, encodedBody);

      final response = await _client
          .put(uri, headers: finalHeaders, body: encodedBody)
          .timeout(const Duration(seconds: AppConstants.connectionTimeoutSeconds));

      return _processResponse(response);
    } on SocketException {
      throw NetworkException();
    } on TimeoutException {
      throw NetworkException('Request timed out.');
    } catch (e) {
      if (e is AppException) rethrow;
      throw AppException(e.toString());
    }
  }

  Future<dynamic> delete(
    String url, {
    dynamic body,
    Map<String, String>? headers,
    bool requireAuth = true,
  }) async {
    try {
      final uri = Uri.parse(url);
      final finalHeaders = _buildHeaders(extraHeaders: headers, requireAuth: requireAuth);
      final encodedBody = body != null ? jsonEncode(body) : null;

      _logRequest('DELETE', uri, finalHeaders, encodedBody);

      final response = await _client
          .delete(uri, headers: finalHeaders, body: encodedBody)
          .timeout(const Duration(seconds: AppConstants.connectionTimeoutSeconds));

      return _processResponse(response);
    } on SocketException {
      throw NetworkException();
    } on TimeoutException {
      throw NetworkException('Request timed out.');
    } catch (e) {
      if (e is AppException) rethrow;
      throw AppException(e.toString());
    }
  }

  dynamic _processResponse(http.Response response) {
    _logResponse(response);

    dynamic responseJson;
    try {
      responseJson = jsonDecode(utf8.decode(response.bodyBytes));
    } catch (_) {
      responseJson = response.body;
    }

    switch (response.statusCode) {
      case 200:
      case 201:
        return responseJson;
      case 400:
        final message = _extractErrorMessage(responseJson) ?? 'Invalid request';
        throw ValidationException(message);
      case 401:
        final message = _extractErrorMessage(responseJson) ?? 'Unauthorized. Please login again.';
        throw UnauthorizedException(message);
      case 403:
        final message = _extractErrorMessage(responseJson) ?? 'Access denied.';
        throw ForbiddenException(message);
      case 404:
        final message = _extractErrorMessage(responseJson) ?? 'Resource not found.';
        throw NotFoundException(message);
      case 500:
      default:
        final message = _extractErrorMessage(responseJson) ?? 'Server error (${response.statusCode})';
        throw ServerException(message);
    }
  }

  String? _extractErrorMessage(dynamic json) {
    if (json is Map) {
      if (json['message'] != null && json['message'].toString().isNotEmpty) {
        return json['message'].toString();
      }
      if (json['messageKh'] != null && json['messageKh'].toString().isNotEmpty) {
        return json['messageKh'].toString();
      }
      if (json['error'] != null) {
        return json['error'].toString();
      }
    }
    return null;
  }

  void _logRequest(String method, Uri uri, Map<String, String> headers, String? body) {
    if (kDebugMode) {
      debugPrint('--> $method $uri');
      debugPrint('Headers: $headers');
      if (body != null) debugPrint('Body: $body');
    }
  }

  void _logResponse(http.Response response) {
    if (kDebugMode) {
      debugPrint('<-- ${response.statusCode} ${response.request?.url}');
      debugPrint('Response: ${response.body}');
    }
  }
}

