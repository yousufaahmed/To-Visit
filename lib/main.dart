import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/main_navigation.dart';
import 'screens/country_screen.dart';
import 'theme/theme_provider.dart';
import 'models/country_model.dart';

void main() {
  runApp(const ToVisitApp());
}

class ToVisitApp extends StatelessWidget {
  const ToVisitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'ToVisit',
            themeMode: themeProvider.themeMode,
            theme: ThemeData.light(useMaterial3: true),
            darkTheme: ThemeData.dark(useMaterial3: true),
            home: const MainNavigation(),

            // ✅ Route handling for dynamic routes like /country
            onGenerateRoute: (settings) {
              if (settings.name == '/country') {
                final country = settings.arguments as Country;
                return MaterialPageRoute(
                  builder: (_) => CountryScreen(country: country),
                );
              }
              return null;
            },
          );
        },
      ),
    );
  }
}
