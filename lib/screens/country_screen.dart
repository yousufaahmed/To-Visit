
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/country_model.dart';
import '../models/place_model.dart';
import '../services/storage_service.dart';
import '../services/opentripmap_service.dart';
import '../widgets/place_card.dart';

class CountryScreen extends StatefulWidget {
  final Country country;

  const CountryScreen({super.key, required this.country});

  @override
  State<CountryScreen> createState() => _CountryDetailScreenState();
}

class _CountryDetailScreenState extends State<CountryScreen> {
  bool isFavourite = false;
  String userNote = '';
  List<Place> places = [];

  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> placeKeys = {};
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    saveToRecentlyViewed();
    loadData();
  }

  Future<void> saveToRecentlyViewed() async {
    final prefs = await SharedPreferences.getInstance();
    final recentJsons = prefs.getStringList('recently_viewed') ?? [];

    recentJsons.removeWhere((item) => Country.fromJsonString(item).name == widget.country.name);
    recentJsons.insert(0, widget.country.toJsonString());

    if (recentJsons.length > 5) recentJsons.removeLast();

    await prefs.setStringList('recently_viewed', recentJsons);
  }

  Future<void> loadData() async {
    isFavourite = await StorageService.isFavourite(widget.country.name);
    userNote = await StorageService.getNote(widget.country.name);
    places = await OpenTripMapService.getPopularPlaces(
      widget.country.name,
      widget.country.latlng[0],
      widget.country.latlng[1],
    );

    print("Fetched \${places.length} places");

    _noteController.text = userNote;

    for (var place in places) {
      placeKeys[place.title] = GlobalKey();
    }

    if (!mounted) return;

    setState(() {
      this.places = places;
    });
  }

  void toggleFavourite() async {
    setState(() => isFavourite = !isFavourite);
    await StorageService.setFavourite(widget.country, isFavourite);
  }

  void saveNote(String value) async {
    await StorageService.setNote(widget.country.name, value);
  }

  void scrollToPlace(String title) {
    final key = placeKeys[title];
    if (key != null && key.currentContext != null) {
      Scrollable.ensureVisible(key.currentContext!, duration: const Duration(milliseconds: 400));
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final country = widget.country;

    return Scaffold(
      appBar: AppBar(
        title: Text(country.name),
        actions: [
          IconButton(
            icon: Icon(isFavourite ? Icons.star : Icons.star_border),
            onPressed: toggleFavourite,
          )
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.network(country.flagUrl, width: 80),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(country.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      Text("Capital: ${country.capital}"),
                      Text("Region: ${country.region}"),
                      Text("Population: ${country.population}"),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),

            SizedBox(
              height: 200,
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(country.latlng[0], country.latlng[1]),
                  initialZoom: 4,
                ),
                children: [
                  TileLayer(
                    urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: const ['a', 'b', 'c'],
                  ),
                  MarkerLayer(
                    markers: places.map((place) {
                      return Marker(
                        point: LatLng(place.lat, place.lon),
                        width: 40,
                        height: 40,
                        child: IconButton(
                          icon: const Icon(Icons.location_on, color: Colors.red),
                          onPressed: () => scrollToPlace(place.title),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Text("Top Places to Visit", style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            ...places.map((place) {
              return Container(
                key: placeKeys[place.title],
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: PlaceCard(place: place),
              );
            }),


            const Divider(height: 40),

            Text("Your Notes", style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            TextField(
              controller: _noteController,
              maxLines: 5,
              onChanged: (value) {
                userNote = value;
                saveNote(value);
              },
              decoration: const InputDecoration(
                hintText: "Write anything about this country...",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
