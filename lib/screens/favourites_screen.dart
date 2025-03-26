
import 'package:flutter/material.dart';
import '../models/country_model.dart';
import '../services/storage_service.dart';
import '../widgets/country_card.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  List<Country> favouriteCountries = [];

  @override
  void initState() {
    super.initState();
    loadFavourites();
  }

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
      appBar: AppBar(title: const Text('Favourite Countries')),
      body: favouriteCountries.isEmpty
          ? const Center(child: Text('No favourites yet.'))
          : ListView.builder(
              itemCount: favouriteCountries.length,
              itemBuilder: (context, index) {
                final country = favouriteCountries[index];
                return CountryCard(country: country);
              },
            ),
    );
  }
}
