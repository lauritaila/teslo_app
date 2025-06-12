import 'package:dio/dio.dart';
import 'package:teslo_shop/config/config.dart';
import '../errors/product_errors.dart';
import '../mappers/product_mapper.dart';

import '../../domain/domain.dart';

class ProductsDatasourceImpl extends ProductsDatasource {
  late final Dio dio;
  final String accessToken;

  ProductsDatasourceImpl({required this.accessToken})
      : dio = Dio(BaseOptions(
            baseUrl: Enviroment.apiUrl,
            headers: {"Authorization": "Bearer $accessToken"}));

  Future<String> _uploadFile(String path) async {
    try {
      final fileName = path.split('/').last;
      final FormData formData = FormData.fromMap({
        'file': MultipartFile.fromFileSync(path, filename: fileName),
      });
      final response = await dio.post('/files/product', data: formData);
      return response.data['image'];
    } on DioException catch (e) {
      throw Exception(e.toString());
    } catch (e) {
      throw Exception(e.toString());
    }

  }

  Future<List<String>> _uploadImages(List<String> images) async {
    final imagesToUpload = images.where((image) => image.contains('/')).toList();
    final imagesToIgnore = images.where((image) => !image.contains('/')).toList();
    final List<Future<String>> uploadedImages = imagesToUpload.map(_uploadFile).toList();
    final newImages = await Future.wait(uploadedImages);
    return [...imagesToIgnore, ...newImages];
  }

  @override
  Future<Product> createUpdateProducts(Map<String, dynamic> productLike) async {
    try {
      final String productId = productLike['id'] ?? '';
      productLike.remove('id');
      productLike['images'] = _uploadImages(productLike['images'] );
      final response = productId.isEmpty
          ? await dio.post('/products', data: productLike)
          : await dio.patch('/products/$productId', data: productLike);

      final product = ProductMapper.jsonToEntity(response.data);
      return product;
    } on DioException catch (e) {
      throw Exception(e.toString());
    }catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<Product> getProductById(String id) async {
    try {
      final response = await dio.get('/products/$id');
      final product = ProductMapper.jsonToEntity(response.data ?? {});
      return product;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw ProductNotFound();
      }
      throw Exception(e.toString());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<Product>> getProductsByPage(
      {int limit = 10, int offset = 0}) async {
    final response =
        await dio.get<List>('/products?limit=$limit&offset=$offset');
    final List<Product> products = [];
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
