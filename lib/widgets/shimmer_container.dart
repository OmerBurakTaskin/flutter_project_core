import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWrapper extends StatelessWidget {
  const ShimmerWrapper({
    super.key,
    required this.isLoading,
    required this.builder,
    this.height = 120,
    this.width = 120,
    this.color = Colors.grey,
    this.borderRadius = 16,
    this.customShimmer,
  });
  final double width;
  final double height;
  final Color color;
  final double borderRadius;
  final bool isLoading;
  final Widget Function() builder;
  final List<Widget>? customShimmer;
  @override
  Widget build(BuildContext context) {
    return !isLoading
        ? builder()
        : customShimmer != null
            ? SizedBox(
                width: width,
                height: height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: customShimmer!
                      .map(
                        (s) => Shimmer.fromColors(
                          baseColor: color,
                          highlightColor: color.withAlpha(100),
                          child: s,
                        ),
                      )
                      .toList(),
                ),
              )
            : Shimmer.fromColors(
                baseColor: color,
                highlightColor: color.withAlpha(100),
                child: Container(
                  height: height,
                  width: width,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                ),
              );
  }
}
