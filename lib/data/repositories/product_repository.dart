import 'package:demo_access_refresh_token_app/data/models/product/product_model.dart';
import 'package:demo_access_refresh_token_app/data/providers/product_provider.dart';

abstract class IProductRepository {
  Future<List<ProductModel>> getProducts({String status = 'ALL'});
  Future<ProductModel?> getProductById(int id);
  Future<bool> createProduct(ProductModel product);
  Future<bool> updateProduct(ProductModel product);
  Future<bool> deleteProduct(int id);
}

class ProductRepositoryImpl implements IProductRepository {
  final ProductProvider _provider;

  ProductRepositoryImpl({ProductProvider? provider}) : _provider = provider ?? ProductProvider();

  @override
  Future<List<ProductModel>> getProducts({String status = 'ALL'}) async {
    return await _provider.getProducts(status: status);
  }

  @override
  Future<ProductModel?> getProductById(int id) async {
    return await _provider.getProductById(id);
  }

  @override
  Future<bool> createProduct(ProductModel product) async {
    return await _provider.createProduct(product);
  }

  @override
  Future<bool> updateProduct(ProductModel product) async {
    return await _provider.updateProduct(product);
  }

  @override
  Future<bool> deleteProduct(int id) async {
    return await _provider.deleteProduct(id);
  }
}

