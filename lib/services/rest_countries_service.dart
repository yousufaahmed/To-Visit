import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/country_model.dart';

class RestCountriesService {
  static const String baseUrl = "https://restcountries.com/v3.1/all";

  static Future<List<Country>> fetchCountries() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      // Convert each JSON object into a Country instance
      return data.map((json) => Country.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load countries");
    }
  }
}
