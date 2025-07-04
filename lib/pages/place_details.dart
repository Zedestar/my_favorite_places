import 'package:favourite_places/model/places_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PlaceDetailsPage extends StatelessWidget {
  PlaceDetailsPage({super.key, required this.place});
  final Place place;
  final String mapApiKey = dotenv.env['GOOGLE_MAPS_API_KEY']!;

  String get mapImageUrl {
    if (place.location == null) {
      return "";
    }
    final lat = place.location!.latitude;
    final lon = place.location!.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lon&zoom=16&size=600x400&maptype=hybrid&markers=color:red|$lat,$lon&key=$mapApiKey';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(place.title),
      ),
      body: Stack(
        children: [
          Image.file(
            place.image,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 10,
            child: Column(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(mapImageUrl),
                  radius: 72,
                ),
                Text(
                  place.location!.address ?? "",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}



//  https://youtu.be/M7cOmiSly3Q