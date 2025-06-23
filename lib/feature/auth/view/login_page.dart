import 'package:basic_chat_app/core/localization/app_localization.dart';
import 'package:basic_chat_app/core/widgets/custom_textfield.dart';
import 'package:basic_chat_app/core/widgets/password_textfield.dart';
import 'package:basic_chat_app/feature/auth/view/register_page.dart';
import 'package:basic_chat_app/feature/auth/viewmodel/auth_viewmodel.dart';
import 'package:basic_chat_app/main_navigation_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';



class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final email = emailCtrl.text.trim();
    final password = passwordCtrl.text.trim();
    final fcmToken = await FirebaseMessaging.instance.getToken();

    try {
      await ref
          .read(authProvider.notifier)
          .loginWithEmailPassword(
            email: email,
            password: password,
            fcmToken: fcmToken ?? '',
          );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_email', email);

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigationPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
     final t = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: const Color(0xffF6F7FB),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Image section (replace with your own asset)
                  Image.asset(
                    'assets/icon/icon.png',
                    height: 120,
                  ),
              
                  const SizedBox(height: 24),
              
                   Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                     t.translate('login'),
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Please sign in to continue.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 24),
              
                 CustomTextField(
                              controller: emailCtrl,
                              label: t.translate('email'),
                              hintText: t.translate('enter_your_email'),
                              keyboardType: TextInputType.emailAddress,
                              icon: Icons.email,
                              validator: (value) =>
                                  (value == null || !value.contains('@'))
                                  ? t.translate('invalid_email')
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            PasswordTextField(
                              controller: passwordCtrl,
                              label: t.translate('password'),
                              hintText: t.translate('enter_your_password'),
                              validator: (value) =>
                                  (value == null || value.length < 6)
                                  ? t.translate('min_6_characters')
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
                                  ? const CircularProgressIndicator()
                                  : Text(t.translate('login'), style: TextStyle(color: Colors.white),),
                    ),
                  ),
              
                  const SizedBox(height: 16),
              
                  // Sign up text
                  GestureDetector(
                      onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterPage()),
                  );
                },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:  [
                       
                        Text(
                          t.translate('dont_have_account'),
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
