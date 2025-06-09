import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'products_repository_provider.dart';

import '../../domain/domain.dart';

final productProvider = StateNotifierProvider.autoDispose.family<ProductNotifier, ProductState, String>((ref, productId) {
  final productsRepository = ref.watch(productsRepositoryProvider);
  return ProductNotifier(productsRepository: productsRepository, productId: productId);
});

class ProductNotifier extends StateNotifier<ProductState> {
  final ProductRepository productsRepository;
  ProductNotifier({required this.productsRepository, required String productId }) : super(ProductState(id: productId)){
    loadProduct();
  }

  Product _newEmptyProduct() => Product(
    id: 'new',
    title: '',
    slug: '',
    stock: 0,
    price: 0.0,
    sizes: [],
    description: '',
    images: [],
    gender: 'men',
    tags: [], 
    user: null,
  );

  Future<void> loadProduct() async {
    try{
      if(state.id == 'new'){
        state = state.copyWith(isLoading: false, product: _newEmptyProduct());
        return; 
      }
      final product = await productsRepository.getProductById(state.id);
      state = state.copyWith(product: product, isLoading: false);
    }catch(e){
      state = state.copyWith(isLoading: false); 
      print(e);
      
    }
  }
}

class ProductState{
  final String id; 
  final Product? product;
  final bool isLoading;
  final bool isSaving;

  ProductState({required this.id, this.product, this.isLoading = true, this.isSaving = false});

  ProductState copyWith({
    String? id,
    Product? product,
    bool? isLoading,
    bool? isSaving,
  }) => ProductState(
    id: id ?? this.id,
    product: product ?? this.product,
    isLoading: isLoading ?? this.isLoading,
    isSaving: isSaving ?? this.isSaving,
  );
}

