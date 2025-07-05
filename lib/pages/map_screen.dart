import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  LatLng? pickedLocation;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Google Map",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: GoogleMap(
        onTap: (position) {
          setState(() {
            pickedLocation = position;
            print(pickedLocation);
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
          if (pickedLocation != null) ...[
            Marker(
              markerId: const MarkerId('picked_location'),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueGreen),
              position: LatLng(
                pickedLocation!.latitude,
                pickedLocation!.longitude,
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
