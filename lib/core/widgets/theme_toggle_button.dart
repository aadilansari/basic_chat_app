import 'package:basic_chat_app/core/localization/app_localization.dart';
import 'package:basic_chat_app/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeToggleButton extends ConsumerWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;
    final t = AppLocalizations.of(context);

    return ElevatedButton.icon(
      icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
      label: Text(t.translate('dark_mode')),
      onPressed: () => toggleTheme(ref),
    );
  }

  void toggleTheme(WidgetRef ref) {
    final currentTheme = ref.read(themeModeProvider);
    ref.read(themeModeProvider.notifier).state = 
        currentTheme == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
  }
}