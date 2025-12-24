import 'dart:ui';
import 'package:flutter/material.dart';

class GlassBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  const GlassBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      margin: const EdgeInsets.all(10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
            ),
            child: BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: onTap,
              elevation: 0,
              backgroundColor: Colors.transparent,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white60,
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: true,
              showUnselectedLabels: false,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home, color: Colors.white),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search, color: Colors.white),
                  label: "Search",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings, color: Colors.white),
                  label: "Configuraciòn",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
