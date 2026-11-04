import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_access_refresh_token_app/core/exceptions/app_exception.dart';
import 'package:demo_access_refresh_token_app/data/models/product/product_model.dart';
import 'package:demo_access_refresh_token_app/data/repositories/product_repository.dart';

class ProductController extends GetxController {
  final IProductRepository _productRepository = Get.find<IProductRepository>();

  final products = <ProductModel>[].obs;
  final filteredProducts = <ProductModel>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  final searchController = TextEditingController();
  final searchQuery = ''.obs;
  final selectedFilter = 'ALL'.obs; // ALL, IN_STOCK, OUT_OF_STOCK

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> loadProducts({bool showLoading = true}) async {
    if (showLoading) {
      isLoading.value = true;
    }
    errorMessage.value = '';

    try {
      final list = await _productRepository.getProducts(status: 'ALL');
      products.assignAll(list);
      _applyFilter();
    } on AppException catch (e) {
      errorMessage.value = e.message;
    } catch (e) {
      errorMessage.value = 'Failed to load products: ${e.toString()}';
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

  void setFilter(String filter) {
    selectedFilter.value = filter;
    _applyFilter();
  }

  void _applyFilter() {
    var result = List<ProductModel>.from(products);

    // Apply stock filter
    if (selectedFilter.value == 'IN_STOCK') {
      result = result.where((p) => p.isInStock).toList();
    } else if (selectedFilter.value == 'OUT_OF_STOCK') {
      result = result.where((p) => !p.isInStock).toList();
    }

    // Apply text search
    if (searchQuery.value.trim().isNotEmpty) {
      final q = searchQuery.value.toLowerCase().trim();
      result = result.where((p) {
        final nameMatch = p.name.toLowerCase().contains(q);
        final codeMatch = p.productCode?.toLowerCase().contains(q) ?? false;
        final catMatch = p.categoryName.toLowerCase().contains(q);
        final descMatch = p.description?.toLowerCase().contains(q) ?? false;
        return nameMatch || codeMatch || catMatch || descMatch;
      }).toList();
    }

    filteredProducts.assignAll(result);
  }
}

