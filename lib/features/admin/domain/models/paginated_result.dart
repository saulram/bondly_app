class PaginatedResult<T> {
  final List<T> items;
  final int total;
  final int page;
  final int pageSize;

  const PaginatedResult({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  int get totalPages => pageSize > 0 ? (total / pageSize).ceil() : 0;
  bool get hasNextPage => page < totalPages;
  bool get hasPrevPage => page > 1;

  PaginatedResult<T> copyWith({
    List<T>? items,
    int? total,
    int? page,
    int? pageSize,
  }) {
    return PaginatedResult<T>(
      items: items ?? this.items,
      total: total ?? this.total,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
    );
  }

  static PaginatedResult<T> empty<T>() {
    return PaginatedResult<T>(items: [], total: 0, page: 1, pageSize: 20);
  }
}
