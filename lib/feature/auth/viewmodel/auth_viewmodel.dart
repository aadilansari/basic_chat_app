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

 Future<void> loginWithEmailPassword({
    required String email,
    required String password,
    required String fcmToken,
  }) async {
    final storedUser = await _repo.getUser();

    if (storedUser == null) {
      throw Exception('No registered user found.');
    }

    if (storedUser.email == email && storedUser.password == password) {
      final updatedUser = storedUser.copyWith(fcmToken: fcmToken);
      await _repo.saveUser(updatedUser);
      state = updatedUser;
    } else {
      throw Exception('Invalid email or password');
    }
  }

 Future<void> register(UserModel user) async {
    await _repo.saveUser(user);
    state = user;
  }

 Future<void> logout() async {
    await _repo.clearUser();
    state = null;
  }


}
