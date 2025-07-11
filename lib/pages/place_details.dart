import 'dart:io';

import 'package:favourite_places/database/app_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'map_screen.dart';

class PlaceDetailsPage extends StatelessWidget {
  PlaceDetailsPage({super.key, required this.place});
  final FavouritePlaceData place;
  final String mapApiKey = dotenv.env['GOOGLE_MAPS_API_KEY']!;

  String get mapImageUrl {
    // if (place) {
    //   return "";
    // }
    final lat = place.latitude;
    final lon = place.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lon&zoom=16&size=600x400&maptype=hybrid&markers=color:red|$lat,$lon&key=$mapApiKey';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(place.name),
      ),
      body: Stack(
        children: [
          Image.file(
            File(place.imageUrl),
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
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => GoogleMapScreen(
                          latitude: place.latitude,
                          longitude: place.longitude,
                        ),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(mapImageUrl),
                    radius: 72,
                  ),
                ),
                Text(
                  place.address ?? "",
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