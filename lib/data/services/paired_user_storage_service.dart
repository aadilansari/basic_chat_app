// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:basic_chat_app/data/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';


final pairedUserStorageProvider = Provider<PairedUserStorageService>((ref) {
  return PairedUserStorageService();
});

class PairedUserStorageService {
  static const _key = 'paired_users';

  Future<List<UserModel>> getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    return list.map((e) => UserModel.fromJson(jsonDecode(e))).toList();
  }

  Future<void> addUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    final users = await getUsers();

    if (!users.any((u) => u.fcmToken == user.fcmToken)) {
      users.add(user);
      print(user.toJson());
      final updated = users.map((u) => jsonEncode(u.toJson())).toList();
      await prefs.setStringList(_key, updated);
    }
  }
}
