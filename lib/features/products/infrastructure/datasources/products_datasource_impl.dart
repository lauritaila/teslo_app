import 'package:dio/dio.dart';
import 'package:teslo_shop/config/config.dart';
import '../mappers/product_mapper.dart';

import '../../domain/domain.dart';

class ProductsDatasourceImpl extends ProductsDatasource{

  late final Dio dio;
  final String accessToken;

  ProductsDatasourceImpl({required this.accessToken}) : dio = 
  Dio(BaseOptions(baseUrl: Enviroment.apiUrl, headers: {"Authorization": "Bearer $accessToken"}));

  @override
  Future<Product> createUpdateProducts(Map<String, dynamic> productLike) {
    // TODO: implement createUpdateProducts
    throw UnimplementedError();
  }

  @override
  Future<Product> getProductById(String id) {
    // TODO: implement getProductById
    throw UnimplementedError();
  }

  @override
  Future<List<Product>> getProductsByPage({int limit = 10, int offset = 0}) async {
    final response = await dio.get<List>('/products?limit=$limit&offset=$offset');
    final List<Product> products =  [];
    for (final item in response.data ?? []) {
      products.add(ProductMapper.jsonToEntity(item));
    }
    return products;
  }

  @override
  Future<List<Product>> getSuggestionsByQuery(String query) {
    // TODO: implement getSuggestionsByQuery
    throw UnimplementedError();
  }

}