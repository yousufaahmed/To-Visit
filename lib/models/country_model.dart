
import 'dart:convert';

class Country {
  final String name;
  final String capital;
  final String region;
  final int population;
  final List<double> latlng;
  final String flagUrl;
  final String code;

  Country({
    required this.name,
    required this.capital,
    required this.region,
    required this.population,
    required this.latlng,
    required this.flagUrl,
    required this.code,
  });

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

  // Convert Country to JSON string for storage
  String toJsonString() => jsonEncode({
        'name': name,
        'capital': capital,
        'region': region,
        'population': population,
        'latlng': latlng,
        'flagUrl': flagUrl,
        'code': code,
      });

  // Convert back from JSON string
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
