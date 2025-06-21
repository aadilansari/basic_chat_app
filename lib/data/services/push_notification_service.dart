import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart';
import 'package:path_provider/path_provider.dart';
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
    required String senderName,
    required String message,
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