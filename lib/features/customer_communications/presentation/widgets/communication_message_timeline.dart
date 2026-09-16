import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../../translation/data/translation_repository.dart';
import '../../../translation/domain/translation_request.dart';
import '../../domain/customer_communication_message.dart';
import '../communications_translation_preference.dart';
import 'delivery_status_badge.dart';
import 'translated_message_view.dart';

/// Timeline that auto-detects inbound language and translates to the admin
/// preference (HU by default, EN only when language settings are English).
class CommunicationMessageTimeline extends ConsumerStatefulWidget {
  const CommunicationMessageTimeline({
    super.key,
    required this.messages,
    this.deliveryCountForMessage,
    this.companyId,
  });

  final List<CustomerCommunicationMessage> messages;
  final int Function(String messageId)? deliveryCountForMessage;
  final String? companyId;

  @override
  ConsumerState<CommunicationMessageTimeline> createState() =>
      _CommunicationMessageTimelineState();
}

class _MessageTranslationOverlay {
  const _MessageTranslationOverlay({
    required this.detectedLanguage,
    required this.translatedText,
    required this.translatedLanguage,
  });

  final String? detectedLanguage;
  final String translatedText;
  final String translatedLanguage;
}

class _CommunicationMessageTimelineState
    extends ConsumerState<CommunicationMessageTimeline> {
  final Map<String, _MessageTranslationOverlay> _overlays = {};
  final Set<String> _inFlight = {};
  final Set<String> _failed = {};
  String? _lastTarget;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final target = communicationsTranslationTargetOf(ref, context);
    if (_lastTarget != target) {
      _lastTarget = target;
      _overlays.clear();
      _failed.clear();
      _scheduleAutoTranslate(target);
    }
  }

  @override
  void didUpdateWidget(covariant CommunicationMessageTimeline oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.messages, widget.messages)) {
      _scheduleAutoTranslate(_lastTarget ?? 'hu');
    }
  }

  void _scheduleAutoTranslate(String targetLanguage) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _autoTranslateInbound(targetLanguage);
    });
  }

  Future<void> _autoTranslateInbound(String targetLanguage) async {
    final repo = ref.read(translationRepositoryProvider);
    for (final message in widget.messages) {
      if (message.direction != CustomerCommunicationDirection.inbound) {
        continue;
      }
      final text = message.originalText?.trim();
      if (text == null || text.isEmpty) continue;
      if (_overlays.containsKey(message.id) ||
          _inFlight.contains(message.id) ||
          _failed.contains(message.id)) {
        continue;
      }

      final existingTarget = message.translatedLanguage?.toLowerCase();
      if (message.hasTranslation &&
          existingTarget != null &&
          existingTarget.startsWith(targetLanguage)) {
        continue;
      }

      final sourceHint = message.originalLanguage?.toLowerCase();
      if (sourceHint != null &&
          sourceHint.startsWith(targetLanguage) &&
          !message.hasTranslation) {
        // Already in the admin reading language — no machine translation needed.
        continue;
      }

      _inFlight.add(message.id);
      try {
        String? detected = sourceHint;
        if (detected == null || detected.isEmpty) {
          final detection = await repo.detectLanguage(text);
          detected = detection.language?.toLowerCase();
        }
        final normalizedDetected = detected != null && detected.length >= 2
            ? detected.substring(0, 2)
            : detected;

        if (normalizedDetected == targetLanguage) {
          if (mounted) {
            setState(() {
              _inFlight.remove(message.id);
            });
          } else {
            _inFlight.remove(message.id);
          }
          continue;
        }

        final result = await repo.translate(
          TranslationRequest(
            sourceType: 'customer_communication_message',
            sourceId: message.id,
            sourceField: 'originalText',
            text: text,
            targetLanguage: targetLanguage,
            sourceLanguage: normalizedDetected,
            companyId: widget.companyId,
          ),
        );
        final translated = result.translatedText?.trim();
        if (translated == null || translated.isEmpty) {
          _failed.add(message.id);
          continue;
        }
        if (!mounted) return;
        setState(() {
          _overlays[message.id] = _MessageTranslationOverlay(
            detectedLanguage: normalizedDetected ?? result.detectedSourceLanguage,
            translatedText: translated,
            translatedLanguage: targetLanguage,
          );
        });
      } catch (_) {
        _failed.add(message.id);
      } finally {
        _inFlight.remove(message.id);
        if (mounted) setState(() {});
      }
    }
  }

  CustomerCommunicationMessage _displayMessage(
    CustomerCommunicationMessage message,
  ) {
    final overlay = _overlays[message.id];
    if (overlay == null) return message;
    return CustomerCommunicationMessage(
      id: message.id,
      threadId: message.threadId,
      direction: message.direction,
      senderType: message.senderType,
      senderUserId: message.senderUserId,
      senderEmailHash: message.senderEmailHash,
      senderEmailDomain: message.senderEmailDomain,
      originalText: message.originalText,
      originalLanguage: overlay.detectedLanguage ?? message.originalLanguage,
      translatedText: overlay.translatedText,
      translatedLanguage: overlay.translatedLanguage,
      translationRecordId: message.translationRecordId,
      humanReviewedTranslation: message.humanReviewedTranslation,
      sentAt: message.sentAt,
      createdAt: message.createdAt,
      metadataOnly: message.metadataOnly,
      delivery: message.delivery,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.messages.isEmpty) {
      return Text(
        resolveCustomerCommunicationsKey(
          context,
          'customerCommunicationMessagesEmpty',
        ),
      );
    }

    return Column(
      children: [
        for (final message in widget.messages)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        Chip(
                          label: Text(
                            resolveCustomerCommunicationsKey(
                              context,
                              message.direction.localizationKey(),
                            ),
                          ),
                        ),
                        Chip(
                          label: Text(
                            resolveCustomerCommunicationsKey(
                              context,
                              message.senderType.localizationKey(),
                            ),
                          ),
                        ),
                        if (message.humanReviewedTranslation)
                          Chip(
                            label: Text(
                              resolveCustomerCommunicationsKey(
                                context,
                                'customerCommunicationHumanReviewedBadge',
                              ),
                            ),
                          ),
                        if (_overlays.containsKey(message.id))
                          Chip(
                            avatar: const Icon(Icons.translate, size: 16),
                            label: Text(
                              resolveCustomerCommunicationsKey(
                                context,
                                'customerCommunicationAutoTranslatedBadge',
                              ),
                            ),
                          ),
                        if (_inFlight.contains(message.id))
                          Chip(
                            label: Text(
                              resolveCustomerCommunicationsKey(
                                context,
                                'customerCommunicationAutoTranslatingBadge',
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TranslatedMessageView(message: _displayMessage(message)),
                    if (message.delivery != null) ...[
                      const SizedBox(height: 12),
                      DeliveryStatusBadge(delivery: message.delivery!),
                      if (widget.deliveryCountForMessage != null &&
                          widget.deliveryCountForMessage!(message.id) > 1) ...[
                        const SizedBox(height: 8),
                        Text(
                          resolveCustomerCommunicationsKey(
                            context,
                            'customerCommunicationDeliveryMultipleAttempts',
                          ),
                        ),
                      ],
                      if (message.delivery!.failureMessageSafe != null &&
                          message
                              .delivery!
                              .failureMessageSafe!
                              .isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          message.delivery!.failureMessageSafe!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ],
                    ],
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
