// ignore_for_file: use_build_context_synchronously

import 'package:basic_chat_app/core/localization/app_localization.dart';
import 'package:basic_chat_app/core/widgets/custom_appbar.dart';
import 'package:basic_chat_app/core/widgets/custom_textfield.dart';
import 'package:basic_chat_app/core/widgets/password_textfield.dart';
import 'package:basic_chat_app/data/models/user_model.dart';
import 'package:basic_chat_app/feature/auth/viewmodel/auth_viewmodel.dart';
import 'package:basic_chat_app/main_navigation_page.dart';
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
        MaterialPageRoute(builder: (_) => const MainNavigationPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final countryListAsync = ref.watch(countryListProvider);
    final selectedCountry = ref.watch(selectedCountryProvider);
final t = AppLocalizations.of(context);
    return Scaffold(
  appBar: CustomAppBar(
    title: t.translate("back"),
  ),
  body: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24.0),
    child: SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        child: IntrinsicHeight(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
               Image.asset(
                      'assets/icon/icon.png',
                      height: 120,
                    ),
                
                    const SizedBox(height: 24),
                       Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                       t.translate('register'),
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                 const SizedBox(height: 24),
                 
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: emailCtrl,
                      label: t.translate('email'),
                      hintText: t.translate('enter_your_email'),
                      keyboardType: TextInputType.emailAddress,
                      icon: Icons.email,
                      validator: (v) => (v == null || !v.contains('@'))
                          ? t.translate('invalid_email')
                          : null,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: nameCtrl,
                      label: t.translate('name'),
                      hintText: t.translate('enter_your_name'),
                      icon: Icons.person,
                      validator: (v) => (v == null || v.isEmpty)
                          ? t.translate('name_required')
                          : null,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: phoneCtrl,
                      label: t.translate('phone'),
                      hintText: t.translate('enter_your_phone'),
                      keyboardType: TextInputType.phone,
                      icon: Icons.phone,
                      validator: (v) => (v == null || v.isEmpty)
                          ? t.translate('phone_required')
                          : null,
                    ),
                    const SizedBox(height: 16),
                    countryListAsync.when(
                      data: (countries) => DropdownButtonFormField<String>(
                        value: selectedCountry,
                        decoration: InputDecoration(
                          labelText: t.translate('country'),
                          border: const OutlineInputBorder(),
                        ),
                        items: countries.map((country) {
                          return DropdownMenuItem(
                            value: country,
                            child: Text(country),
                          );
                        }).toList(),
                        onChanged: (value) => ref
                            .read(selectedCountryProvider.notifier)
                            .state = value,
                        validator: (v) => v == null
                            ? t.translate('select_country')
                            : null,
                      ),
                      loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      error: (e, _) => Text(
                        "${t.translate('country_load_error')}: $e",
                      ),
                    ),
                    const SizedBox(height: 16),
                    PasswordTextField(
                      controller: passwordCtrl,
                      label: t.translate('password'),
                      hintText: t.translate('enter_your_password'),
                      validator: (v) => (v == null || v.length < 6)
                          ? t.translate('min_6_characters')
                          : null,
                    ),
                    const SizedBox(height: 16),
                    PasswordTextField(
                      controller: confirmCtrl,
                      label: t.translate('confirm_password'),
                      hintText: t.translate('reenter_password'),
                      validator: (v) => v != passwordCtrl.text
                          ? t.translate('passwords_do_not_match')
                          : null,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                     onPressed: _isLoading ? null : _submit,
                      child: _isLoading
                                  ? Text(t.translate('registering'), style: TextStyle(color: Colors.white),)
                                  : Text(t.translate('register'), style: TextStyle(color: Colors.white),),
                    ),
                  ),
                   
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  ),
);

  }
}
