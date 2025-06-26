import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'home_screen.dart';
import 'aniversarios_screen.dart';
import 'opcoes_screen.dart';
import 'dev_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const AniversariosScreen(),
    const OpcoesScreen(),
    const DevScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: const Color.fromARGB(255, 44, 59, 47),
        activeColor: Colors.white,
        // inactiveColor: Colors.white70,
        style: TabStyle.react,
        items: [
          TabItem(icon: Icons.home, title: 'APP_ICO_HOME'.tr()),
          TabItem(icon: Icons.cake, title: 'APP_ICO_ANIV'.tr()),
          TabItem(icon: Icons.settings, title: 'APP_ICO_OPCS'.tr()),
          TabItem(icon: Icons.info, title: 'APP_ICO_DEV'.tr()),
        ],
        initialActiveIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
