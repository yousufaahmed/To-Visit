class Place {
  final String title;
  final String summary;
  final double lat;
  final double lon;

  Place({required this.title, required this.summary, required this.lat, required this.lon});

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      title: json['title'],
      summary: json['summary'],
      lat: json['lat'],
      lon: json['lon'],
    );
  }
}
