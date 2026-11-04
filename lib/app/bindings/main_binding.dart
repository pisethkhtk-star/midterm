import 'package:get/get.dart';
import 'package:demo_access_refresh_token_app/modules/main/main_controller.dart';
import 'package:demo_access_refresh_token_app/modules/products/product_controller.dart';
import 'package:demo_access_refresh_token_app/modules/employees/employee_controller.dart';
import 'package:demo_access_refresh_token_app/modules/profile/profile_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(() => MainController());
    Get.lazyPut<ProductController>(() => ProductController());
    Get.lazyPut<EmployeeController>(() => EmployeeController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}

