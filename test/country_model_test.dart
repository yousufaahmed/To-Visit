import 'package:flutter_test/flutter_test.dart';
import 'package:to_visit/models/country_model.dart';

void main() {
  test('Country model parses from JSON correctly', () {
    final json = {
      'name': {'common': 'France'},
      'capital': ['Paris'],
      'region': 'Europe',
      'population': 67000000,
      'latlng': [46.0, 2.0],
      'flags': {'png': 'https://flagcdn.com/fr.png'},
    };

    final country = Country.fromJson(json);

    expect(country.name, 'France');
    expect(country.capital, 'Paris');
    expect(country.region, 'Europe');
    expect(country.population, 67000000);
    expect(country.latlng, [46.0, 2.0]);
    expect(country.flagUrl, 'https://flagcdn.com/fr.png');
  });
}
