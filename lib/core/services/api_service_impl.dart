import 'dart:convert';

import 'package:demo_access_refresh_token_app/constants/constant_uri.dart';
import 'package:demo_access_refresh_token_app/core/services/api_service.dart';
import 'package:demo_access_refresh_token_app/models/login/LoginRequest.dart';
import 'package:demo_access_refresh_token_app/models/login/LoginResponse.dart';
import 'package:http/http.dart' as httpClient;

class ApiServiceImpl extends ApiService {
  @override
  Future<LoginResponse> login({LoginRequest? body}) async {
    var url = Uri.parse(ConstantUri.login);
    try {
      var response = await httpClient.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body!.toJson()),
      );
      print("Login Status Code: ${response.statusCode}");
      print("Login Response Body: ${response.body}");
      if (response.statusCode == 200) {
        var loginResponse = LoginResponse.fromJson(jsonDecode(response.body));
        return loginResponse;
      }
    } catch (e) {
      print("Login Exception: $e");
    }
    return LoginResponse();
  }
}
