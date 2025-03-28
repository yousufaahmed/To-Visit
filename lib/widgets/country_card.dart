import 'package:flutter/material.dart';
import '../models/country_model.dart';
import '../screens/country_screen.dart';

/// A reusable card widget that displays basic information about a country.
/// When tapped, navigates to the detailed [CountryScreen] for that country.
class CountryCard extends StatelessWidget {
  final Country country;

  const CountryCard({super.key, required this.country});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 3, // Adds a subtle shadow to the card
      child: ListTile(
        // Country flag shown on the left
        leading: Image.network(
          country.flagUrl,
          width: 50,
          height: 30,
          fit: BoxFit.cover,
        ),
        // Country name shown as bold title
        title: Text(
          country.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        // Capital and region displayed as a subtitle
        subtitle: Text('${country.capital} • ${country.region}'),
        // Arrow icon on the right to indicate it's clickable
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        // On tap, navigate to CountryScreen with this country
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CountryScreen(country: country),
            ),
          );
        },
      ),
    );
  }
}
