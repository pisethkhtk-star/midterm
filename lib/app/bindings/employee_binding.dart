import 'package:get/get.dart';
import 'package:demo_access_refresh_token_app/modules/employees/employee_controller.dart';

class EmployeeBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<EmployeeController>()) {
      Get.lazyPut<EmployeeController>(() => EmployeeController());
    }
  }
}

