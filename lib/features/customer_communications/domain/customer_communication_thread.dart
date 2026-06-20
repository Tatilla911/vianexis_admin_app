enum CustomerCommunicationThreadStatus {
  open,
  closed,
  archived,
  disputed,
  unknown;

  static CustomerCommunicationThreadStatus fromBackendValue(String? raw) {
    if (raw == null || raw.trim().isEmpty) return unknown;
    return switch (raw.trim().toLowerCase()) {
      'open' => open,
      'closed' => closed,
      'archived' => archived,
      'disputed' => disputed,
      _ => unknown,
    };
  }

  String localizationKey() {
    return switch (this) {
      CustomerCommunicationThreadStatus.open =>
        'customerCommunicationStatusOpen',
      CustomerCommunicationThreadStatus.closed =>
        'customerCommunicationStatusClosed',
      CustomerCommunicationThreadStatus.archived =>
        'customerCommunicationStatusArchived',
      CustomerCommunicationThreadStatus.disputed =>
        'customerCommunicationStatusDisputed',
      CustomerCommunicationThreadStatus.unknown =>
        'customerCommunicationStatusUnknown',
    };
  }
}

enum CustomerCommunicationSource {
  publicSite,
  email,
  adminApp,
  adminWeb,
  importSource,
  support,
  system,
  unknown;

  static CustomerCommunicationSource fromBackendValue(String? raw) {
    if (raw == null || raw.trim().isEmpty) return unknown;
    return switch (raw.trim().toLowerCase()) {
      'public_site' => publicSite,
      'email' => email,
      'admin_app' => adminApp,
      'admin_web' => adminWeb,
      'import' => importSource,
      'support' => support,
      'system' => system,
      _ => unknown,
    };
  }

  String localizationKey() {
    return switch (this) {
      CustomerCommunicationSource.publicSite =>
        'customerCommunicationSourcePublicSite',
      CustomerCommunicationSource.email => 'customerCommunicationSourceEmail',
      CustomerCommunicationSource.adminApp =>
        'customerCommunicationSourceAdminApp',
      CustomerCommunicationSource.adminWeb =>
        'customerCommunicationSourceAdminWeb',
      CustomerCommunicationSource.importSource =>
        'customerCommunicationSourceImport',
      CustomerCommunicationSource.support =>
        'customerCommunicationSourceSupport',
      CustomerCommunicationSource.system => 'customerCommunicationSourceSystem',
      CustomerCommunicationSource.unknown =>
        'customerCommunicationSourceUnknown',
    };
  }
}

enum CustomerCommunicationListFilter {
  all,
  open,
  disputed,
  closed,
  billingRelated,
}

extension CustomerCommunicationListFilterX on CustomerCommunicationListFilter {
  String localizationKey() {
    return switch (this) {
      CustomerCommunicationListFilter.all => 'customerCommunicationFilterAll',
      CustomerCommunicationListFilter.open => 'customerCommunicationFilterOpen',
      CustomerCommunicationListFilter.disputed =>
        'customerCommunicationFilterDisputed',
      CustomerCommunicationListFilter.closed =>
        'customerCommunicationFilterClosed',
      CustomerCommunicationListFilter.billingRelated =>
        'customerCommunicationFilterBillingRelated',
    };
  }
}

class CustomerCommunicationThread {
  const CustomerCommunicationThread({
    required this.id,
    this.companyId,
    this.registrationApplicationId,
    this.pricingIntakeId,
    this.quoteRequestId,
    this.subscriptionId,
    this.customerEmailHash,
    this.customerEmailDomain,
    this.customerDisplayName,
    required this.status,
    required this.source,
    this.disputed = false,
    this.disputeReason,
    this.disputedAt,
    this.disputedByUserId,
    this.createdAt,
    this.updatedAt,
    this.metadataOnly = true,
  });

  final String id;
  final String? companyId;
  final String? registrationApplicationId;
  final String? pricingIntakeId;
  final String? quoteRequestId;
  final String? subscriptionId;
  final String? customerEmailHash;
  final String? customerEmailDomain;
  final String? customerDisplayName;
  final CustomerCommunicationThreadStatus status;
  final CustomerCommunicationSource source;
  final bool disputed;
  final String? disputeReason;
  final DateTime? disputedAt;
  final String? disputedByUserId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool metadataOnly;

  bool get isBillingRelated =>
      subscriptionId != null ||
      pricingIntakeId != null ||
      quoteRequestId != null;

  bool matchesSearch(String query) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) return true;
    return [
      customerDisplayName,
      customerEmailDomain,
      customerEmailHash,
      companyId,
      disputeReason,
    ].whereType<String>().any((value) => value.toLowerCase().contains(normalized));
  }

  bool matchesFilter(CustomerCommunicationListFilter filter) {
    return switch (filter) {
      CustomerCommunicationListFilter.all => true,
      CustomerCommunicationListFilter.open =>
        status == CustomerCommunicationThreadStatus.open,
      CustomerCommunicationListFilter.disputed =>
        status == CustomerCommunicationThreadStatus.disputed || disputed,
      CustomerCommunicationListFilter.closed =>
        status == CustomerCommunicationThreadStatus.closed ||
        status == CustomerCommunicationThreadStatus.archived,
      CustomerCommunicationListFilter.billingRelated => isBillingRelated,
    };
  }

  factory CustomerCommunicationThread.fromJson(Map<String, dynamic> json) {
    return CustomerCommunicationThread(
      id: json['id']?.toString() ?? '',
      companyId: json['companyId']?.toString(),
      registrationApplicationId: json['registrationApplicationId']?.toString(),
      pricingIntakeId: json['pricingIntakeId']?.toString(),
      quoteRequestId: json['quoteRequestId']?.toString(),
      subscriptionId: json['subscriptionId']?.toString(),
      customerEmailHash: json['customerEmailHash']?.toString(),
      customerEmailDomain: json['customerEmailDomain']?.toString(),
      customerDisplayName: json['customerDisplayName']?.toString(),
      status: CustomerCommunicationThreadStatus.fromBackendValue(
        json['status']?.toString(),
      ),
      source: CustomerCommunicationSource.fromBackendValue(
        json['source']?.toString(),
      ),
      disputed: json['disputed'] == true ||
          json['status']?.toString() == 'disputed',
      disputeReason: json['disputeReason']?.toString(),
      disputedAt: _parseDate(json['disputedAt']),
      disputedByUserId: json['disputedByUserId']?.toString(),
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
      metadataOnly: json['metadataOnly'] != false,
    );
  }

  CustomerCommunicationThread copyWith({
    CustomerCommunicationThreadStatus? status,
    bool? disputed,
    String? disputeReason,
    DateTime? disputedAt,
    DateTime? updatedAt,
  }) {
    return CustomerCommunicationThread(
      id: id,
      companyId: companyId,
      registrationApplicationId: registrationApplicationId,
      pricingIntakeId: pricingIntakeId,
      quoteRequestId: quoteRequestId,
      subscriptionId: subscriptionId,
      customerEmailHash: customerEmailHash,
      customerEmailDomain: customerEmailDomain,
      customerDisplayName: customerDisplayName,
      status: status ?? this.status,
      source: source,
      disputed: disputed ?? this.disputed,
      disputeReason: disputeReason ?? this.disputeReason,
      disputedAt: disputedAt ?? this.disputedAt,
      disputedByUserId: disputedByUserId,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      metadataOnly: metadataOnly,
    );
  }

  static DateTime? _parseDate(Object? raw) {
    if (raw == null) return null;
    if (raw is DateTime) return raw;
    return DateTime.tryParse(raw.toString());
  }
}

class CustomerCommunicationSummary {
  const CustomerCommunicationSummary({
    required this.disputedCount,
    required this.openCount,
    required this.totalCount,
    this.lastUpdatedAt,
  });

  final int disputedCount;
  final int openCount;
  final int totalCount;
  final DateTime? lastUpdatedAt;

  factory CustomerCommunicationSummary.fromThreads(
    List<CustomerCommunicationThread> threads,
  ) {
    var disputed = 0;
    var open = 0;
    for (final thread in threads) {
      if (thread.status == CustomerCommunicationThreadStatus.disputed ||
          thread.disputed) {
        disputed++;
      }
      if (thread.status == CustomerCommunicationThreadStatus.open) {
        open++;
      }
    }
    return CustomerCommunicationSummary(
      disputedCount: disputed,
      openCount: open,
      totalCount: threads.length,
      lastUpdatedAt: DateTime.now().toUtc(),
    );
  }
}
