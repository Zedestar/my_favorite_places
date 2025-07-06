import 'dart:convert';

import 'package:favourite_places/model/places_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({
    super.key,
    this.latitude = -6.1731,
    this.longitude = 35.7540,
  });

  final double latitude;
  final double longitude;

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  // LatLng? pickedLocation;
  // String? locationAddress;
  PlaceLocation? pickedPlaceLocation;
  bool isLoading = false;
  final mapApiKey = dotenv.env['GOOGLE_MAPS_API_KEY']!;

  //  String get mapImageUrl {
  //   final lat = pickedLocation!.latitude;
  //   final lon = pickedLocation!.longitude;
  //   return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lon&zoom=16&size=600x400&maptype=hybrid&markers=color:red|$lat,$lon&key=$mapApiKey';
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Google Map",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        actions: [
          if (isLoading) ...[
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            )
          ],
          if (pickedPlaceLocation != null) ...[
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.save_outlined,
                  color: Colors.black,
                ))
          ]
        ],
      ),
      body: GoogleMap(
        onTap: (position) async {
          setState(() {
            isLoading = true;
          });
          final url = Uri.parse(
            'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapApiKey',
          );
          final response = await http.get(url);
          final pickedAddress = json.decode(response.body);
          print(pickedAddress);

          setState(() {
            pickedPlaceLocation = PlaceLocation(
              latitude: position.latitude,
              longitude: position.longitude,
              address: (pickedAddress['results'] is List &&
                      pickedAddress['results'].isNotEmpty)
                  ? pickedAddress['results'][0]['formatted_address'] ?? ''
                  : '',
            );
            isLoading = false;
          });
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.latitude,
            widget.longitude,
          ),
          zoom: 16,
          // tilt: 45,
          bearing: 30,
        ),
        mapType: MapType.satellite,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        markers: {
          Marker(
            markerId: const MarkerId('marker_1'),
            position: LatLng(
              widget.latitude,
              widget.longitude,
            ),
            infoWindow: const InfoWindow(
              title: 'Marker 1',
              snippet: 'This is just the first marker',
            ),
          ),
          if (pickedPlaceLocation != null) ...[
            Marker(
              markerId: const MarkerId('picked_location'),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueGreen),
              position: LatLng(
                pickedPlaceLocation!.latitude,
                pickedPlaceLocation!.longitude,
              ),
              infoWindow: const InfoWindow(
                title: 'pickup point',
                snippet: 'The pickup point',
              ),
            ),
          ]
        },
      ),
    );
  }
}
