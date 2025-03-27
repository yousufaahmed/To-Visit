import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/country_model.dart';
import 'package:flutter/foundation.dart';

class RestCountriesService {
  static const String baseUrl = "https://restcountries.com/v3.1/all";

  static Future<List<Country>> fetchCountries() async {
  try {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Country.fromJson(json)).toList();
    } else {
      debugPrint("❌ Failed to load countries: ${response.statusCode}");
      return [];
    }
  } catch (e) {
    debugPrint("❌ Exception fetching countries: $e");
    return [];
  }
}

}
