import 'package:get/get.dart';
import 'package:demo_access_refresh_token_app/app/routes/app_routes.dart';
import 'package:demo_access_refresh_token_app/core/storage/token_storage.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(milliseconds: 1200));
    final loggedIn = TokenStorage.isLoggedIn();
    if (loggedIn) {
      Get.offAllNamed(AppRoutes.MAIN);
    } else {
      Get.offAllNamed(AppRoutes.LOGIN);
    }
  }
}

