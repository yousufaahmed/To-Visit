
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/country_model.dart';

class StorageService {
  static const _favsKey = 'favourite_countries';
  static const _notesPrefix = 'note_';

  static Future<void> setFavourite(Country country, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    final favs = prefs.getStringList(_favsKey) ?? [];

    favs.removeWhere((item) => Country.fromJsonString(item).name == country.name);

    if (value) {
      favs.add(country.toJsonString());
    }

    await prefs.setStringList(_favsKey, favs);
  }

  static Future<bool> isFavourite(String countryName) async {
    final prefs = await SharedPreferences.getInstance();
    final favs = prefs.getStringList(_favsKey) ?? [];
    return favs.any((json) => Country.fromJsonString(json).name == countryName);
  }

  static Future<List<Country>> getFavourites() async {
    final prefs = await SharedPreferences.getInstance();
    final favs = prefs.getStringList(_favsKey) ?? [];
    return favs.map((json) => Country.fromJsonString(json)).toList();
  }

  static Future<void> setNote(String countryName, String note) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('$_notesPrefix$countryName', note);
  }

  static Future<String> getNote(String countryName) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('$_notesPrefix$countryName') ?? '';
  }
}
