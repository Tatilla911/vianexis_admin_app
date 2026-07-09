class DriverRegistrationRequestItem {
  const DriverRegistrationRequestItem({
    required this.id,
    required this.fullName,
    required this.email,
    required this.status,
    this.phone,
    this.companyCode,
    this.matchedCompanyId,
    this.matchedCompanyName,
    this.preferredLanguage,
    this.vehicleHint,
    this.createdAt,
  });

  final String id;
  final String fullName;
  final String email;
  final String status;
  final String? phone;
  final String? companyCode;
  final String? matchedCompanyId;
  final String? matchedCompanyName;
  final String? preferredLanguage;
  final String? vehicleHint;
  final DateTime? createdAt;

  bool get isPending => status.toLowerCase() == 'pending';

  factory DriverRegistrationRequestItem.fromJson(Map<String, dynamic> json) {
    return DriverRegistrationRequestItem(
      id: json['id']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '—',
      email: json['email']?.toString() ?? '—',
      status: json['status']?.toString() ?? 'pending',
      phone: json['phone']?.toString(),
      companyCode: json['companyCode']?.toString(),
      matchedCompanyId: json['matchedCompanyId']?.toString(),
      matchedCompanyName: json['matchedCompanyName']?.toString(),
      preferredLanguage: json['preferredLanguage']?.toString(),
      vehicleHint: json['vehicleHint']?.toString(),
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
    );
  }
}

class DriverRegistrationRequestsPage {
  const DriverRegistrationRequestsPage({
    required this.items,
    required this.total,
    required this.listEndpointReady,
  });

  final List<DriverRegistrationRequestItem> items;
  final int total;
  final bool listEndpointReady;

  factory DriverRegistrationRequestsPage.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const DriverRegistrationRequestsPage(
        items: [],
        total: 0,
        listEndpointReady: false,
      );
    }
    final rawItems = json['items'];
    final items = rawItems is List
        ? rawItems
            .whereType<Map<String, dynamic>>()
            .map(DriverRegistrationRequestItem.fromJson)
            .toList(growable: false)
        : const <DriverRegistrationRequestItem>[];
    return DriverRegistrationRequestsPage(
      items: items,
      total: int.tryParse(json['total']?.toString() ?? '') ?? items.length,
      listEndpointReady: true,
    );
  }
}
