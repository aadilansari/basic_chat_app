// // providers/paired_user_provider.dart
// import 'package:basic_chat_app/data/models/user_model.dart';
// import 'package:basic_chat_app/data/services/paired_user_storage_service.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';


// class PairedUserNotifier extends StateNotifier<List<UserModel>> {
//   PairedUserNotifier() : super([]) {
//     _loadUsers();
// }

//   Future<void> _loadUsers() async {
//     final users = await PairedUserStorageService().getUsers();
//     state = users;
//   }

//   Future<void> addUser(UserModel user) async {
//     await PairedUserStorageService().addUser(user);
//     await _loadUsers(); // reload list after add
//   }

//   Future<void> refresh() async => _loadUsers();
// }

// final pairedUserProvider =
//     StateNotifierProvider<PairedUserNotifier, List<UserModel>>((ref) {
//   return PairedUserNotifier();
// });
