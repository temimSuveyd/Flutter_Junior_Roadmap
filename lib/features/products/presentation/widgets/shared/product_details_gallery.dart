import 'package:flutter/material.dart';
import 'package:juniorflutterroadmap/core/common/helpers/helpers.dart';
import 'package:juniorflutterroadmap/core/utils/app_network_image.dart';

class ProductDetailsGallery extends StatefulWidget {
  const ProductDetailsGallery({super.key, required this.images});
  final List<String> images;

  @override
  State<ProductDetailsGallery> createState() => _ProductDetailsGalleryState();
}

class _ProductDetailsGalleryState extends State<ProductDetailsGallery> {
  final _controller = PageController();
  var _current = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return const _GalleryPlaceholder();
    }
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.images.length,
            onPageChanged: (i) => setState(() => _current = i),
            itemBuilder: (context, i) => Padding(
              padding: context.spacing.insetMd,
              child: AppNetworkImage(
                url: widget.images[i],
                borderRadius: context.radius.lg,
              ),
            ),
          ),
        ),
        if (widget.images.length > 1) ...[
          context.spacing.vGapSm,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.images.length,
              (i) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: i == _current
                      ? context.colors.primary
                      : context.colors.border,
                ),
              ),
            ),
          ),
        ],
        context.spacing.vGapMd,
      ],
    );
  }
}

class _GalleryPlaceholder extends StatelessWidget {
  const _GalleryPlaceholder();

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: context.colors.surface,
      borderRadius: context.radius.lg,
    ),
    child: Center(
      child: Icon(
        Icons.image_outlined,
        size: 48,
        color: context.colors.textSecondary,
      ),
    ),
  );
}
