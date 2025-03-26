import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/place_model.dart';

class WikiPlacesService {
  static Future<List<Place>> getTopPlaces(String countryName) async {
    try {
      final searchQuery = "Tourist attractions in $countryName";
      final url = Uri.parse(
        'https://en.wikipedia.org/w/api.php?action=query&format=json&list=search&srsearch=$searchQuery&srlimit=5',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final searchResults = data['query']['search'] as List<dynamic>;

        // Fetch details for each result (summary + geo)
        List<Place> places = [];

        for (var result in searchResults) {
          final title = result['title'];
          final summary = result['snippet'].replaceAll(RegExp(r'<[^>]*>'), '');

          final geoUrl = Uri.parse(
              'https://en.wikipedia.org/w/api.php?action=query&format=json&prop=coordinates&titles=${Uri.encodeComponent(title)}');

          final geoRes = await http.get(geoUrl);
          final geoData = jsonDecode(geoRes.body);
          final pages = geoData['query']['pages'];
          final page = pages.values.first;
          final coords = page['coordinates']?[0];

          final double lat = coords?['lat'] ?? 0.0;
          final double lon = coords?['lon'] ?? 0.0;

          places.add(Place(
            title: title,
            summary: summary,
            lat: lat,
            lon: lon,
          ));
        }

        return places;
      } else {
        throw Exception("Failed to load places");
      }
    } catch (e) {
      print("Error fetching wiki places: $e");
      return [];
    }
  }
}
