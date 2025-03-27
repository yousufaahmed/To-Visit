import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/favourites_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/all_countries_screen.dart';

class ToVisit extends StatelessWidget {
  const ToVisit({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Visit',
      themeMode: ThemeMode.system, // follow device setting
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/favourites': (context) => const FavouritesScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/all': (context) => const AllCountriesScreen(),
        // Detail screen will use Navigator.push with arguments
      },
    );
  }
}
