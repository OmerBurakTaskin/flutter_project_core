class PaginatedViewModel<T> {
  final bool isLoading;
  final List<T> items;
  final int currentPage;
  final int maxPage;

  const PaginatedViewModel({
    this.isLoading = false,
    this.items = const [],
    this.currentPage = 0,
    this.maxPage = 1,
  });

  bool get isAvailable => !isLoading && hasMore;
  bool get hasMore => currentPage < maxPage;
  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;
  int get length => items.length;

  PaginatedViewModel<T> copyWith({
    bool? isLoading,
    List<T>? items,
    int? currentPage,
    int? maxPage,
  }) {
    return PaginatedViewModel<T>(
      isLoading: isLoading ?? this.isLoading,
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      maxPage: maxPage ?? this.maxPage,
    );
  }

  PaginatedViewModel<T> add({required List<T> newItems, int totalPages = 1}) =>
      copyWith(
        items: [...items, ...newItems],
        currentPage: currentPage + 1,
        maxPage: totalPages,
      );

  PaginatedViewModel<T> refresh({
    List<T> newItems = const [],
    int totalPages = 1,
  }) => copyWith(items: newItems, currentPage: 1, maxPage: totalPages);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaginatedViewModel<T> &&
          isLoading == other.isLoading &&
          identical(items, other.items) &&
          currentPage == other.currentPage &&
          maxPage == other.maxPage;

  @override
  int get hashCode =>
      Object.hash(isLoading, identityHashCode(items), currentPage, maxPage);

  @override
  String toString() =>
      'PaginatedViewModel<$T>(isLoading: $isLoading, items: ${items.length}, '
      'currentPage: $currentPage, maxPage: $maxPage)';
}
