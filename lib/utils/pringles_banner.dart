import 'package:flutter/material.dart';

/// Store-branded banner for the home carousel.
///
/// The carousel is a fixed 200pt tall, so a single image gets cropped badly on
/// one device class: phones show it at ~2:1, iPads at ~5:1. Each banner is
/// bundled as two renders of the same design and picked by aspect ratio.
/// Source and render script: design/home_banner/.
class PringlesBanner extends StatelessWidget {
  final String phoneAsset;
  final String tabletAsset;
  final VoidCallback? onTap;

  const PringlesBanner({
    super.key,
    required this.phoneAsset,
    required this.tabletAsset,
    this.onTap,
  });

  /// "Every Bottle. Every Brand." – design/home_banner/banner.html
  const PringlesBanner.everyBrand({super.key, this.onTap})
      : phoneAsset = 'assets/images/home_banner_pringles_phone.jpg',
        tabletAsset = 'assets/images/home_banner_pringles_tablet.jpg';

  /// "Raise a Glass. Save More." – design/home_banner/banner_deals.html
  const PringlesBanner.deals({super.key, this.onTap})
      : phoneAsset = 'assets/images/home_banner_deals_phone.jpg',
        tabletAsset = 'assets/images/home_banner_deals_tablet.jpg';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: LayoutBuilder(builder: (context, constraints) {
        final wide = constraints.maxWidth / constraints.maxHeight > 3;
        return Image.asset(
          wide ? tabletAsset : phoneAsset,
          width: double.infinity,
          height: constraints.maxHeight,
          fit: BoxFit.cover,
        );
      }),
    );
  }
}
