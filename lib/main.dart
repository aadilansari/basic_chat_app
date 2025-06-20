import 'package:basic_chat_app/core/localization/app_localization.dart';
import 'package:basic_chat_app/provider/locale_provider.dart';
import 'package:basic_chat_app/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp(
      title: 'Chat App',
      locale: locale,
      supportedLocales: const [Locale('en'), Locale('ar')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate, 
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: const ThemeTogglePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ThemeTogglePage extends ConsumerWidget {
  const ThemeTogglePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;
    final t = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(t.translate('app_title'))),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton.icon(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            label: Text(t.translate('dark_mode')),
            onPressed: () => toggleTheme(ref),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => switchLanguage(ref),
            child: Text(t.translate('language')),
          ),
        ],
      ),
    );
  }
}
