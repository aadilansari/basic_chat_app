import 'package:basic_chat_app/core/localization/app_localization.dart';
import 'package:basic_chat_app/feature/chat/view/user_list_page.dart';
import 'package:basic_chat_app/feature/map/view/map_page.dart';
import 'package:basic_chat_app/feature/qr/widget/show_qr_page.dart';
import 'package:basic_chat_app/provider/bottom_nav_provider.dart';
import 'package:basic_chat_app/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainNavigationPage extends ConsumerStatefulWidget {
  const MainNavigationPage({super.key});

  @override
  ConsumerState<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends ConsumerState<MainNavigationPage> {
  late PageController _pageController;

  final List<Widget> _pages = [
    const UserListPage(), 
    MapPage(),
    ShowQrPage(),
    SettingsPage(), 
  ];

  

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    WidgetsBinding.instance.addPostFrameCallback((_) {
     ref.read(bottomNavProvider.notifier).state = 0;
  });
   
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(bottomNavProvider);
    final t = AppLocalizations.of(context);
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(
          context,
        ).bottomNavigationBarTheme.backgroundColor,
        selectedItemColor: Theme.of(
          context,
        ).bottomNavigationBarTheme.selectedItemColor,
        unselectedItemColor: Theme.of(
          context,
        ).bottomNavigationBarTheme.unselectedItemColor,
        currentIndex: currentIndex,
        onTap: (index) {
          ref.read(bottomNavProvider.notifier).state = index;
          _pageController.jumpToPage(index);
        },
        items:  [
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: t.translate('chat')),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: t.translate('map')),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: t.translate('qr')),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: t.translate('settings'),
          ),
        ],
      ),
    );
  }
}
