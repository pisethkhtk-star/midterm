import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:demo_access_refresh_token_app/core/storage/token_storage.dart';

class ApiEndpoints {
  // Default fallback URLs based on platform
  static String get defaultBaseUrl {
    if (kIsWeb) {
      return 'http://localhost:30033';
    }
    try {
      if (Platform.isAndroid) {
        return 'http://10.0.2.2:30033';
      } else if (Platform.isIOS || Platform.isMacOS || Platform.isWindows) {
        return 'http://localhost:30033';
      }
    } catch (_) {}
    return 'http://10.10.0.180:30033';
  }

  // Active base URL from storage or default
  static String get baseUrl {
    return TokenStorage.getBaseUrl() ?? defaultBaseUrl;
  }

  // Auth endpoints
  static String get login => '$baseUrl/api/oauth/token';
  static String get logout => '$baseUrl/api/oauth/logout';
  static String get refreshToken => '$baseUrl/api/oauth/refresh';

  // Product endpoints
  static String get productList => '$baseUrl/api/app/product/list';
  static String get productCreate => '$baseUrl/api/app/product/create';
  static String get productUpdate => '$baseUrl/api/app/product/update';
  static String get productDelete => '$baseUrl/api/app/product/delete';
  static String get productCategories => '$baseUrl/api/app/product/category/list';
  static String productById(int id) => '$baseUrl/api/app/product/$id';

  // Employee (Admin User Management) endpoints
  static String get employeeList => '$baseUrl/api/app/admin/user/list';
  static String get employeeCreate => '$baseUrl/api/app/admin/user/create';
  static String get employeeUpdate => '$baseUrl/api/app/admin/user/update';
  static String get employeeDelete => '$baseUrl/api/app/admin/user/delete';
  static String employeeById(int id) => '$baseUrl/api/app/admin/user/$id';
}

