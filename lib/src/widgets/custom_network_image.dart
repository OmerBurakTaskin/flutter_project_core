import 'package:flutter/material.dart';
import 'package:flutter_project_core/axii_core.dart';

class CustomNetworkImage extends StatelessWidget {
  const CustomNetworkImage(
      {super.key,
      required this.imageURL,
      this.placeholderColor,
      this.width,
      this.height,
      this.borderRadius = 0,
      this.boxfit});
  final String imageURL;
  final Color? placeholderColor;
  final double? width;
  final double? height;
  final double borderRadius;
  final BoxFit? boxfit;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.network(
        width: width,
        height: height,
        imageURL,
        loadingBuilder: (context, child, loadingProgress) =>
            loadingProgress == null
                ? child
                : ShimmerWrapper(
                    isLoading: true,
                    height: height ?? 48,
                    width: width ?? 48,
                    color: context.colorScheme.outline.withAlpha(120),
                    builder: () => SizedBox(width: width, height: height),
                  ),
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
        fit: boxfit ?? BoxFit.cover,
      ),
    );
  }
}
