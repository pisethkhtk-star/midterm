import 'package:get_storage/get_storage.dart';
import 'package:demo_access_refresh_token_app/core/constants/app_constants.dart';

class TokenStorage {
  static final GetStorage _box = GetStorage();

  static Future<void> init() async {
    await GetStorage.init();
  }

  // Tokens
  static Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
    String? tokenType,
    int? expiresIn,
  }) async {
    await _box.write(AppConstants.keyAccessToken, accessToken);
    if (refreshToken != null) {
      await _box.write(AppConstants.keyRefreshToken, refreshToken);
    }
    if (tokenType != null) {
      await _box.write(AppConstants.keyTokenType, tokenType);
    }
    if (expiresIn != null) {
      await _box.write(AppConstants.keyExpiresIn, expiresIn);
    }
    await _box.write(AppConstants.keyIsLoggedIn, true);
  }

  static String? getAccessToken() {
    return _box.read<String>(AppConstants.keyAccessToken);
  }

  static String? getRefreshToken() {
    return _box.read<String>(AppConstants.keyRefreshToken);
  }

  static String getTokenType() {
    return _box.read<String>(AppConstants.keyTokenType) ?? 'Bearer';
  }

  static bool isLoggedIn() {
    final token = getAccessToken();
    return token != null && token.isNotEmpty;
  }

  // User Profile
  static Future<void> saveUserData(Map<String, dynamic> userMap) async {
    await _box.write(AppConstants.keyUserData, userMap);
  }

  static Map<String, dynamic>? getUserData() {
    final data = _box.read(AppConstants.keyUserData);
    if (data is Map<String, dynamic>) {
      return data;
    } else if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    return null;
  }

  static int? getUserId() {
    final user = getUserData();
    if (user != null && user['id'] != null) {
      return user['id'] is int ? user['id'] : int.tryParse(user['id'].toString());
    }
    return null;
  }

  static String? getUsername() {
    final user = getUserData();
    return user?['username'] as String?;
  }

  static String? getFullName() {
    final user = getUserData();
    if (user != null) {
      final first = user['firstName'] ?? '';
      final last = user['lastName'] ?? '';
      final name = '$first $last'.trim();
      return name.isNotEmpty ? name : user['username'];
    }
    return null;
  }

  // Base URL override for testing across emulators and devices
  static Future<void> saveBaseUrl(String url) async {
    await _box.write(AppConstants.keyBaseUrl, url.trim());
  }

  static String? getBaseUrl() {
    return _box.read<String>(AppConstants.keyBaseUrl);
  }

  // Clear Session
  static Future<void> clear() async {
    final savedUrl = getBaseUrl();
    await _box.erase();
    if (savedUrl != null) {
      await _box.write(AppConstants.keyBaseUrl, savedUrl);
    }
  }
}

