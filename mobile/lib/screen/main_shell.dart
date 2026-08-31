import 'package:flutter/material.dart';
import 'package:saigon_tour_guide/screen/chatbot_screen.dart';
import 'package:saigon_tour_guide/screen/favorite_screen.dart';
import 'package:saigon_tour_guide/screen/home_screen.dart';
import 'package:saigon_tour_guide/screen/profile_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<StatefulWidget> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _idx = 0;
  static const List<Widget> _screens = [
    HomeScreen(),
    ChatbotScreen(),
    FavoritesScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _idx, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _idx,
        onDestinationSelected: (i) => setState(() => _idx = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            label: 'Trang chủ',
            selectedIcon: Icon(Icons.home),
          ),
          NavigationDestination(
            icon: Icon(Icons.smart_toy_outlined),
            label: 'Chat',
            selectedIcon: Icon(Icons.smart_toy),
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            label: 'Yêu thích',
            selectedIcon: Icon(Icons.favorite),
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline), 
            label: 'Hồ sơ',
            selectedIcon: Icon(Icons.person),
          ),
        ],
      ),
    );
  }
}
