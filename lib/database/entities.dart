import 'package:drift/drift.dart';

class FavouritePlace extends Table {
  IntColumn get id => integer().autoIncrement().named('id')();
  TextColumn get name => text().withLength(min: 1, max: 50).named('name')();
  TextColumn get address =>
      text().withLength(min: 1, max: 50).named('address')();
  RealColumn get latitude => real().named('latitude')();
  RealColumn get longitude => real().named('longitude')();
  TextColumn get imageUrl => text().named('image_url')();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime).named('created_at')();
}
