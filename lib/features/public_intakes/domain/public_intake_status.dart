enum PublicIntakeStatus {
  newStatus('new'),
  reviewing('reviewing'),
  contacted('contacted'),
  quoted('quoted'),
  converted('converted'),
  rejected('rejected'),
  closed('closed'),
  unknown('unknown');

  const PublicIntakeStatus(this.backendValue);

  final String backendValue;

  static PublicIntakeStatus fromBackendValue(String? raw) {
    if (raw == null || raw.trim().isEmpty) return unknown;
    for (final status in PublicIntakeStatus.values) {
      if (status.backendValue == raw) return status;
    }
    return unknown;
  }

  bool get isOpen =>
      this == newStatus || this == reviewing || this == contacted;

  bool get requiresReasonOnClose => this == rejected || this == closed;

  String localizationKey() {
    return switch (this) {
      PublicIntakeStatus.newStatus => 'publicIntakeStatusNew',
      PublicIntakeStatus.reviewing => 'publicIntakeStatusReviewing',
      PublicIntakeStatus.contacted => 'publicIntakeStatusContacted',
      PublicIntakeStatus.quoted => 'publicIntakeStatusQuoted',
      PublicIntakeStatus.converted => 'publicIntakeStatusConverted',
      PublicIntakeStatus.rejected => 'publicIntakeStatusRejected',
      PublicIntakeStatus.closed => 'publicIntakeStatusClosed',
      PublicIntakeStatus.unknown => 'publicIntakeStatusUnknown',
    };
  }
}

enum PublicIntakeListFilter {
  all,
  newStatus,
  reviewing,
  quoteDemo,
  contacted,
  closed,
}

extension PublicIntakeListFilterX on PublicIntakeListFilter {
  String localizationKey() {
    return switch (this) {
      PublicIntakeListFilter.all => 'publicIntakeFilterAll',
      PublicIntakeListFilter.newStatus => 'publicIntakeFilterNew',
      PublicIntakeListFilter.reviewing => 'publicIntakeFilterReviewing',
      PublicIntakeListFilter.quoteDemo => 'publicIntakeFilterQuoteDemo',
      PublicIntakeListFilter.contacted => 'publicIntakeFilterContacted',
      PublicIntakeListFilter.closed => 'publicIntakeFilterClosed',
    };
  }
}
