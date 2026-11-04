import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_access_refresh_token_app/app/routes/app_routes.dart';
import 'package:demo_access_refresh_token_app/core/constants/app_colors.dart';
import 'package:demo_access_refresh_token_app/core/exceptions/app_exception.dart';
import 'package:demo_access_refresh_token_app/data/models/employee/employee_model.dart';
import 'package:demo_access_refresh_token_app/data/models/employee/employee_request.dart';
import 'package:demo_access_refresh_token_app/data/repositories/employee_repository.dart';
import 'package:demo_access_refresh_token_app/widgets/confirm_dialog.dart';

class EmployeeController extends GetxController {
  final IEmployeeRepository _employeeRepository = Get.find<IEmployeeRepository>();

  final employees = <EmployeeModel>[].obs;
  final filteredEmployees = <EmployeeModel>[].obs;
  final isLoading = false.obs;
  final isActionLoading = false.obs;
  final errorMessage = ''.obs;

  final searchController = TextEditingController();
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadEmployees();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> loadEmployees({bool showLoading = true}) async {
    if (showLoading) {
      isLoading.value = true;
    }
    errorMessage.value = '';

    try {
      final list = await _employeeRepository.getEmployees(status: 'ALL');
      employees.assignAll(list);
      _applyFilter();
    } on AppException catch (e) {
      errorMessage.value = e.message;
    } catch (e) {
      errorMessage.value = 'Failed to load employees: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    _applyFilter();
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    _applyFilter();
  }

  void _applyFilter() {
    if (searchQuery.value.trim().isEmpty) {
      filteredEmployees.assignAll(employees);
      return;
    }

    final q = searchQuery.value.toLowerCase().trim();
    final result = employees.where((emp) {
      final nameMatch = emp.fullName.toLowerCase().contains(q);
      final userMatch = emp.username.toLowerCase().contains(q);
      final emailMatch = emp.email.toLowerCase().contains(q);
      final phoneMatch = emp.phoneNumber.toLowerCase().contains(q);
      final roleMatch = emp.role.toLowerCase().contains(q);
      return nameMatch || userMatch || emailMatch || phoneMatch || roleMatch;
    }).toList();

    filteredEmployees.assignAll(result);
  }

  void goToAddEmployee() {
    Get.toNamed(AppRoutes.EMPLOYEE_FORM)?.then((_) => loadEmployees(showLoading: false));
  }

  void goToEditEmployee(EmployeeModel employee) {
    Get.toNamed(AppRoutes.EMPLOYEE_FORM, arguments: employee)
        ?.then((_) => loadEmployees(showLoading: false));
  }

  Future<void> deleteEmployeeWithConfirm(EmployeeModel employee) async {
    if (employee.id == null) return;

    await ConfirmDialog.show(
      title: 'Delete Employee',
      message: 'Are you sure you want to delete ${employee.fullName}? This action will deactivate their access.',
      confirmText: 'Delete',
      cancelText: 'Cancel',
      isDestructive: true,
      onConfirm: () async {
        await _executeDelete(employee);
      },
    );
  }

  Future<void> _executeDelete(EmployeeModel employee) async {
    isActionLoading.value = true;
    try {
      final success = await _employeeRepository.deleteEmployee(employee.id!);
      if (success) {
        employees.removeWhere((e) => e.id == employee.id);
        _applyFilter();

        Get.snackbar(
          'Deleted',
          'Employee ${employee.fullName} removed successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.success,
          colorText: Colors.white,
          icon: const Icon(Icons.check_circle_rounded, color: Colors.white),
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      }
    } on AppException catch (e) {
      Get.snackbar(
        'Delete Failed',
        e.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.danger,
        colorText: Colors.white,
        icon: const Icon(Icons.error_outline_rounded, color: Colors.white),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not delete employee: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.danger,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } finally {
      isActionLoading.value = false;
    }
  }

  Future<bool> saveEmployee({
    required EmployeeRequest request,
    required bool isEdit,
  }) async {
    isActionLoading.value = true;
    try {
      bool success = false;
      if (isEdit) {
        success = await _employeeRepository.updateEmployee(request);
      } else {
        success = await _employeeRepository.createEmployee(request);
      }

      if (success) {
        Get.snackbar(
          'Success',
          isEdit ? 'Employee updated successfully' : 'New employee created successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColors.success,
          colorText: Colors.white,
          icon: const Icon(Icons.check_circle_rounded, color: Colors.white),
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
        await loadEmployees(showLoading: false);
        return true;
      }
      return false;
    } on AppException catch (e) {
      Get.snackbar(
        'Validation / Error',
        e.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.danger,
        colorText: Colors.white,
        icon: const Icon(Icons.warning_amber_rounded, color: Colors.white),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return false;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Operation failed: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.danger,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return false;
    } finally {
      isActionLoading.value = false;
    }
  }
}

