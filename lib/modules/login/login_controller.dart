import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_access_refresh_token_app/app/routes/app_routes.dart';
import 'package:demo_access_refresh_token_app/core/constants/app_colors.dart';
import 'package:demo_access_refresh_token_app/core/exceptions/app_exception.dart';
import 'package:demo_access_refresh_token_app/data/models/auth/login_request.dart';
import 'package:demo_access_refresh_token_app/data/repositories/auth_repository.dart';

class LoginController extends GetxController {
  final IAuthRepository _authRepository = Get.find<IAuthRepository>();

  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;
  final isPasswordHidden = true.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Default demo placeholder helper for easy testing
    usernameController.text = 'admin';
    passwordController.text = 'Admin@1234';
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void fillDemoAdmin() {
    usernameController.text = 'admin';
    passwordController.text = 'Admin@1234';
  }

  void fillDemoPhone() {
    usernameController.text = '00000000000';
    passwordController.text = 'Admin@1234';
  }

  Future<void> onLogin() async {
    errorMessage.value = '';

    if (!formKey.currentState!.validate()) {
      return;
    }

    final username = usernameController.text.trim();
    final password = passwordController.text;

    isLoading.value = true;

    try {
      final response = await _authRepository.login(
        LoginRequest(phoneNumber: username, password: password),
      );

      if (response.isSuccess && response.accessToken != null) {
        Get.snackbar(
          'Login Successful',
          'Welcome back, ${response.user?.fullName ?? username}!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColors.success,
          colorText: Colors.white,
          icon: const Icon(Icons.check_circle_rounded, color: Colors.white),
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          duration: const Duration(seconds: 3),
        );

        Get.offAllNamed(AppRoutes.MAIN);
      } else {
        errorMessage.value = 'Login failed. Please verify your credentials.';
        Get.snackbar(
          'Authentication Failed',
          errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.danger,
          colorText: Colors.white,
          icon: const Icon(Icons.error_outline_rounded, color: Colors.white),
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      }
    } on AppException catch (e) {
      errorMessage.value = e.message;
      Get.snackbar(
        'Login Error',
        e.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.danger,
        colorText: Colors.white,
        icon: const Icon(Icons.warning_amber_rounded, color: Colors.white),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred. Please try again.';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.danger,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
