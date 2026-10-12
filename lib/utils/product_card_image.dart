import 'package:flutter/material.dart';

/// Round product image for grid cards. Place it in an `Expanded` above the
/// card's text: it takes whatever height the text leaves, as a circle up to
/// [maxSize], so cards never overflow on small widths and grow on tablets.
class ProductCardImage extends StatelessWidget {
  final String? imageUrl;
  final Object? heroTag;
  final BoxFit fit;
  final double maxSize;

  const ProductCardImage({
    super.key,
    required this.imageUrl,
    this.heroTag,
    this.fit = BoxFit.cover,
    this.maxSize = 170,
  });

  @override
  Widget build(BuildContext context) {
    final Widget image = imageUrl != null && imageUrl!.isNotEmpty
        ? Image.network(imageUrl!, fit: fit)
        : Image.asset("assets/images/default_image.jpg", fit: BoxFit.cover);

    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 4),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxSize, maxHeight: maxSize),
          child: AspectRatio(
            aspectRatio: 1,
            child: ClipOval(
              child: heroTag != null && imageUrl != null && imageUrl!.isNotEmpty
                  ? Hero(tag: heroTag!, child: image)
                  : image,
            ),
          ),
        ),
      ),
    );
  }
}
