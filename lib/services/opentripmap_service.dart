import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/place_model.dart';

/// Service to fetch popular places using the OpenTripMap API.
class OpenTripMapService {
  static const String apiKey = '5ae2e3f221c38a28845f05b6109a77130073edb016c2be35163b9145';
  static const String baseUrl = 'https://api.opentripmap.com/0.1/en/places';

  /// Estimates an appropriate radius (in metres) to search for attractions,
  /// based on the country name and its approximate geographic size.
  static int estimateRadiusKm(String countryName) {
    switch (countryName.toLowerCase()) {
      case 'russia':
      case 'canada':
      case 'china':
      case 'united states':
        return 100000;
      case 'australia':
      case 'brazil':
      case 'india':
      case 'kazakhstan':
      case 'argentina':
        return 80000;
      case 'france':
      case 'germany':
      case 'ukraine':
      case 'turkey':
        return 50000;
      default:
        return 30000; // default for smaller or unspecified countries
    }
  }

  /// Fetches a list of popular tourist places within a specified radius
  /// around the given [lat] and [lon] of the [countryName].
  static Future<List<Place>> getPopularPlaces(String countryName, double lat, double lon) async {
    final radius = estimateRadiusKm(countryName);

    // Construct the API URL for fetching POIs within a radius
    final radiusUrl = Uri.parse(
      "$baseUrl/radius?radius=$radius&lon=$lon&lat=$lat&rate=2&limit=15&format=json&apikey=$apiKey",
    );

    // Get list of POI XIDs
    final response = await http.get(radiusUrl);
    if (response.statusCode != 200) throw Exception('Failed to fetch places');
    final List data = jsonDecode(response.body);
    if (data.isEmpty) return [];

    final List<Place> places = [];

    // For each POI, fetch full details using XID
    for (var item in data) {
      final xid = item['xid'];
      if (xid == null) continue;

      final detailUrl = Uri.parse("$baseUrl/xid/$xid?apikey=$apiKey");
      final detailRes = await http.get(detailUrl);
      if (detailRes.statusCode != 200) continue;

      final detail = jsonDecode(detailRes.body);
      final name = detail['name'] ?? detail['address']?['attraction'] ?? 'Unknown';
      final desc = detail['wikipedia_extracts']?['text'] ??
                   detail['info']?['descr'] ??
                   'No description available';
      final lat = detail['point']?['lat'];
      final lon = detail['point']?['lon'];

      // Add place to list if it has valid coordinates
      if (lat != null && lon != null) {
        places.add(Place(
          title: name,
          summary: desc,
          lat: lat,
          lon: lon,
          imageUrl: detail['preview']?['source'], // optional: fetch image
        ));
      }
    }

    return places;
  }
}
