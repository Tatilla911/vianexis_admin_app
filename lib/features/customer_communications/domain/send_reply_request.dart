import 'customer_message_delivery.dart';

class SendCustomerReplyRequest {
  const SendCustomerReplyRequest({
    required this.messageText,
    required this.messageLanguage,
    required this.recipientLanguage,
    this.translationRecordId,
    this.useTranslatedText = false,
    required this.humanConfirmed,
    this.deliveryChannel = 'email',
    this.subject,
    this.reason,
  });

  final String messageText;
  final String messageLanguage;
  final String recipientLanguage;
  final String? translationRecordId;
  final bool useTranslatedText;
  final bool humanConfirmed;
  final String deliveryChannel;
  final String? subject;
  final String? reason;

  Map<String, dynamic> toJson() {
    return {
      'draftText': messageText,
      'messageText': messageText,
      'draftLanguage': messageLanguage,
      'messageLanguage': messageLanguage,
      'targetLanguage': recipientLanguage,
      'recipientLanguage': recipientLanguage,
      if (translationRecordId != null)
        'translationRecordId': int.tryParse(translationRecordId!) ??
            translationRecordId,
      if (translationRecordId != null)
        'approvedTranslationRecordId': int.tryParse(translationRecordId!) ??
            translationRecordId,
      'useTranslatedText': useTranslatedText,
      'humanConfirmed': humanConfirmed,
      'deliveryChannel': deliveryChannel,
      if (subject != null && subject!.trim().isNotEmpty) 'subject': subject,
      if (reason != null && reason!.trim().isNotEmpty) 'reason': reason,
    };
  }
}

class ResendCustomerReplyRequest {
  const ResendCustomerReplyRequest({
    required this.reason,
    required this.humanConfirmed,
  });

  final String reason;
  final bool humanConfirmed;

  Map<String, dynamic> toJson() => {
        'reason': reason,
        'humanConfirmed': humanConfirmed,
      };
}

class SendCustomerReplyResult {
  const SendCustomerReplyResult({
    required this.messageId,
    required this.delivery,
    required this.deliveryStatus,
    this.providerNoopMode = true,
  });

  final String messageId;
  final CustomerMessageDelivery delivery;
  final String deliveryStatus;
  final bool providerNoopMode;

  factory SendCustomerReplyResult.fromJson(Map<String, dynamic> json) {
    final deliveryJson = json['delivery'];
    return SendCustomerReplyResult(
      messageId: json['message']?['id']?.toString() ?? '',
      delivery: deliveryJson is Map<String, dynamic>
          ? CustomerMessageDelivery.fromJson(deliveryJson)
          : CustomerMessageDelivery.fromJson(
              Map<String, dynamic>.from(deliveryJson as Map),
            ),
      deliveryStatus: json['deliveryStatus']?.toString() ?? 'unknown',
      providerNoopMode: json['providerStatusSafe']?['noopMode'] == true,
    );
  }
}
