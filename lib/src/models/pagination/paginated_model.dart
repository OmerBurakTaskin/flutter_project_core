class PaginatedModel<T> {
  final List<T> items;
  final int currentPage;
  final int totalPages;
  final int totalElements;
  final int pageSize;

  PaginatedModel({
    required this.items,
    required this.currentPage,
    required this.totalPages,
    required this.totalElements,
    required this.pageSize,
  });

  factory PaginatedModel.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return PaginatedModel<T>(
      items: (json['content'] as List<dynamic>)
          .map((item) => fromJsonT(item as Map<String, dynamic>))
          .toList(),
      currentPage: json['currentPage'] as int,
      totalPages: json['totalPages'] as int,
      totalElements: json['totalElements'] as int,
      pageSize: json['pageSize'] as int,
    );
  }
}
