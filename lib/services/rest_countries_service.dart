import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/country_model.dart';
import 'package:flutter/foundation.dart';

class RestCountriesService {
  // REST Countries API endpoint to get all countries
  static const String baseUrl = "https://restcountries.com/v3.1/all";

  /// Fetches country data from the REST Countries API.
  /// 
  /// Returns a list of [Country] objects.
  /// If the API call fails or throws an exception, it returns an empty list.
  static Future<List<Country>> fetchCountries() async {
    try {
      // Send GET request to the API
      final response = await http.get(Uri.parse(baseUrl));

      // If successful (HTTP 200 OK), parse the response body
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        // Convert each item in the JSON list into a Country model
        return data.map((json) => Country.fromJson(json)).toList();
      } else {
        // Handle non-200 responses by logging and returning an empty list
        debugPrint("❌ Failed to load countries: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      // Handle any exceptions (e.g. no internet, parsing error)
      debugPrint("❌ Exception fetching countries: $e");
      return [];
    }
  }
}
