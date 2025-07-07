import 'dart:io';

import 'package:drift/drift.dart';
import 'package:favourite_places/database/app_db.dart';
import 'package:favourite_places/model/places_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserPlaceNotifier extends StateNotifier<List<Place>> {
  UserPlaceNotifier() : super(const []);

  final AppDb _appDb = AppDb();

  Future<void> addPlace(
      {required String title,
      required File image,
      required PlaceLocation location}) async {
    final newPlace = Place(title: title, image: image, location: location);

    // 1. Insert into DB
    final companion = FavouritePlaceCompanion(
      name: Value(newPlace.title),
      address: Value(location.address!.substring(0, 49)),
      latitude: Value(location.latitude),
      longitude: Value(location.longitude),
      imageUrl: Value(newPlace.image.path),
      createdAt: Value(DateTime.now()),
    );
    await _appDb.insertingFavouritePlace(companion);

    state = [newPlace, ...state];
  }
}

final userPlacesProvider =
    StateNotifierProvider<UserPlaceNotifier, List<Place>>(
        (ref) => UserPlaceNotifier());
