import 'package:flutter/material.dart';

class ShimmerWrapper extends StatelessWidget {
  const ShimmerWrapper(
      {super.key,
      required this.isLoading,
      required this.child,
      required this.shimmer});

  final bool isLoading;
  final Widget Function() child;
  final Widget shimmer;

  @override
  Widget build(BuildContext context) {
    return isLoading ? shimmer : child();
  }
}
