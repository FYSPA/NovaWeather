import 'package:flutter/material.dart';
import 'package:wheatherapp/pages/home_page.dart';
import 'package:wheatherapp/pages/search_page.dart';
import 'package:wheatherapp/pages/user_page.dart';
import 'package:wheatherapp/widgets/navigation_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const SearchPage(),
    const UserPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              'assets/background/background.png',
              fit: BoxFit.cover,
            ),
          ),

          Positioned(
            top: 590,
            left: 0,
            right: 0,
            child: Image.asset('assets/background/house.png'),
          ),

          IndexedStack(index: _selectedIndex, children: _pages),
        ],
      ),

      bottomNavigationBar: GlassBottomNavigation(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
