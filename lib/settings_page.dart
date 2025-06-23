// ignore_for_file: use_build_context_synchronously

import 'package:basic_chat_app/core/localization/app_localization.dart';
import 'package:basic_chat_app/core/widgets/custom_appbar.dart';
import 'package:basic_chat_app/core/widgets/theme_toggle_button.dart';
import 'package:basic_chat_app/provider/bottom_nav_provider.dart';
import 'package:basic_chat_app/provider/locale_provider.dart';
import 'package:basic_chat_app/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../feature/auth/view/login_page.dart';
import '../../../feature/auth/viewmodel/auth_viewmodel.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;
    final isArabic = ref.watch(localeProvider).languageCode == 'ar';

    return Scaffold(
      appBar: CustomAppBar(title: t.translate('settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // 🔄 Theme toggle
            SwitchListTile(
              title: Text(t.translate('dark_mode')),
              secondary: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
              value: isDark,
              onChanged: (value) {
                ref.read(themeModeProvider.notifier).state =
                    value ? ThemeMode.dark : ThemeMode.light;
              },
            ),
        
            // 🌐 Language toggle (example: English <-> Arabic)
            SwitchListTile(
              title: Text(t.translate('language')),
              secondary: const Icon(Icons.language),
              value: isArabic,
              onChanged: (value) {
                final newLocale = value ? const Locale('ar') : const Locale('en');
                ref.read(localeProvider.notifier).state = newLocale;
              },
            ),
        
            // 🔐 Logout action (shown with switch-style visual, but taps instead)
            ListTile(
              leading: const Icon(Icons.logout),
              title: Text(t.translate('logout')),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () async {
                await ref.read(authProvider.notifier).logout();
                ref.read(bottomNavProvider.notifier).state = 0;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
