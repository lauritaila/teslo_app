import 'package:flutter/material.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // Image
      _ImageViewer(images: product.images),
      Text(product.title, textAlign: TextAlign.center),
      const SizedBox(height: 10),
      // Text(product.inStock > 0 ? 'En stock' : 'No hay stock')
    ]);
  }
}

class _ImageViewer extends StatelessWidget {
  final List<String> images;
  const _ImageViewer({required this.images});

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset('assets/images/no-image.jpg',
              height: 250, fit: BoxFit.cover));
    }

    return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: FadeInImage(
            fit: BoxFit.cover,
            fadeOutDuration: const Duration(milliseconds: 100),
            fadeInDuration: const Duration(milliseconds: 200),
            height: 250,
            image: NetworkImage(images.first),
            placeholder: const AssetImage('assets/loaders/bottle-loader.gif')));
  }
}
