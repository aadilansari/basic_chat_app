import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localeProvider = StateProvider<Locale>((ref) => const Locale('en'));

void switchLanguage(WidgetRef ref) {
  final current = ref.read(localeProvider);
  final newLocale = current.languageCode == 'en' ? const Locale('ar') : const Locale('en');
  ref.read(localeProvider.notifier).state = newLocale;
}
