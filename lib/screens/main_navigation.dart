import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'favourites_screen.dart';
import 'settings_screen.dart';

/// MainNavigation sets up the bottom navigation structure for the app.
/// It allows users to switch between Home, Favourites, and Settings pages.
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int currentIndex = 0; // Keeps track of the currently selected tab

  // List of screens to navigate between
  final List<Widget> screens = const [
    HomeScreen(),
    FavouritesScreen(),
    SettingsScreen(),
  ];

  // Titles for each screen, used in AppBar
  final List<String> titles = ['To-Visit', 'Favourites', 'Settings'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar updates title based on selected tab
      appBar: AppBar(
        title: Text(titles[currentIndex]),
      ),

      // Display the selected screen
      body: screens[currentIndex],

      // Bottom navigation bar with 3 tabs
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (value) => setState(() => currentIndex = value),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.public), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favourites'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
