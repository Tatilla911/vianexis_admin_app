class AdminActionResult {
  const AdminActionResult({
    required this.success,
    this.messageKey,
  });

  const AdminActionResult.success({this.messageKey}) : success = true;

  const AdminActionResult.failure({required this.messageKey}) : success = false;

  final bool success;
  final String? messageKey;
}
