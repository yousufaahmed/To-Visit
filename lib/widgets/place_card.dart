import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/place_model.dart';

class PlaceCard extends StatelessWidget {
  final Place place;

  const PlaceCard({super.key, required this.place});

  // Helper method to open a URL in an external application
  void _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      final success = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!success) {
        debugPrint("❌ Failed to launch externally: $uri");
      }
    } else {
      debugPrint("❌ Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Show image if one is available
            if (place.imageUrl != null && place.imageUrl!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  place.imageUrl!,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Text("Image not available"),
                  loadingBuilder: (context, child, progress) {
                    return progress == null
                        ? child
                        : const SizedBox(
                            height: 180,
                            child: Center(child: CircularProgressIndicator()),
                          );
                  },
                ),
              ),
            const SizedBox(height: 8),

            // Place title
            Text(
              place.title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor, // Theme-aware
              ),
            ),
            const SizedBox(height: 6),

            // Place description
            Text(
              place.summary.isNotEmpty
                  ? place.summary
                  : "No description available",
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: textColor), // Theme-aware
            ),
            const SizedBox(height: 10),

            // Buttons for Maps and Wikipedia
            Row(
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.map),
                  label: const Text("Maps"),
                  onPressed: () {
                    final url = "https://www.google.com/maps/search/?api=1&query=${place.lat},${place.lon}";
                    _openUrl(url);
                  },
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  icon: const Icon(Icons.language),
                  label: const Text("Wikipedia"),
                  onPressed: () {
                    final query = place.title.replaceAll(' ', '+');
                    final url = "https://en.wikipedia.org/w/index.php?search=$query";
                    _openUrl(url);
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
