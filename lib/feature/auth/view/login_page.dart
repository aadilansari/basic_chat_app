import 'package:basic_chat_app/core/widgets/custom_textfield.dart';
import 'package:basic_chat_app/data/models/user_model.dart';
import 'package:basic_chat_app/feature/auth/view/register_page.dart';
import 'package:basic_chat_app/feature/auth/viewmodel/auth_viewmodel.dart';
import 'package:basic_chat_app/feature/home/view/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailCtrl = TextEditingController();
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Login/Register")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextField(
              controller: emailCtrl,
              label: 'Email',
              hintText: 'Enter your email',
              keyboardType: TextInputType.emailAddress,
              icon: Icons.email,
              validator: (value) =>
                  (value == null || value.isEmpty) ? 'Email is required' : null,
            ),
            const SizedBox(height: 16),

            CustomTextField(
              controller: nameCtrl,
              label: 'Name',
              hintText: 'Enter your name',
              icon: Icons.person,
              validator: (value) =>
                  (value == null || value.isEmpty) ? 'Name is required' : null,
            ),
            const SizedBox(height: 16),

            CustomTextField(
              controller: phoneCtrl,
              label: 'Phone',
              hintText: 'Enter your phone number',
              keyboardType: TextInputType.phone,
              icon: Icons.phone,
              validator: (value) => (value == null || value.isEmpty)
                  ? 'Phone number is required'
                  : null,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final user = UserModel(
                  email: emailCtrl.text,
                  name: nameCtrl.text,
                  phone: phoneCtrl.text,
                  country: "India", // Will be dynamic later
                );
                ref.read(authProvider.notifier).login(user);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomePage()),
                );
              },
              child: const Text("Login/Register"),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterPage()),
                );
              },
              child: const Text("Don't have an account? Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}
