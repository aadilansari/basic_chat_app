import 'package:shared_preferences/shared_preferences.dart';

class TokenStorageService {
  static const key = 'receiver_token';

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }
}
