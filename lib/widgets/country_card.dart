import 'package:flutter/material.dart';
import '../models/country_model.dart';
import '../screens/country_screen.dart';

class CountryCard extends StatelessWidget {
  final Country country;

  const CountryCard({super.key, required this.country});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 3,
      child: ListTile(
        leading: Image.network(country.flagUrl, width: 50, height: 30, fit: BoxFit.cover),
        title: Text(country.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${country.capital} • ${country.region}'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
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
