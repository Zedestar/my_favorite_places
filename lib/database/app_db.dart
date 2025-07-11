import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
// import 'package:drift_flutter/drift_flutter.dart';
import 'package:favourite_places/database/entities.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

part 'app_db.g.dart';

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(path.join(dbFolder.path, 'favourite_place.sqlite'));
    return NativeDatabase(file);
  });
}

@DriftDatabase(tables: [FavouritePlace])
class AppDb extends _$AppDb {
  AppDb() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // The place manipulation methods

  Stream<List<FavouritePlaceData>> getAllFavouritePlaces() {
    return (select(favouritePlace)
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.id)]))
        .watch();
  }

  Future<FavouritePlaceData> getFavouritePlaceById(int id) async {
    return await (select(favouritePlace)..where((item) => item.id.equals(id)))
        .getSingle();
  }

  Future<int> deleteFavouritePlace(int id) async {
    return await (delete(favouritePlace)..where((item) => item.id.equals(id)))
        .go();
  }

  Future<int> insertingFavouritePlace(FavouritePlaceCompanion entity) async {
    return await into(favouritePlace).insert(entity);
  }
}
