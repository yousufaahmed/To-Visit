import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/country_model.dart';
import '../services/rest_countries_service.dart';
import '../widgets/country_card.dart';

/// Screen displaying a searchable, scrollable list of all countries.
class AllCountriesScreen extends StatefulWidget {
  const AllCountriesScreen({super.key});

  @override
  State<AllCountriesScreen> createState() => _AllCountriesScreenState();
}

class _AllCountriesScreenState extends State<AllCountriesScreen> {
  List<Country> allCountries = [];         // Full list of countries fetched from API
  List<Country> filteredCountries = [];    // List filtered by search
  String searchQuery = '';                 // Current search input

  @override
  void initState() {
    super.initState();
    loadCountries(); // Fetch country data when screen loads
  }

  /// Fetches all countries from the API, sorts them, and updates state
  Future<void> loadCountries() async {
    final countries = await RestCountriesService.fetchCountries();
    countries.sort((a, b) => a.name.compareTo(b.name)); // Alphabetical
    if (!mounted) return;
    setState(() {
      allCountries = countries;
      filteredCountries = countries;
    });
  }

  /// Filters country list based on search input
  void onSearch(String value) {
    setState(() {
      searchQuery = value;
      filteredCountries = allCountries
          .where((c) => c.name.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  /// Handles tapping a country card — saves to recently viewed and navigates
  void onCountryTapped(Country country) async {
    final prefs = await SharedPreferences.getInstance();
    final recents = prefs.getStringList('recently_viewed') ?? [];

    recents.removeWhere((item) => Country.fromJsonString(item).name == country.name);
    recents.insert(0, country.toJsonString());
    if (recents.length > 5) recents.removeLast();

    await prefs.setStringList('recently_viewed', recents);
    if (!mounted) return;

    Navigator.pushNamed(context, '/country', arguments: country);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Countries")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search bar input
            TextField(
              onChanged: onSearch,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "Search countries...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
              ),
            ),
            const SizedBox(height: 16),

            // List of countries
            Expanded(
              child: filteredCountries.isEmpty
                  ? const Center(child: Text("No countries found."))
                  : ListView.builder(
                      itemCount: filteredCountries.length,
                      itemBuilder: (context, index) {
                        final country = filteredCountries[index];
                        return GestureDetector(
                          onTap: () => onCountryTapped(country),
                          child: CountryCard(country: country),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
