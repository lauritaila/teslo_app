import 'package:teslo_shop/features/products/domain/domain.dart';

class ProductsRepositoryImpl implements ProductRepository {
    final ProductsDatasource datasource;

  ProductsRepositoryImpl(this.datasource);


  @override
  Future<Product> createUpdateProducts(Map<String, dynamic> productLike) {
    return datasource.createUpdateProducts(productLike);
  }

  @override
  Future<Product> getProductById(String id) {
    return datasource.getProductById(id);
  }

  @override
  Future<List<Product>> getProductsByPage({int limit = 10, int offset = 0}) {
    return datasource.getProductsByPage(limit: limit, offset: offset);
  }

  @override
  Future<List<Product>> getSuggestionsByQuery(String query) {
    return datasource.getSuggestionsByQuery(query);
  }
}