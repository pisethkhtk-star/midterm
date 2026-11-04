import 'package:demo_access_refresh_token_app/core/constants/api_endpoints.dart';
import 'package:demo_access_refresh_token_app/core/network/api_client.dart';
import 'package:demo_access_refresh_token_app/data/models/auth/login_request.dart';
import 'package:demo_access_refresh_token_app/data/models/auth/login_response.dart';

class AuthProvider {
  final ApiClient _apiClient;

  AuthProvider({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<LoginResponse> login(LoginRequest request) async {
    final response = await _apiClient.post(
      ApiEndpoints.login,
      body: request.toJson(),
      requireAuth: false,
    );
    return LoginResponse.fromJson(response);
  }

  Future<void> logout(int? userId) async {
    try {
      await _apiClient.post(
        ApiEndpoints.logout,
        body: {'userId': userId ?? 0},
        requireAuth: true,
      );
    } catch (_) {
      // Ignore network errors on logout to allow offline local cleanup
    }
  }

  Future<LoginResponse> refreshToken(String refreshToken) async {
    final response = await _apiClient.post(
      ApiEndpoints.refreshToken,
      body: {'refreshToken': refreshToken},
      requireAuth: false,
    );
    return LoginResponse.fromJson(response);
  }
}

