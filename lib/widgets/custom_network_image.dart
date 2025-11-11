import 'package:flutter/material.dart';
import 'package:flutter_project_core/core/extensions/context_extensions.dart';
import 'package:flutter_project_core/widgets/shimmer_container.dart';

class CustomNetworkImage extends StatelessWidget {
  const CustomNetworkImage({
    super.key,
    required this.imageURL,
    this.placeholderColor,
    this.width,
    this.height,
  });
  final String imageURL;
  final Color? placeholderColor;
  final double? width;
  final double? height;
  @override
  Widget build(BuildContext context) {
    return Image.network(
      width: width,
      height: height,
      imageURL,
      loadingBuilder: (context, child, loadingProgress) =>
          loadingProgress == null
          ? child
          : ShimmerWrapper(isLoading: true, builder: () => SizedBox()),
      errorBuilder: (context, error, stackTrace) => Container(
        width: width ?? double.infinity,
        height: height ?? 200,
        color: placeholderColor ?? context.colorScheme.outline.withAlpha(20),
        child: Icon(
          Icons.image_not_supported_outlined,
          size: 48,
          color: placeholderColor ?? context.colorScheme.outline,
        ),
      ),
      fit: BoxFit.cover,
    );
  }
}
