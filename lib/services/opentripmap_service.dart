
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/place_model.dart';

class OpenTripMapService {
  static const String apiKey = '5ae2e3f221c38a28845f05b6109a77130073edb016c2be35163b9145'; // Replace with your key
  static const String baseUrl = 'https://api.opentripmap.com/0.1/en/places';

  // Dynamically adjust radius based on approximate country size
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
        return 30000; // fallback for small-medium countries
    }
  }

  static Future<List<Place>> getPopularPlaces(String countryName, double lat, double lon) async {
    final radius = estimateRadiusKm(countryName);

    final radiusUrl = Uri.parse(
      "$baseUrl/radius?radius=$radius&lon=$lon&lat=$lat&rate=2&limit=15&format=json&apikey=$apiKey",
    );

    final response = await http.get(radiusUrl);
    if (response.statusCode != 200) throw Exception('Failed to fetch places');

    final List data = jsonDecode(response.body);
    if (data.isEmpty) return [];

    final List<Place> places = [];

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

      if (lat != null && lon != null) {
        places.add(Place(
          title: name,
          summary: desc,
          lat: lat,
          lon: lon,
        ));
      }
    }

    return places;
  }
}
