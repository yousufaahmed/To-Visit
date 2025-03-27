import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/main_navigation.dart';
import 'screens/country_screen.dart';
import 'screens/all_countries_screen.dart';
import 'theme/theme_provider.dart';
import 'models/country_model.dart';

void main() {
  runApp(const ToVisitApp()); // Entry point of the app
}

class ToVisitApp extends StatelessWidget {
  const ToVisitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // Provide ThemeProvider to the entire app
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'ToVisit',
            debugShowCheckedModeBanner: false,

            // Set light and dark themes using Material 3
            theme: ThemeData(
              brightness: Brightness.light,
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                brightness: Brightness.dark,
              ),
            ),
            themeMode: themeProvider.themeMode, // Set current theme mode (system, light, or dark)

            // Main navigation layout with bottom tabs
            home: const MainNavigation(),

            // Define dynamic route generation
            onGenerateRoute: (settings) {
              if (settings.name == '/country') {
                final country = settings.arguments as Country;
                return MaterialPageRoute(
                  builder: (_) => CountryScreen(country: country),
                );
              } else if (settings.name == '/all') {
                return MaterialPageRoute(
                  builder: (_) => const AllCountriesScreen(),
                );
              }
              return null; // Unknown route fallback
            },
          );
        },
      ),
    );
  }
}
