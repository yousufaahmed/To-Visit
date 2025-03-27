import 'package:flutter/material.dart';
import '../models/country_model.dart';
import '../services/storage_service.dart';
import '../widgets/country_card.dart';

/// Screen that displays all favourite countries saved by the user.
class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  List<Country> favouriteCountries = []; // List of saved favourite countries

  @override
  void initState() {
    super.initState();
    loadFavourites(); // Load favourites on screen init
  }

  /// Retrieves favourites from storage and updates the UI.
  Future<void> loadFavourites() async {
    final favs = await StorageService.getFavourites();
    if (!mounted) return;
    setState(() {
      favouriteCountries = favs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Optional AppBar if you want to show screen title
      // appBar: AppBar(title: const Text('Favourite Countries')),

      // Show message if no favourites, otherwise show a list of favourite countries
      body: favouriteCountries.isEmpty
          ? const Center(child: Text('No favourites yet.'))
          : ListView.builder(
              itemCount: favouriteCountries.length,
              itemBuilder: (context, index) {
                final country = favouriteCountries[index];
                return CountryCard(country: country); // Reuse CountryCard widget
              },
            ),
    );
  }
}
