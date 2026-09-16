import '../domain/customer_communication_message.dart';

/// Prefer the latest inbound message language (customer's sending language).
String? resolveCustomerSenderLanguage(
  Iterable<CustomerCommunicationMessage> messages,
) {
  for (final message in messages.toList().reversed) {
    if (message.direction != CustomerCommunicationDirection.inbound) {
      continue;
    }
    final code = message.originalLanguage?.trim().toLowerCase();
    if (code != null && code.isNotEmpty) {
      return code.length >= 2 ? code.substring(0, 2) : code;
    }
  }
  return null;
}

/// Latest inbound body used for language detection fallback.
String? latestInboundOriginalText(
  Iterable<CustomerCommunicationMessage> messages,
) {
  for (final message in messages.toList().reversed) {
    if (message.direction != CustomerCommunicationDirection.inbound) {
      continue;
    }
    final text = message.originalText?.trim();
    if (text != null && text.isNotEmpty) {
      return text;
    }
  }
  return null;
}
