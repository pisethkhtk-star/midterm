import 'package:demo_access_refresh_token_app/data/models/auth/user_model.dart';

class LoginResponse {
  final String? accessToken;
  final String? refreshToken;
  final String? tokenType;
  final int? expiresIn;
  final UserModel? user;

  LoginResponse({
    this.accessToken,
    this.refreshToken,
    this.tokenType = 'Bearer',
    this.expiresIn,
    this.user,
  });

  bool get isSuccess => accessToken != null && accessToken!.isNotEmpty;

  factory LoginResponse.fromJson(dynamic json) {
    if (json == null || json is! Map) {
      return LoginResponse();
    }
    final map = Map<String, dynamic>.from(json);

    return LoginResponse(
      accessToken: map['accessToken']?.toString(),
      refreshToken: map['refreshToken']?.toString(),
      tokenType: map['tokenType']?.toString() ?? 'Bearer',
      expiresIn: map['expiresIn'] is int
          ? map['expiresIn']
          : int.tryParse(map['expiresIn']?.toString() ?? ''),
      user: map['user'] != null ? UserModel.fromJson(map['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'tokenType': tokenType,
      'expiresIn': expiresIn,
      'user': user?.toJson(),
    };
  }
}

