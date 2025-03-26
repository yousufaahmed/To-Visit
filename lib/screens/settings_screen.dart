import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    loadThemePreference();
  }

  Future<void> loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final dark = prefs.getBool('dark_mode') ?? false;
    setState(() => isDarkMode = dark);
  }

  Future<void> toggleTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    themeProvider.toggleTheme(value);
    setState(() => isDarkMode = value);

  }

  Future<void> clearAllUserData() async {
    final prefs = await SharedPreferences.getInstance();

    // Remove favourites and recents
    await prefs.remove('favourite_countries');
    await prefs.remove('recently_viewed');

    // Remove all notes
    final keys = prefs.getKeys();
    for (var key in keys) {
      if (key.startsWith('note_')) {
        await prefs.remove(key);
      }
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("All data cleared.")),
    );
  }

  void showClearDataDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Clear All Data?"),
        content: const Text("This will remove all your favourites, notes, and history."),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text("Clear"),
            onPressed: () {
              Navigator.pop(context);
              clearAllUserData();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Match device theme by default'),
            value: isDarkMode,
            onChanged: toggleTheme,
          ),
          const Divider(),
          const ListTile(
            title: Text('Data Usage & GDPR'),
            subtitle: Text(
              'This app stores data like favourites and notes locally on your device. No data is shared externally.',
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.delete_forever),
            title: const Text("Clear All Data"),
            subtitle: const Text("Favourites, notes, and recently viewed"),
            onTap: showClearDataDialog,
          ),
        ],
      ),
    );
  }
}
