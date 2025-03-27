import 'package:shared_preferences/shared_preferences.dart';
import '../models/country_model.dart';

/// A utility class to handle storing and retrieving data locally
/// using SharedPreferences such as favourites and notes.
class StorageService {
  static const _favsKey = 'favourite_countries';  // Key to store list of favourite countries
  static const _notesPrefix = 'note_';            // Prefix used to store individual notes per country

  /// Save or remove a country from favourites.
  /// [value] is true to add, false to remove.
  static Future<void> setFavourite(Country country, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    final favs = prefs.getStringList(_favsKey) ?? [];

    // Remove any existing entry with the same country name
    favs.removeWhere((item) => Country.fromJsonString(item).name == country.name);

    // If value is true, add the country to favourites
    if (value) {
      favs.add(country.toJsonString());
    }

    // Save updated list
    await prefs.setStringList(_favsKey, favs);
  }

  /// Check if a country is currently marked as favourite.
  static Future<bool> isFavourite(String countryName) async {
    final prefs = await SharedPreferences.getInstance();
    final favs = prefs.getStringList(_favsKey) ?? [];
    return favs.any((json) => Country.fromJsonString(json).name == countryName);
  }

  /// Get a list of all favourite countries.
  static Future<List<Country>> getFavourites() async {
    final prefs = await SharedPreferences.getInstance();
    final favs = prefs.getStringList(_favsKey) ?? [];
    return favs.map((json) => Country.fromJsonString(json)).toList();
  }

  /// Save a note for a given country.
  static Future<void> setNote(String countryName, String note) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('$_notesPrefix$countryName', note);
  }

  /// Retrieve a saved note for a given country.
  static Future<String> getNote(String countryName) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('$_notesPrefix$countryName') ?? '';
  }
}
