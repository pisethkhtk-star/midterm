import 'package:demo_access_refresh_token_app/core/storage/token_storage.dart';
import 'package:demo_access_refresh_token_app/data/models/auth/login_request.dart';
import 'package:demo_access_refresh_token_app/data/models/auth/login_response.dart';
import 'package:demo_access_refresh_token_app/data/models/auth/user_model.dart';
import 'package:demo_access_refresh_token_app/data/providers/auth_provider.dart';

abstract class IAuthRepository {
  Future<LoginResponse> login(LoginRequest request);
  Future<void> logout();
  Future<bool> refreshToken();
  bool isLoggedIn();
  UserModel? getCurrentUser();
}

class AuthRepositoryImpl implements IAuthRepository {
  final AuthProvider _provider;

  AuthRepositoryImpl({AuthProvider? provider}) : _provider = provider ?? AuthProvider();

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    final response = await _provider.login(request);
    if (response.isSuccess && response.accessToken != null) {
      await TokenStorage.saveTokens(
        accessToken: response.accessToken!,
        refreshToken: response.refreshToken,
        tokenType: response.tokenType,
        expiresIn: response.expiresIn,
      );
      if (response.user != null) {
        await TokenStorage.saveUserData(response.user!.toJson());
      }
    }
    return response;
  }

  @override
  Future<void> logout() async {
    final userId = TokenStorage.getUserId();
    await _provider.logout(userId);
    await TokenStorage.clear();
  }

  @override
  Future<bool> refreshToken() async {
    final token = TokenStorage.getRefreshToken();
    if (token == null || token.isEmpty) return false;

    try {
      final response = await _provider.refreshToken(token);
      if (response.isSuccess && response.accessToken != null) {
        await TokenStorage.saveTokens(
          accessToken: response.accessToken!,
          refreshToken: response.refreshToken ?? token,
          tokenType: response.tokenType,
          expiresIn: response.expiresIn,
        );
        return true;
      }
    } catch (_) {}
    return false;
  }

  @override
  bool isLoggedIn() {
    return TokenStorage.isLoggedIn();
  }

  @override
  UserModel? getCurrentUser() {
    final data = TokenStorage.getUserData();
    if (data != null) {
      return UserModel.fromJson(data);
    }
    return null;
  }
}

