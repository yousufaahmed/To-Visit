/// A model representing a point of interest (POI) or place in a country.
class Place {
  final String title;        // Name or title of the place
  final String summary;      // Short description or summary of the place
  final double lat;          // Latitude coordinate
  final double lon;          // Longitude coordinate
  final String? imageUrl;    // Optional image URL representing the place

  Place({
    required this.title,
    required this.summary,
    required this.lat,
    required this.lon,
    this.imageUrl,
  });

  /// Creates a Place object from a JSON map (e.g., from API or local storage).
  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      title: json['title'],
      summary: json['summary'],
      lat: json['lat'],
      lon: json['lon'],
      imageUrl: json['imageUrl'], // This can be null
    );
  }

  /// Converts the Place object into a JSON map for storage or transfer.
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'summary': summary,
      'lat': lat,
      'lon': lon,
      'imageUrl': imageUrl,
    };
  }
}
