import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/country_model.dart';
import '../services/rest_countries_service.dart';
import '../widgets/country_card.dart';

/// Home screen that shows search, popular countries, and recently viewed countries.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Country> allCountries = [];         // Complete list of countries from API
  List<Country> filteredCountries = [];    // Filtered countries for search
  List<Country> popularCountries = [];     // Hardcoded popular countries list
  List<Country> recentlyViewed = [];       // Countries saved to shared preferences

  String searchQuery = '';
  bool isLoading = true;                   // Indicates loading state for countries

  @override
  void initState() {
    super.initState();
    loadCountries(); // Load all countries from API
    loadRecent();    // Load recent countries from local storage
  }

  /// Fetch all countries and filter to get popular ones
  Future<void> loadCountries() async {
    final countries = await RestCountriesService.fetchCountries();

    if (!mounted) return;

    // Manually defined list of popular countries
    final popularNames = [
      'France',
      'Italy',
      'Spain',
      'Japan',
      'United Kingdom',
      'Turkey',
      'Thailand',
      'Germany',
      'Australia',
    ];

    // Try to match each popular country by name
    final sortedPopular = countries.isEmpty
        ? <Country>[]
        : popularNames.map((name) {
            try {
              return countries.firstWhere(
                (c) => c.name.toLowerCase().contains(name.toLowerCase()),
              );
            } catch (e) {
              return null;
            }
          }).whereType<Country>().toList();

    countries.sort((a, b) => a.name.compareTo(b.name));

    setState(() {
      allCountries = countries;
      filteredCountries = countries;
      popularCountries = sortedPopular;
      isLoading = false;
    });
  }

  /// Load recently viewed countries from shared preferences
  Future<void> loadRecent() async {
    final prefs = await SharedPreferences.getInstance();
    final recents = prefs.getStringList('recently_viewed') ?? [];

    if (!mounted) return;

    setState(() {
      recentlyViewed = recents.map((json) => Country.fromJsonString(json)).toList();
    });
  }

  /// Filter countries based on search query
  void onSearch(String value) {
    setState(() {
      searchQuery = value;
      filteredCountries = allCountries
          .where((country) => country.name.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  /// Save country to recents and navigate to detail screen
  void onCountryTapped(Country country) async {
    final prefs = await SharedPreferences.getInstance();
    final recentJsons = prefs.getStringList('recently_viewed') ?? [];

    // Avoid duplicates and limit to 5
    recentJsons.removeWhere((item) => Country.fromJsonString(item).name == country.name);
    recentJsons.insert(0, country.toJsonString());
    if (recentJsons.length > 5) recentJsons.removeLast();
    await prefs.setStringList('recently_viewed', recentJsons);

    if (!mounted) return;

    Navigator.pushNamed(context, '/country', arguments: country);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search input
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

          // If searching, show filtered results
          if (searchQuery.isNotEmpty) ...[
            Text("Search Results", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            if (filteredCountries.isEmpty)
              const Text("No countries found.")
            else
              Column(
                children: filteredCountries
                    .map((country) => GestureDetector(
                          onTap: () => onCountryTapped(country),
                          child: CountryCard(country: country),
                        ))
                    .toList(),
              ),
          ],

          // If not searching, show welcome, popular, and recent
          if (searchQuery.isEmpty) ...[
            Text("Welcome back 👋", style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),

            // Popular countries horizontal scroll
            if (popularCountries.isNotEmpty) ...[
              Text("Popular countries", style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              SizedBox(
                height: 100,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: popularCountries.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final country = popularCountries[index];
                    return GestureDetector(
                      onTap: () => onCountryTapped(country),
                      child: Container(
                        width: 120,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network(country.flagUrl, height: 40),
                            const SizedBox(height: 8),
                            Text(
                              country.name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),

              // Button to view all countries
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/all'),
                  child: const Text("View All Countries →"),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Recently viewed list
            if (recentlyViewed.isNotEmpty) ...[
              Text("Recently viewed", style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Column(
                children: recentlyViewed
                    .map((country) => GestureDetector(
                          onTap: () => onCountryTapped(country),
                          child: CountryCard(country: country),
                        ))
                    .toList(),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
