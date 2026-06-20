import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/features/notifications/data/notifications_repository.dart';
import 'package:vianexis_admin_app/features/notifications/domain/push_provider_status.dart';
import 'package:vianexis_admin_app/features/release_center/data/release_center_repository.dart';
import 'package:vianexis_admin_app/features/release_center/domain/email_delivery_status.dart';
import 'package:vianexis_admin_app/features/release_center/domain/observability_status.dart';

final _secretPatterns = [
  RegExp(r'sentry_dsn', caseSensitive: false),
  RegExp(r'otlp', caseSensitive: false),
  RegExp(r'smtp_password', caseSensitive: false),
  RegExp(r'fcm_credentials', caseSensitive: false),
  RegExp(r'apns_key', caseSensitive: false),
  RegExp(r'Bearer\s', caseSensitive: false),
  RegExp(r'https?://[^\s]+@', caseSensitive: false),
];

void expectNoSecretsInDisplayValues(List<String> values) {
  for (final value in values) {
    for (final pattern in _secretPatterns) {
      expect(
        pattern.hasMatch(value),
        isFalse,
        reason: 'Display value "$value" matched secret pattern $pattern',
      );
    }
  }
}

void main() {
  group('EmailDeliveryStatus JSON', () {
    test('parses metadata-only status without secret fields', () {
      final status = EmailDeliveryStatus.fromJson({
        'provider': 'noop',
        'deliveryEnabled': false,
        'lastDeliveryStatus': 'skipped',
        'lastDeliveryAt': '2026-06-20T10:00:00.000Z',
        'metadataOnly': true,
        'smtpPassword': 'must-not-appear',
        'sentryDsn': 'https://secret@sentry.io/1',
      });

      expect(status.metadataOnly, isTrue);
      expect(status.provider, 'noop');
      expect(status.deliveryEnabled, isFalse);
      expect(status.lastDeliveryStatus, 'skipped');
      expectNoSecretsInDisplayValues(status.safeDisplayValues);
    });
  });

  group('EmailDeliveryLog JSON', () {
    test('parses metadata-only log entries', () {
      final page = EmailDeliveryLogsPage.fromJson({
        'metadataOnly': true,
        'total': 1,
        'items': [
          {
            'id': 42,
            'type': 'admin_invite',
            'recipientEmailHash': 'abc123',
            'recipientEmailDomain': 'vianexis.test',
            'status': 'skipped',
            'provider': 'noop',
            'createdAt': '2026-06-20T10:00:00.000Z',
            'metadataOnly': true,
          },
        ],
      });

      expect(page.metadataOnly, isTrue);
      expect(page.items, hasLength(1));
      expect(page.items.first.recipientEmailHash, 'abc123');
      expect(page.items.first.recipientEmailDomain, 'vianexis.test');
    });
  });

  group('ObservabilityStatus JSON', () {
    test('parses configured flags without exposing DSN values', () {
      final status = ObservabilityStatus.fromJson({
        'logLevel': 'info',
        'metricsEnabled': false,
        'sentryConfigured': true,
        'otelConfigured': false,
        'correlationIdEnabled': true,
        'lastCriticalErrorAt': '2026-06-19T12:00:00.000Z',
        'metadataOnly': true,
        'sentryDsn': 'https://secret@sentry.io/1',
        'otelExporterOtlpEndpoint': 'https://collector.example.com',
      });

      expect(status.metadataOnly, isTrue);
      expect(status.sentryConfigured, isTrue);
      expect(status.otelConfigured, isFalse);
      expectNoSecretsInDisplayValues(status.safeDisplayValues);
    });
  });

  group('PushProviderStatus JSON', () {
    test('parses provider status and derives UI state', () {
      final inApp = PushProviderStatus.fromJson({
        'provider': 'none',
        'deliveryEnabled': false,
        'configured': false,
        'tokenStorageMode': 'hash_only',
        'metadataOnly': true,
      });
      expect(inApp.uiState, PushProviderUiState.inAppOnly);
      expectNoSecretsInDisplayValues(inApp.safeDisplayValues);

      final notConfigured = PushProviderStatus.fromJson({
        'provider': 'fcm',
        'deliveryEnabled': false,
        'configured': false,
        'tokenStorageMode': 'hash_only',
        'lastFailureCode': 'credentials_missing',
        'metadataOnly': true,
        'fcmCredentialsPath': '/secrets/firebase.json',
      });
      expect(notConfigured.uiState, PushProviderUiState.externalNotConfigured);
      expectNoSecretsInDisplayValues(notConfigured.safeDisplayValues);

      final configured = PushProviderStatus.fromJson({
        'provider': 'fcm',
        'deliveryEnabled': true,
        'configured': true,
        'tokenStorageMode': 'hash_only',
        'metadataOnly': true,
      });
      expect(configured.uiState, PushProviderUiState.configured);
      expectNoSecretsInDisplayValues(configured.safeDisplayValues);
    });
  });

  group('MockReleaseCenterRepository phases 38/41', () {
    test('returns mock email delivery and observability status', () async {
      final repo = MockReleaseCenterRepository();
      expect(repo.usesMockData, isTrue);

      final emailStatus = await repo.fetchEmailDeliveryStatus();
      expect(emailStatus.metadataOnly, isTrue);
      expect(emailStatus.provider, isNotEmpty);
      expectNoSecretsInDisplayValues(emailStatus.safeDisplayValues);

      final logs = await repo.fetchEmailDeliveryLogs();
      expect(logs.items, isNotEmpty);
      expect(logs.items.first.metadataOnly, isTrue);

      final observability = await repo.fetchObservabilityStatus();
      expect(observability.metadataOnly, isTrue);
      expectNoSecretsInDisplayValues(observability.safeDisplayValues);
    });
  });

  group('MockNotificationsRepository phase 39', () {
    test('returns mock push provider status', () async {
      final repo = MockNotificationsRepository();
      expect(repo.usesMockData, isTrue);

      final status = await repo.fetchProviderStatus();
      expect(status.metadataOnly, isTrue);
      expect(status.uiState, PushProviderUiState.inAppOnly);
      expectNoSecretsInDisplayValues(status.safeDisplayValues);
    });
  });
}
