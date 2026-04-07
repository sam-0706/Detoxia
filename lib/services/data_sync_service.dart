import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

/// Sends user registration data to a Google Sheets webhook.
///
/// Setup instructions (zero cost):
/// 1. Create a Google Sheet with columns: timestamp, name, email, phone, country
/// 2. Go to Extensions > Apps Script
/// 3. Paste this script:
///    function doPost(e) {
///      var sheet = SpreadsheetApp.getActiveSpreadsheet().getActiveSheet();
///      var data = JSON.parse(e.postData.contents);
///      sheet.appendRow([new Date(), data.name, data.email, data.phone, data.country]);
///      return ContentService.createTextOutput('ok');
///    }
/// 4. Deploy > New deployment > Web app > Anyone > Deploy
/// 5. Copy the URL and paste below
class DataSyncService {
  // Replace with your Google Apps Script Web App URL
  static const String _webhookUrl = '';

  static Future<void> sendRegistration({
    required String name,
    required String email,
    required String phone,
    required String country,
  }) async {
    if (_webhookUrl.isEmpty) {
      debugPrint('DataSync: No webhook URL configured, skipping sync');
      return;
    }

    try {
      final client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 10);

      final uri = Uri.parse(_webhookUrl);
      final request = await client.postUrl(uri);
      request.headers.contentType = ContentType.json;
      request.write(jsonEncode({
        'name': name,
        'email': email,
        'phone': phone,
        'country': country,
        'registered_at': DateTime.now().toIso8601String(),
      }));

      final response = await request.close();
      await response.drain();
      client.close();
      debugPrint('DataSync: Registration sent successfully');
    } catch (e) {
      debugPrint('DataSync: Failed to send (non-fatal): $e');
    }
  }
}
