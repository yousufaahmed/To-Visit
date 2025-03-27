import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/country_model.dart';
import '../services/rest_countries_service.dart';
import '../widgets/country_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Country> allCountries = [];
  List<Country> filteredCountries = [];
  List<Country> popularCountries = [];
  List<Country> recentlyViewed = [];

  String searchQuery = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCountries();
    loadRecent();
  }

  Future<void> loadCountries() async {
    final countries = await RestCountriesService.fetchCountries();

    if (!mounted) return;

    // Hardcoded popular names
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

    // Match names with fallback to empty list if nothing found
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

  Future<void> loadRecent() async {
    final prefs = await SharedPreferences.getInstance();
    final recents = prefs.getStringList('recently_viewed') ?? [];

    if (!mounted) return;

    setState(() {
      recentlyViewed = recents.map((json) => Country.fromJsonString(json)).toList();
    });
  }

  void onSearch(String value) {
    setState(() {
      searchQuery = value;
      filteredCountries = allCountries
          .where((country) => country.name.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  void onCountryTapped(Country country) async {
    final prefs = await SharedPreferences.getInstance();
    final recentJsons = prefs.getStringList('recently_viewed') ?? [];

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
          // Search Bar
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

          if (searchQuery.isEmpty) ...[
            Text("Welcome back 👋", style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),

            // Popular Countries
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
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/all'),
                  child: const Text("View All Countries →"),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Recently Viewed
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
