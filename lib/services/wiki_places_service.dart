import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/place_model.dart';
import 'package:flutter/foundation.dart';

/// A service that retrieves top tourist places for a given country
/// using the Wikipedia API.
class WikiPlacesService {
  /// Fetches a list of top tourist attractions in the [countryName].
  /// It searches Wikipedia for articles and attempts to extract coordinates.
  static Future<List<Place>> getTopPlaces(String countryName) async {
    try {
      final searchQuery = "Tourist attractions in $countryName";

      // Construct the Wikipedia search URL
      final url = Uri.parse(
        'https://en.wikipedia.org/w/api.php?action=query&format=json&list=search&srsearch=$searchQuery&srlimit=5',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Parse the list of search results
        final searchResults = data['query']['search'] as List<dynamic>;
        List<Place> places = [];

        // For each search result, fetch coordinates and summary
        for (var result in searchResults) {
          final title = result['title'];

          // Remove HTML tags from Wikipedia snippets
          final summary = result['snippet'].replaceAll(RegExp(r'<[^>]*>'), '');

          // Construct a query to get coordinates for this page
          final geoUrl = Uri.parse(
            'https://en.wikipedia.org/w/api.php?action=query&format=json&prop=coordinates&titles=${Uri.encodeComponent(title)}',
          );

          final geoRes = await http.get(geoUrl);
          final geoData = jsonDecode(geoRes.body);

          // Extract coordinates if they exist
          final pages = geoData['query']['pages'];
          final page = pages.values.first;
          final coords = page['coordinates']?[0];

          final double lat = coords?['lat'] ?? 0.0;
          final double lon = coords?['lon'] ?? 0.0;

          // Add the place to the list
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
      debugPrint("❌ Error fetching wiki places: $e");
      return [];
    }
  }
}
