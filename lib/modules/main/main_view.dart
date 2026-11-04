import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_access_refresh_token_app/core/constants/app_colors.dart';
import 'package:demo_access_refresh_token_app/modules/employees/employee_controller.dart';
import 'package:demo_access_refresh_token_app/modules/employees/employee_list_view.dart';
import 'package:demo_access_refresh_token_app/modules/main/main_controller.dart';
import 'package:demo_access_refresh_token_app/modules/products/product_controller.dart';
import 'package:demo_access_refresh_token_app/modules/products/product_list_view.dart';
import 'package:demo_access_refresh_token_app/modules/profile/profile_view.dart';
import 'package:demo_access_refresh_token_app/widgets/server_settings_dialog.dart';

class MainView extends GetView<MainController> {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const ProductListView(),
      const EmployeeListView(),
      const ProfileView(),
    ];

    final List<String> titles = [
      'Product Catalog',
      'Employee Directory',
      'My Account',
    ];

    return Obx(() {
      final activeIndex = controller.currentIndex.value;

      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          title: Text(
            titles[activeIndex],
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 20,
              color: AppColors.textPrimary,
            ),
          ),
          actions: [
            if (activeIndex == 0)
              IconButton(
                tooltip: 'Refresh Products',
                icon: const Icon(Icons.refresh_rounded, color: AppColors.textSecondary),
                onPressed: () {
                  if (Get.isRegistered<ProductController>()) {
                    Get.find<ProductController>().loadProducts();
                  }
                },
              ),
            if (activeIndex == 1)
              IconButton(
                tooltip: 'Refresh Employees',
                icon: const Icon(Icons.refresh_rounded, color: AppColors.textSecondary),
                onPressed: () {
                  if (Get.isRegistered<EmployeeController>()) {
                    Get.find<EmployeeController>().loadEmployees();
                  }
                },
              ),
            IconButton(
              tooltip: 'Server Settings',
              icon: const Icon(Icons.dns_outlined, color: AppColors.textSecondary),
              onPressed: () => ServerSettingsDialog.show(),
            ),
          ],
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: Divider(height: 1, color: AppColors.divider),
          ),
        ),
        body: IndexedStack(
          index: activeIndex,
          children: pages,
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: AppColors.border, width: 0.8)),
          ),
          child: NavigationBar(
            selectedIndex: activeIndex,
            onDestinationSelected: controller.changeTab,
            backgroundColor: Colors.white,
            indicatorColor: AppColors.infoBg,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.inventory_2_outlined),
                selectedIcon: Icon(Icons.inventory_2_rounded, color: AppColors.primary),
                label: 'Products',
              ),
              NavigationDestination(
                icon: Icon(Icons.people_alt_outlined),
                selectedIcon: Icon(Icons.people_alt_rounded, color: AppColors.primary),
                label: 'Employees',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline_rounded),
                selectedIcon: Icon(Icons.person_rounded, color: AppColors.primary),
                label: 'Account',
              ),
            ],
          ),
        ),
      );
    });
  }
}

