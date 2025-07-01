class PaginatorState<T> {
  final int pageNumber;
  final List<T> items;
  final int? lastItemId;
  final bool hasNextPage;

  static const int itemsPerPage = 5;

  PaginatorState({
    this.pageNumber = 0,
    required this.items,
    this.lastItemId,
    this.hasNextPage = false,
  });

  PaginatorState<T> copyWith({
    int? pageNumber,
    List<T>? items,
    int? lastItemId,
    bool? hasNextPage,
  }) {
    return PaginatorState(
      pageNumber: pageNumber ?? this.pageNumber,
      items: items ?? this.items,
      lastItemId: lastItemId ?? this.lastItemId,
      hasNextPage: hasNextPage ?? this.hasNextPage,
    );
  }

  static PaginatorState initial() {
    return PaginatorState(items: [], lastItemId: 0, hasNextPage: false);
  }
}

extension PaginatorStateX<T> on PaginatorState<T> {
  bool get isNotEmpty => items.isNotEmpty;
  int get itemsLength => items.length;

  String get pageNumberUI => '${pageNumber + 1}';
}
