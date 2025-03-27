import 'dart:convert';

/// A model representing a country and its relevant data for display and storage.
class Country {
  final String name;          // Common name of the country
  final String capital;       // Capital city
  final String region;        // Geographical region (e.g. Europe, Asia)
  final int population;       // Population count
  final List<double> latlng;  // Latitude and longitude coordinates
  final String flagUrl;       // URL to the country's flag image (PNG format)
  final String code;          // Country code (e.g. "FR" for France)

  Country({
    required this.name,
    required this.capital,
    required this.region,
    required this.population,
    required this.latlng,
    required this.flagUrl,
    required this.code,
  });

  /// Factory constructor to create a Country instance from the REST Countries API JSON.
  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['name']['common'] ?? 'N/A',
      capital: (json['capital'] != null && json['capital'].isNotEmpty)
          ? json['capital'][0]
          : 'N/A',
      region: json['region'] ?? 'N/A',
      population: json['population'] ?? 0,
      latlng: json['latlng'] != null
          ? List<double>.from(json['latlng'])
          : [0.0, 0.0],
      flagUrl: json['flags']?['png'] ?? '',
      code: json['cca2'] ?? '',
    );
  }

  /// Serialises the Country object into a JSON string for storage (e.g. SharedPreferences).
  String toJsonString() => jsonEncode({
        'name': name,
        'capital': capital,
        'region': region,
        'population': population,
        'latlng': latlng,
        'flagUrl': flagUrl,
        'code': code,
      });

  /// Factory constructor to recreate a Country object from a stored JSON string.
  factory Country.fromJsonString(String jsonStr) {
    final data = jsonDecode(jsonStr);
    return Country(
      name: data['name'],
      capital: data['capital'],
      region: data['region'],
      population: data['population'],
      latlng: List<double>.from(data['latlng']),
      flagUrl: data['flagUrl'],
      code: data['code'],
    );
  }
}
