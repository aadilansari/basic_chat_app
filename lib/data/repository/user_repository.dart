import '../models/user_model.dart';

class UserRepository {
  // Simulated list of paired users (normally from server or QR)
  List<UserModel> getPairedUsers() {
    return [
      UserModel(
        email: 'john@example.com',
        name: 'John Doe',
        phone: '1234567890',
        country: 'USA',
        fcmToken: 'johns_device_token',
        password: 'password123', // Simulated password
      ),
      UserModel(
        email: 'jane@example.com',
        name: 'Jane Smith',
        phone: '9876543210',
        country: 'UK',
        fcmToken: 'janes_device_token', 
        password: 'password456', // Simulated password
      ),
    ];
  }
}
