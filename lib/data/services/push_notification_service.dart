import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart';

class PushNotificationService {
  final String projectId = 'chatapp-26522';

  Future<String> _getAccessToken() async {
    final accountCredentials = ServiceAccountCredentials.fromJson(
      File('assets/service_account.json').readAsStringSync(),
    );

    final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

    final client = await clientViaServiceAccount(accountCredentials, scopes);
    return (client.credentials.accessToken).data;
  }

  Future<void> sendPushNotification({
    required String targetToken,
    required String senderName,
    required String message,
  }) async {
    final accessToken = await _getAccessToken();

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
  }
}
