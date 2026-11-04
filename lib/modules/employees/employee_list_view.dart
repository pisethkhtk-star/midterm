import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_access_refresh_token_app/core/constants/app_colors.dart';
import 'package:demo_access_refresh_token_app/modules/employees/employee_controller.dart';
import 'package:demo_access_refresh_token_app/modules/employees/widgets/employee_card.dart';
import 'package:demo_access_refresh_token_app/widgets/empty_state_view.dart';
import 'package:demo_access_refresh_token_app/widgets/error_state_view.dart';

class EmployeeListView extends GetView<EmployeeController> {
  const EmployeeListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: controller.goToAddEmployee,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.person_add_rounded),
        label: const Text(
          'Add Employee',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(
        children: [
          // Search & Action Header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: TextField(
              controller: controller.searchController,
              onChanged: controller.onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search by name, username, email, phone...',
                hintStyle: const TextStyle(fontSize: 14, color: AppColors.textMuted),
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textSecondary),
                suffixIcon: Obx(() => controller.searchQuery.value.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18),
                        onPressed: controller.clearSearch,
                      )
                    : const SizedBox.shrink()),
                filled: true,
                fillColor: AppColors.background,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                ),
              ),
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),

          // Content Area
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: AppColors.primary),
                      SizedBox(height: 16),
                      Text(
                        'Loading employees from REST API...',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                      ),
                    ],
                  ),
                );
              }

              if (controller.errorMessage.value.isNotEmpty) {
                return ErrorStateView(
                  message: controller.errorMessage.value,
                  onRetry: () => controller.loadEmployees(),
                );
              }

              if (controller.filteredEmployees.isEmpty) {
                return RefreshIndicator(
                  onRefresh: () => controller.loadEmployees(showLoading: false),
                  color: AppColors.primary,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                      EmptyStateView(
                        title: controller.searchQuery.value.isNotEmpty
                            ? 'No Employees Found'
                            : 'No Employee Records',
                        message: controller.searchQuery.value.isNotEmpty
                            ? 'No employee matched "${controller.searchQuery.value}".'
                            : 'Get started by creating your first employee record.',
                        icon: Icons.people_outline_rounded,
                        buttonText: 'Add New Employee',
                        onButtonPressed: controller.goToAddEmployee,
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () => controller.loadEmployees(showLoading: false),
                color: AppColors.primary,
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: controller.filteredEmployees.length,
                  itemBuilder: (context, index) {
                    final employee = controller.filteredEmployees[index];
                    return EmployeeCard(
                      employee: employee,
                      onEdit: () => controller.goToEditEmployee(employee),
                      onDelete: () => controller.deleteEmployeeWithConfirm(employee),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

