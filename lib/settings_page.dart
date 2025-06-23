// ignore_for_file: use_build_context_synchronously

import 'package:basic_chat_app/core/localization/app_localization.dart';
import 'package:basic_chat_app/core/widgets/custom_appbar.dart';
import 'package:basic_chat_app/core/widgets/theme_toggle_button.dart';
import 'package:basic_chat_app/provider/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../feature/auth/view/login_page.dart';
import '../../../feature/auth/viewmodel/auth_viewmodel.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      appBar: CustomAppBar(title: t.translate('settings')),
      body: Center(
        child: Column(
          children: [
            ElevatedButton.icon(
              
              icon: const Icon(Icons.logout),
              label:  Text(t.translate('logout')),
              onPressed: () async {
                await ref.read(authProvider.notifier).logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (route) => false,
                );
              },
            ),
             ElevatedButton(
            onPressed: () => switchLanguage(ref),
            child: Text(t.translate('language')),
          ),
            ThemeToggleButton()
          ],
        ),
      ),
    );
  }
}
