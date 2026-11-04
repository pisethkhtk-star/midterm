// ignore_for_file: constant_identifier_names

import 'package:get/get.dart';
import 'package:demo_access_refresh_token_app/app/bindings/employee_binding.dart';
import 'package:demo_access_refresh_token_app/app/bindings/login_binding.dart';
import 'package:demo_access_refresh_token_app/app/bindings/main_binding.dart';
import 'package:demo_access_refresh_token_app/app/routes/app_routes.dart';
import 'package:demo_access_refresh_token_app/modules/employees/employee_form_view.dart';
import 'package:demo_access_refresh_token_app/modules/login/login_view.dart';
import 'package:demo_access_refresh_token_app/modules/main/main_view.dart';
import 'package:demo_access_refresh_token_app/modules/splash/splash_view.dart';

class AppPages {
  static const INITIAL = AppRoutes.SPLASH;

  static final routes = [
    GetPage(
      name: AppRoutes.SPLASH,
      page: () => const SplashView(),
    ),
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.MAIN,
      page: () => const MainView(),
      binding: MainBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.EMPLOYEE_FORM,
      page: () => const EmployeeFormView(),
      binding: EmployeeBinding(),
      transition: Transition.rightToLeft,
    ),
  ];
}

