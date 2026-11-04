import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_access_refresh_token_app/core/constants/app_colors.dart';
import 'package:demo_access_refresh_token_app/modules/products/product_controller.dart';
import 'package:demo_access_refresh_token_app/modules/products/widgets/product_card.dart';
import 'package:demo_access_refresh_token_app/modules/products/widgets/product_detail_sheet.dart';
import 'package:demo_access_refresh_token_app/widgets/empty_state_view.dart';
import 'package:demo_access_refresh_token_app/widgets/error_state_view.dart';

class ProductListView extends GetView<ProductController> {
  const ProductListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Search & Filter Header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Column(
              children: [
                // Search Input Field
                TextField(
                  controller: controller.searchController,
                  onChanged: controller.onSearchChanged,
                  decoration: InputDecoration(
                    hintText: 'Search products by name or code...',
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
                const SizedBox(height: 10),

                // Filter Chips
                Obx(() => SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip('ALL', 'All Products'),
                          const SizedBox(width: 8),
                          _buildFilterChip('IN_STOCK', 'In Stock'),
                          const SizedBox(width: 8),
                          _buildFilterChip('OUT_OF_STOCK', 'Out of Stock'),
                        ],
                      ),
                    )),
              ],
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
                        'Loading products from REST API...',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                      ),
                    ],
                  ),
                );
              }

              if (controller.errorMessage.value.isNotEmpty) {
                return ErrorStateView(
                  message: controller.errorMessage.value,
                  onRetry: () => controller.loadProducts(),
                );
              }

              if (controller.filteredProducts.isEmpty) {
                return RefreshIndicator(
                  onRefresh: () => controller.loadProducts(showLoading: false),
                  color: AppColors.primary,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                      EmptyStateView(
                        title: controller.searchQuery.value.isNotEmpty
                            ? 'No Results Found'
                            : 'No Products Available',
                        message: controller.searchQuery.value.isNotEmpty
                            ? 'No products match "${controller.searchQuery.value}". Try a different keyword.'
                            : 'Products will appear here once retrieved from the backend API.',
                        icon: Icons.inventory_2_outlined,
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () => controller.loadProducts(showLoading: false),
                color: AppColors.primary,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: controller.filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = controller.filteredProducts[index];
                    return ProductCard(
                      product: product,
                      onTap: () => ProductDetailSheet.show(product),
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

  Widget _buildFilterChip(String value, String label) {
    final isSelected = controller.selectedFilter.value == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => controller.setFilter(value),
      selectedColor: AppColors.primary,
      backgroundColor: Colors.white,
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: isSelected ? Colors.white : AppColors.textSecondary,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? AppColors.primary : AppColors.border,
        ),
      ),
    );
  }
}

