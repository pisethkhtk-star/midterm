import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_access_refresh_token_app/app/routes/app_routes.dart';
import 'package:demo_access_refresh_token_app/core/constants/app_colors.dart';
import 'package:demo_access_refresh_token_app/data/models/auth/user_model.dart';
import 'package:demo_access_refresh_token_app/data/repositories/auth_repository.dart';
import 'package:demo_access_refresh_token_app/widgets/confirm_dialog.dart';

class ProfileController extends GetxController {
  final IAuthRepository _authRepository = Get.find<IAuthRepository>();

  final user = Rxn<UserModel>();
  final isLoggingOut = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  void loadProfile() {
    user.value = _authRepository.getCurrentUser();
  }

  Future<void> confirmLogout() async {
    await ConfirmDialog.show(
      title: 'Sign Out',
      message: 'Are you sure you want to log out of your session?',
      confirmText: 'Sign Out',
      cancelText: 'Stay Logged In',
      isDestructive: true,
      icon: Icons.logout_rounded,
      onConfirm: () async {
        await _performLogout();
      },
    );
  }

  Future<void> _performLogout() async {
    isLoggingOut.value = true;
    try {
      await _authRepository.logout();
      Get.snackbar(
        'Logged Out',
        'You have successfully signed out.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.primary,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      Get.offAllNamed(AppRoutes.LOGIN);
    } finally {
      isLoggingOut.value = false;
    }
  }
}

