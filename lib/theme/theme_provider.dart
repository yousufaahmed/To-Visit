import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A ChangeNotifier that manages the app's theme (light/dark mode)
/// and persists user preference using SharedPreferences.
class ThemeProvider extends ChangeNotifier {
  // Holds the current theme mode (light/dark/system)
  ThemeMode _themeMode = ThemeMode.system;

  // Expose the current theme mode to the app
  ThemeMode get themeMode => _themeMode;

  // Constructor - loads the saved theme preference when the provider is created
  ThemeProvider() {
    loadTheme();
  }

  /// Loads the theme preference from SharedPreferences.
  /// If no preference is found, defaults to following the system theme.
  void loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('dark_mode');

    // Set the theme mode based on stored value
    _themeMode = isDark == null
        ? ThemeMode.system
        : (isDark ? ThemeMode.dark : ThemeMode.light);

    notifyListeners(); // Notify UI to rebuild based on new theme
  }

  /// Toggles the theme mode and saves the preference.
  /// [isDark] indicates whether dark mode is enabled.
  void toggleTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();

    // Save the user's preference
    await prefs.setBool('dark_mode', isDark);

    // Update internal theme state
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;

    notifyListeners(); // Update any listeners (e.g., MaterialApp)
  }
}
