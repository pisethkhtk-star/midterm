import 'package:demo_access_refresh_token_app/core/services/api_service_impl.dart';
import 'package:demo_access_refresh_token_app/models/login/LoginRequest.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  var apiService = ApiServiceImpl();
  var usernameController = TextEditingController().obs;
  var passwordController = TextEditingController().obs;
  var isLoading = false.obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  onLogin() async {
    String username = usernameController.value.text;
    String password = passwordController.value.text;
    if (username.isEmpty) {
      Get.snackbar("Error", "Username is required");
      return;
    }
    if (password.isEmpty) {
      Get.snackbar("Error", "Password is required");
      return;
    }
    isLoading.value = true;
    var loginResponse = await apiService.login(
      body: LoginRequest(phoneNumber: username, password: password),
    );
    if (loginResponse.accessToken != null) {
      Get.snackbar("Success", "Login Successfully");
    } else {
      Get.snackbar("Error", "Login Fail");
    }
    isLoading.value = false;
  }
}
