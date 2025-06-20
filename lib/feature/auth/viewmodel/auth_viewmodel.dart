import 'package:basic_chat_app/data/models/user_model.dart';
import 'package:basic_chat_app/data/repository/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final authRepositoryProvider = Provider((ref) => AuthRepository());

final authProvider = StateNotifierProvider<AuthViewModel, UserModel?>((ref) {
  final repo = ref.read(authRepositoryProvider);
  return AuthViewModel(repo)..loadUser();
});

class AuthViewModel extends StateNotifier<UserModel?> {
  final AuthRepository _repo;

  AuthViewModel(this._repo) : super(null);

  void loadUser() async {
    final user = await _repo.getUser();
    state = user;
  }

  Future<void> login(UserModel user) async {
    await _repo.saveUser(user);
    state = user;
  }

  Future<void> logout() async {
    await _repo.clearUser();
    state = null;
  }
}
