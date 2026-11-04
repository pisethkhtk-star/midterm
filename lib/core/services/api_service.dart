import 'package:get/get.dart';
import 'package:demo_access_refresh_token_app/data/models/auth/login_request.dart';
import 'package:demo_access_refresh_token_app/data/models/auth/login_response.dart';
import 'package:demo_access_refresh_token_app/data/repositories/auth_repository.dart';

abstract class ApiService {
  Future<LoginResponse> login({LoginRequest? body});
}

class ApiServiceImpl extends ApiService {
  @override
  Future<LoginResponse> login({LoginRequest? body}) async {
    if (body == null) return LoginResponse();
    final repo = Get.find<IAuthRepository>();
    return await repo.login(body);
  }
}
