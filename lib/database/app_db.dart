import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
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
}
