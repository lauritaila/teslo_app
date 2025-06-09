import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/config/constant/enviroment.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/shared/shared.dart';
import '../provider.dart';

final productFormProvider = StateNotifierProvider.autoDispose.family<ProductFormNotifier, ProductFormState, Product>((ref, product) {
  // final createUpdatedCallback = ref.watch(productsRepositoryProvider).createUpdateProducts;
  final createUpdatedCallback = ref.watch(productsProvider.notifier).createUpdateProduct;
  return ProductFormNotifier(product: product, onSubmitCallback: createUpdatedCallback);
});

class ProductFormNotifier extends StateNotifier<ProductFormState> {
  final Future<bool> Function(Map<String, dynamic> productLike)? onSubmitCallback;

  ProductFormNotifier({this.onSubmitCallback, required Product product}) : super(ProductFormState(
    id: product.id,
    title: Title.dirty(product.title),
    slug: Slug.dirty(product.slug),
    inStock: Stock.dirty(product.stock),
    price: Price.dirty(product.price),
    images: product.images,
    sizes: product.sizes,
    description: product.description,
    tags: product.tags.join(', '),
    gender: product.gender
  ));

  void onTitleChanged(String value) => state = state.copyWith(title: Title.dirty(value), isFormValid: 
  Formz.validate([Title.dirty(value), Slug.dirty(state.slug.value), Price.dirty(state.price.value), Stock.dirty(state.inStock.value)])); 
  
  void onSlugChanged(String value) => state = state.copyWith(slug: Slug.dirty(value), isFormValid: 
  Formz.validate([Title.dirty(state.title.value), Slug.dirty(value), Price.dirty(state.price.value), Stock.dirty(state.inStock.value)]));
  
  void onPriceChanged(double value) => state = state.copyWith(price: Price.dirty(value), isFormValid: 
  Formz.validate([Title.dirty(state.title.value), Slug.dirty(state.slug.value), Price.dirty(value), Stock.dirty(state.inStock.value)]));
  
  void onStockChanged(int value) => state = state.copyWith(inStock: Stock.dirty(value), isFormValid: 
  Formz.validate([Title.dirty(state.title.value), Slug.dirty(state.slug.value), Price.dirty(state.price.value), Stock.dirty(value)]));
  
  void onSizeChanged(List<String> sizes) => state = state.copyWith(sizes: sizes);
  
  void onGenderChanged(String gender) => state = state.copyWith(gender: gender);
  
  void onDescriptionChanged(String description) => state = state.copyWith(description: description);
  
  void onTagsChanged(String tags) => state = state.copyWith(tags: tags);

  void _touchedEveryField() => state = state.copyWith(isFormValid: 
  Formz.validate([Title.dirty(state.title.value), Slug.dirty(state.slug.value), Price.dirty(state.price.value), Stock.dirty(state.inStock.value)]));
  
  Future<bool> onFormSubmit() async {
    _touchedEveryField();
    if (!state.isFormValid) return false;
    if (onSubmitCallback == null) return false;
    final productLike = {
      'id': state.id,
      'title': state.title.value,
      'slug': state.slug.value,
      'price': state.price.value,
      'stock': state.inStock.value,
      'sizes': state.sizes,
      'gender': state.gender,
      'description': state.description,
      'tags': state.tags.split(', '),
      'images': state.images.map((image) => image.replaceAll('${Enviroment.apiUrl}files/product/', '')).toList()
    };
    try {
      return await onSubmitCallback!(productLike);      
    } catch (e) {
      return false;
    }
  }
}

class ProductFormState {
  final bool isFormValid;
  final String? id;
  final Title title;
  final Slug slug;
  final Price price;
  final List<String> sizes;
  final String gender;
  final Stock inStock;
  final String description;
  final String tags;
  final List<String> images;

  ProductFormState(
      {this.isFormValid = false,
      this.id,
      this.title = const Title.dirty(''),
      this.slug = const Slug.dirty(''),
      this.inStock = const Stock.dirty(0),
      this.price = const Price.dirty(0),
      this.images = const [],
      this.sizes = const [],
      this.description = '',
      this.tags = '',
      this.gender = 'men'});

  ProductFormState copyWith({
    bool? isFormValid,
    String? id,
    Title? title,
    Slug? slug,
    Stock? inStock,
    Price? price,
    List<String>? images,
    List<String>? sizes,
    String? description,
    String? tags,
    String? gender,
  }) =>
      ProductFormState(
          isFormValid: isFormValid ?? this.isFormValid,
          id: id ?? this.id,
          title: title ?? this.title,
          slug: slug ?? this.slug,
          inStock: inStock ?? this.inStock,
          price: price ?? this.price,
          images: images ?? this.images,
          sizes: sizes ?? this.sizes,
          description: description ?? this.description,
          tags: tags ?? this.tags,
          gender: gender ?? this.gender);
}
