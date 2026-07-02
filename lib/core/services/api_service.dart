import 'package:demo_access_refresh_token_app/models/login/LoginRequest.dart';

abstract class ApiService{
  Future<dynamic> login({LoginRequest? body});
}