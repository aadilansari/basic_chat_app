import 'package:basic_chat_app/core/localization/app_localization.dart';
import 'package:basic_chat_app/data/services/background_message_handler.dart';
import 'package:basic_chat_app/data/services/notification_service.dart';
import 'package:basic_chat_app/feature/auth/view/login_page.dart';
import 'package:basic_chat_app/feature/auth/viewmodel/auth_viewmodel.dart';
import 'package:basic_chat_app/main_navigation_page.dart';
import 'package:basic_chat_app/provider/locale_provider.dart';
import 'package:basic_chat_app/provider/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
 FirebaseMessaging.onBackgroundMessage(firebaseBackgroundMessageHandler);
  await _setupNotifications();
// initializeLocalNotifications();
  runApp(const ProviderScope(child: MyApp()));
}

Future<void> _setupNotifications() async {
  final messaging = FirebaseMessaging.instance;

  // ask permission once
  final settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );
  debugPrint('Notification permission: ${settings.authorizationStatus}');
  debugPrint('🔑 FCM Token: ${await messaging.getToken()}');

  // register the two handlers **once**
  FirebaseMessaging.onMessage.listen(NotificationService.onForeground);
  FirebaseMessaging.onMessageOpenedApp.listen(NotificationService.onTap);
}



final GlobalKey<NavigatorState> globalNavigatorKey = GlobalKey<NavigatorState>();

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //    ref.read(notificationProvider).initialize();
  //   ref.read(notificationProvider).setupForegroundListener();
  // });
   
    return MaterialApp(
      title: 'Chat App',
       navigatorKey: globalNavigatorKey,
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
     home: ref.watch(authProvider) != null
    ? const MainNavigationPage()
    : const LoginPage(),

      debugShowCheckedModeBanner: false,
    );
  }
}
