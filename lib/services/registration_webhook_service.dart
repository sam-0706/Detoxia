import 'dart:convert';
import 'dart:io';

import 'package:detoxia/core/constants/enums.dart';
import 'package:detoxia/data/database/app_database.dart';
import 'package:flutter/foundation.dart';

typedef RegistrationHttpPost = Future<int> Function(
  Uri uri,
  Map<String, dynamic> payload,
);

class RegistrationWebhookService {
  static const String webhookUrl = '';
  static const String appVersion = '1.0.0';

  final String url;
  final RegistrationHttpPost? httpPost;

  const RegistrationWebhookService({
    this.url = webhookUrl,
    this.httpPost,
  });

  Future<WebhookSyncStatus> sync(RegistrationProfile profile) async {
    if (url.trim().isEmpty) {
      debugPrint('Registration webhook disabled: no URL configured');
      return WebhookSyncStatus.disabled;
    }

    try {
      final uri = Uri.parse(url);
      final payload = buildPayload(profile);
      final statusCode = httpPost != null
          ? await httpPost!(uri, payload)
          : await _postWithHttpClient(uri, payload);

      return statusCode >= 200 && statusCode < 300
          ? WebhookSyncStatus.success
          : WebhookSyncStatus.failed;
    } catch (e) {
      debugPrint('Registration webhook failed (non-fatal): $e');
      return WebhookSyncStatus.failed;
    }
  }

  Map<String, dynamic> buildPayload(RegistrationProfile profile) {
    return {
      'appInstallId': profile.appInstallId,
      'displayName': profile.displayName,
      'email': profile.email,
      'phone': profile.phone,
      'ageBand': profile.ageBand,
      'gender': profile.gender,
      'countryCode': profile.countryCode,
      'regionName': profile.regionName,
      'timezone': profile.timezone,
      'privacyAcknowledged': profile.privacyAcknowledged,
      'marketingConsent': profile.marketingConsent,
      'appVersion': appVersion,
      'platform': Platform.operatingSystem,
      'createdAt': profile.createdAt.toIso8601String(),
    };
  }

  Future<int> _postWithHttpClient(
    Uri uri,
    Map<String, dynamic> payload,
  ) async {
    final client = HttpClient();
    client.connectionTimeout = const Duration(seconds: 10);
    try {
      final request = await client.postUrl(uri);
      request.headers.contentType = ContentType.json;
      request.write(jsonEncode(payload));
      final response = await request.close();
      await response.drain();
      return response.statusCode;
    } finally {
      client.close();
    }
  }
}
