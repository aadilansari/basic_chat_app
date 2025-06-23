// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart';
 import 'package:flutter/services.dart' show rootBundle;

class PushNotificationService {
  final String projectId = 'chatapp-26522';

 

Future<String> _getAccessTokenFromFile() async {
  try {
    // Load the JSON content from the bundled asset
    final jsonString = await rootBundle.loadString('assets/service_account.json');

    final accountCredentials = ServiceAccountCredentials.fromJson(
      jsonDecode(jsonString),
    );

    final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
    final client = await clientViaServiceAccount(accountCredentials, scopes);
    final accessToken = client.credentials.accessToken.data;

    client.close();
    return accessToken;
  } catch (e) {
    print("❌ Error getting access token from asset: $e");
    rethrow;
  }
}

  Future<void> sendPushNotification({
    required String targetToken,
    required String currentToken,
    required String senderName,
    required String senderEmail,
    required String message,
    required String senderPhone,
  }) async {
    try {
      final accessToken = await _getAccessTokenFromFile();

      final url = Uri.parse(
        'https://fcm.googleapis.com/v1/projects/$projectId/messages:send',
      );

      final body = {
        "message": {
          "token": targetToken,
          "notification": {
            "title": senderName,
            "body": message,
          },
          "data": {
            "sender": senderName,
            "message": message,
            'email': senderEmail,
            'fcm':currentToken,
            'phone': senderPhone
          }
        }
      };

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print("✅ Push notification sent.");
      } else {
        print("❌ Failed to send notification: ${response.statusCode} ${response.body}");
      }
    } catch (e) {
      print("❌ Error sending push notification: $e");
    }
  }
}