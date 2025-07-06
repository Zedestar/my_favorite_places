import 'dart:convert';

import 'package:favourite_places/functions/addImageToParent.dart';
import 'package:favourite_places/model/places_model.dart';
import 'package:favourite_places/pages/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

class InputLocationWidget extends StatefulWidget {
  const InputLocationWidget({super.key, required this.addLocationToParent});

  final AddLocationToParent addLocationToParent;

  @override
  State<InputLocationWidget> createState() => _InputLocationWidgetState();
}

class _InputLocationWidgetState extends State<InputLocationWidget> {
  final String mapApiKey = dotenv.env['GOOGLE_MAPS_API_KEY']!;
  bool _isLoading = false;
  PlaceLocation? _userLocation;

  String get mapImageUrl {
    if (_userLocation == null) {
      return "";
    }
    final lat = _userLocation!.latitude;
    final lon = _userLocation!.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lon&zoom=16&size=600x400&maptype=hybrid&markers=color:red|$lat,$lon&key=$mapApiKey';
  }

  void getCurrentPosition() async {
    setState(() {
      _isLoading = true;
    });
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();

    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=${locationData.latitude},${locationData.longitude}&key=$mapApiKey',
    );
    final response = await http.get(url);
    final resData = json.decode(response.body);
    // final address = resData['results']?[0]['formatted_address'];
    // print("The address of the place is $address");
    print(response.body);

    setState(() {
      _userLocation = PlaceLocation(
        latitude: locationData.latitude!,
        longitude: locationData.longitude!,
        address: (resData['results'] is List && resData['results'].isNotEmpty)
            ? resData['results'][0]['formatted_address'] ?? ''
            : '',
      );
      widget.addLocationToParent(_userLocation!);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(border: Border.all(width: 0.5)),
          height: 250,
          width: double.infinity,
          alignment: Alignment.center,
          child: _isLoading
              ? CircularProgressIndicator()
              : _userLocation != null
                  // ? Text(
                  //     "Latittude ${_userLocation!.latitude} longitude ${_userLocation!.longitude} \nAddress: ${_userLocation!.address}",
                  //   )
                  ? Image.network(
                      mapImageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    )
                  : Text("NO any data selected"),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton.icon(
              onPressed: getCurrentPosition,
              icon: Icon(Icons.location_on_outlined),
              label: Text(
                "Get current location",
              ),
            ),
            OutlinedButton.icon(
              onPressed: () async {
                final PlaceLocation? userLocationFromTheMap =
                    await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return GoogleMapScreen();
                    },
                  ),
                );

                if (userLocationFromTheMap != null) {
                  setState(() {
                    _isLoading = true;
                    _userLocation = userLocationFromTheMap;
                    widget.addLocationToParent(_userLocation!);
                    _isLoading = false;
                  });
                }
              },
              icon: Icon(
                Icons.map_outlined,
              ),
              label: Text(
                "Select on map",
              ),
            ),
          ],
        )
      ],
    );
  }
}
