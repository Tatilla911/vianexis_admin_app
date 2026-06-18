class PagedResult<T> {
  const PagedResult({
    required this.items,
    required this.total,
    this.nextCursor,
  });

  final List<T> items;
  final int total;
  final String? nextCursor;

  bool get hasMore => nextCursor != null && nextCursor!.isNotEmpty;
}
