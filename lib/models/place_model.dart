class Place {
  final String title;
  final String summary;
  final double lat;
  final double lon;
  final String? imageUrl;

  Place({
    required this.title,
    required this.summary,
    required this.lat,
    required this.lon,
    this.imageUrl,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      title: json['title'],
      summary: json['summary'],
      lat: json['lat'],
      lon: json['lon'],
      imageUrl: json['imageUrl'],
    );
  }

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
