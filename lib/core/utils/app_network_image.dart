import 'package:flutter/material.dart';
import 'package:juniorflutterroadmap/core/common/helpers/helpers.dart';

class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius,
  });
  final String url;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final image = Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, _, _) => _placeholder(context),
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return SizedBox(
          width: width,
          height: height,
          child: Center(
            child: CircularProgressIndicator(color: context.colors.primary),
          ),
        );
      },
    );

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: image);
    }
    return image;
  }

  Widget _placeholder(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.spacing.spaceXl),
      decoration: BoxDecoration(
        color: context.colors.textSecondary.withValues(alpha: 0.3),
      ),
      child: Image.asset(
        context.assets.emptyImageIcon,
        width: width,
        height: height,
        fit: BoxFit.fill,
      ),
    );
  }
}
