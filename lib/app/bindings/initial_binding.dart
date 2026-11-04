import 'package:get/get.dart';
import 'package:demo_access_refresh_token_app/core/network/api_client.dart';
import 'package:demo_access_refresh_token_app/data/providers/auth_provider.dart';
import 'package:demo_access_refresh_token_app/data/providers/employee_provider.dart';
import 'package:demo_access_refresh_token_app/data/providers/product_provider.dart';
import 'package:demo_access_refresh_token_app/data/repositories/auth_repository.dart';
import 'package:demo_access_refresh_token_app/data/repositories/employee_repository.dart';
import 'package:demo_access_refresh_token_app/data/repositories/product_repository.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Core Network
    final apiClient = ApiClient();
    Get.put<ApiClient>(apiClient, permanent: true);

    // Providers
    final authProvider = AuthProvider(apiClient: apiClient);
    final productProvider = ProductProvider(apiClient: apiClient);
    final employeeProvider = EmployeeProvider(apiClient: apiClient);

    Get.put<AuthProvider>(authProvider, permanent: true);
    Get.put<ProductProvider>(productProvider, permanent: true);
    Get.put<EmployeeProvider>(employeeProvider, permanent: true);

    // Repositories (Repository Pattern)
    Get.put<IAuthRepository>(
      AuthRepositoryImpl(provider: authProvider),
      permanent: true,
    );
    Get.put<IProductRepository>(
      ProductRepositoryImpl(provider: productProvider),
      permanent: true,
    );
    Get.put<IEmployeeRepository>(
      EmployeeRepositoryImpl(provider: employeeProvider),
      permanent: true,
    );
  }
}

