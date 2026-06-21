import 'customer_message_delivery.dart';
import 'customer_message_delivery_event.dart';

class CustomerDeliveryDetail {
  const CustomerDeliveryDetail({
    required this.delivery,
    this.events = const [],
  });

  final CustomerMessageDelivery delivery;
  final List<CustomerMessageDeliveryEvent> events;

  factory CustomerDeliveryDetail.fromJson(Map<String, dynamic> json) {
    final deliveryJson = json['delivery'];
    return CustomerDeliveryDetail(
      delivery: deliveryJson is Map
          ? CustomerMessageDelivery.fromJson(
              Map<String, dynamic>.from(deliveryJson),
            )
          : CustomerMessageDelivery.fromJson(json),
      events: _parseEvents(json['events']),
    );
  }

  static List<CustomerMessageDeliveryEvent> _parseEvents(Object? raw) {
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((item) => CustomerMessageDeliveryEvent.fromJson(
              Map<String, dynamic>.from(item),
            ))
        .toList(growable: false);
  }
}

class CustomerDeliveryListResult {
  const CustomerDeliveryListResult({
    required this.items,
    this.total = 0,
    this.metadataOnly = true,
  });

  final List<CustomerMessageDelivery> items;
  final int total;
  final bool metadataOnly;

  factory CustomerDeliveryListResult.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    return CustomerDeliveryListResult(
      items: rawItems is List
          ? rawItems
              .whereType<Map>()
              .map((item) => CustomerMessageDelivery.fromJson(
                    Map<String, dynamic>.from(item),
                  ))
              .toList(growable: false)
          : const [],
      total: int.tryParse(json['total']?.toString() ?? '') ??
          (rawItems is List ? rawItems.length : 0),
      metadataOnly: json['metadataOnly'] != false,
    );
  }
}

enum CustomerDeliveryHistoryFilter {
  all,
  skipped,
  failed,
  sent,
  queued;

  String? backendStatusValue() {
    return switch (this) {
      CustomerDeliveryHistoryFilter.all => null,
      CustomerDeliveryHistoryFilter.skipped => 'skipped',
      CustomerDeliveryHistoryFilter.failed => 'failed',
      CustomerDeliveryHistoryFilter.sent => 'sent',
      CustomerDeliveryHistoryFilter.queued => 'queued',
    };
  }

  String localizationKey() {
    return switch (this) {
      CustomerDeliveryHistoryFilter.all =>
        'customerCommunicationDeliveryFilterAll',
      CustomerDeliveryHistoryFilter.skipped =>
        'customerCommunicationDeliveryFilterSkipped',
      CustomerDeliveryHistoryFilter.failed =>
        'customerCommunicationDeliveryFilterFailed',
      CustomerDeliveryHistoryFilter.sent =>
        'customerCommunicationDeliveryFilterSent',
      CustomerDeliveryHistoryFilter.queued =>
        'customerCommunicationDeliveryFilterQueued',
    };
  }
}
