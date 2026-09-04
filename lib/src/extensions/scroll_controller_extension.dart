import 'package:flutter/material.dart';

class PaginatedScrollController extends ScrollController {
  final VoidCallback onEndReached;
  final double threshold;

  PaginatedScrollController({
    required this.onEndReached,
    this.threshold = 200,
    super.initialScrollOffset,
    super.keepScrollOffset,
    super.debugLabel,
  }) {
    addListener(_scrollListener);
  }

  void _scrollListener() {
    if (!hasClients) return;

    final position = this.position;

    if (position.pixels >= position.maxScrollExtent - threshold) {
      onEndReached();
    }
  }

  @override
  void dispose() {
    removeListener(_scrollListener);
    super.dispose();
  }
}
