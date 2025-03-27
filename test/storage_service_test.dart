import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_visit/models/country_model.dart';
import 'package:to_visit/services/storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Dummy country instance
  final mockCountry = Country(
    name: 'France',
    capital: 'Paris',
    region: 'Europe',
    population: 67000000,
    latlng: [46.0, 2.0],
    flagUrl: 'https://flagcdn.com/fr.png',
    code: 'FR',
  );

  group('StorageService', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('can save and retrieve a note', () async {
      await StorageService.setNote(mockCountry.name, 'Visit Eiffel Tower');
      final note = await StorageService.getNote(mockCountry.name);
      expect(note, 'Visit Eiffel Tower');
    });

    test('can set and check favourite', () async {
      await StorageService.setFavourite(mockCountry, true);
      final fav = await StorageService.isFavourite(mockCountry.name);
      expect(fav, true);
    });
  });
}
