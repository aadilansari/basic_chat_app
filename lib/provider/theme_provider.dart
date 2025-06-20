import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Theme Mode Provider: Light or Dark
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.light);

/// Toggle Theme
void toggleTheme(WidgetRef ref) {
  final current = ref.read(themeModeProvider);
  ref.read(themeModeProvider.notifier).state =
      current == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
}
