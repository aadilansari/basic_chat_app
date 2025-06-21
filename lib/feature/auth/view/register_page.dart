import 'package:basic_chat_app/core/widgets/custom_textfield.dart';
import 'package:basic_chat_app/core/widgets/password_textfield.dart';
import 'package:basic_chat_app/data/models/user_model.dart';
import 'package:basic_chat_app/feature/auth/viewmodel/auth_viewmodel.dart';
import 'package:basic_chat_app/feature/home/view/home_page.dart';
import 'package:basic_chat_app/provider/country_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final selectedCountryProvider = StateProvider<String?>((ref) => null);

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final emailCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();

  @override
  void dispose() {
    emailCtrl.dispose();
    nameCtrl.dispose();
    phoneCtrl.dispose();
    passwordCtrl.dispose();
    confirmCtrl.dispose();
    super.dispose();
  }

 bool _isLoading = false;

Future<void> _submit() async {
  if (_formKey.currentState!.validate()) {
    setState(() => _isLoading = true);

    final selectedCountry = ref.read(selectedCountryProvider);
    final fcmToken = await FirebaseMessaging.instance.getToken();

    final user = UserModel(
      email: emailCtrl.text.trim(),
      name: nameCtrl.text.trim(),
      phone: phoneCtrl.text.trim(),
      country: selectedCountry ?? "Unknown",
      fcmToken: fcmToken ?? '',
      password: passwordCtrl.text.trim(),
    );

    ref.read(authProvider.notifier).register(user);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_email', user.email);

    setState(() => _isLoading = false);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    final countryListAsync = ref.watch(countryListProvider);
    final selectedCountry = ref.watch(selectedCountryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CustomTextField(
                controller: emailCtrl,
                label: 'Email',
                hintText: 'Enter your email',
                keyboardType: TextInputType.emailAddress,
                icon: Icons.email,
                validator: (v) =>
                    (v == null || !v.contains('@')) ? 'Invalid email' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: nameCtrl,
                label: 'Name',
                hintText: 'Enter your name',
                icon: Icons.person,
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Name cannot be empty' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: phoneCtrl,
                label: 'Phone',
                hintText: 'Enter your phone number',
                keyboardType: TextInputType.phone,
                icon: Icons.phone,
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Phone number required' : null,
              ),
              const SizedBox(height: 16),
              countryListAsync.when(
                data: (countries) => DropdownButtonFormField<String>(
                  value: selectedCountry,
                  decoration: const InputDecoration(
                    labelText: 'Country',
                    border: OutlineInputBorder(),
                  ),
                  items: countries.map((country) {
                    return DropdownMenuItem(
                      value: country,
                      child: Text(country),
                    );
                  }).toList(),
                  onChanged: (value) =>
                      ref.read(selectedCountryProvider.notifier).state = value,
                  validator: (v) =>
                      v == null ? 'Please select a country' : null,
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text('Error loading countries: $e'),
              ),
              const SizedBox(height: 16),
              PasswordTextField(
                controller: passwordCtrl,
                label: 'Password',
                hintText: 'Enter your password',
                validator: (v) =>
                    (v == null || v.length < 6) ? 'Min 6 characters' : null,
              ),
              const SizedBox(height: 16),
              PasswordTextField(
                controller: confirmCtrl,
                label: 'Confirm Password',
                hintText: 'Re-enter password',
                validator: (v) =>
                    v != passwordCtrl.text ? 'Passwords do not match' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
  icon: const Icon(Icons.check),
  label: Text(_isLoading ? 'Registering...' : 'Register'),
  onPressed: _isLoading ? null : _submit,
),
              
            ],
          ),
        ),
      ),
    );
  }
}
