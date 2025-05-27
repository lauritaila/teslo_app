import 'package:teslo_shop/features/products/domain/entities/product.dart';

abstract class ProductsDatasource {
  Future<List<Product>> getProductsByPage({int limit = 10, int offset = 0});
  Future<Product> getProductById(String id);
  Future<List<Product>> getSuggestionsByQuery(String query);
  Future<Product> createUpdateProducts(Map<String, dynamic> productLike);
} 