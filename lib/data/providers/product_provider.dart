import 'package:demo_access_refresh_token_app/core/constants/api_endpoints.dart';
import 'package:demo_access_refresh_token_app/core/network/api_client.dart';
import 'package:demo_access_refresh_token_app/data/models/product/product_model.dart';

class ProductProvider {
  final ApiClient _apiClient;

  ProductProvider({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<List<ProductModel>> getProducts({String status = 'ALL'}) async {
    final response = await _apiClient.post(
      ApiEndpoints.productList,
      body: {'status': status},
      requireAuth: true,
    );

    List items = [];
    if (response is Map && response['data'] != null) {
      if (response['data'] is List) {
        items = response['data'];
      }
    } else if (response is List) {
      items = response;
    }

    return items.map((item) => ProductModel.fromJson(item)).toList();
  }

  Future<ProductModel?> getProductById(int id) async {
    final response = await _apiClient.post(
      ApiEndpoints.productById(id),
      body: {'status': 'ACT'},
      requireAuth: true,
    );

    if (response is Map && response['data'] != null) {
      return ProductModel.fromJson(response['data']);
    }
    return null;
  }

  Future<bool> createProduct(ProductModel product) async {
    final response = await _apiClient.post(
      ApiEndpoints.productCreate,
      body: product.toJson(),
      requireAuth: true,
    );
    return response != null;
  }

  Future<bool> updateProduct(ProductModel product) async {
    final response = await _apiClient.post(
      ApiEndpoints.productUpdate,
      body: product.toJson(),
      requireAuth: true,
    );
    return response != null;
  }

  Future<bool> deleteProduct(int id) async {
    final response = await _apiClient.post(
      ApiEndpoints.productDelete,
      body: {'id': id},
      requireAuth: true,
    );
    return response != null;
  }
}

