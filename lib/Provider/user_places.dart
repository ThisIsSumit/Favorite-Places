import 'dart:ffi';
import 'dart:io';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:favorite_places_app/model/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqflite.dart';

Future<Database> _getDatabase() async {
  final dbpath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(path.join(dbpath, 'places.db'),
      onCreate: (db, version) {
    return db.execute(
        'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, lng REAL, address TEXT)');
  }, version: 1);
  return db;
}

class UserPlacesNotifier extends StateNotifier<List<Place>> {
  UserPlacesNotifier() : super(const []);
  void loadPlaces() async {
    final db = await _getDatabase();
    final data = await db.query('user_places');
    data.map((row) => Place(
        name: row['title'] as String,
        image: File(row['image'] as String),
        location: PlaceLocation(
            latitude: row['lat'] as double,
            longitude: row['lng'] as double,
            address: row['address'] as String)));
  }

  void addPlace(String name, File image, PlaceLocation location) async {
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final filename = path.basename(image.path);

    final copiedImage = await image.copy('${appDir.path}/$filename');
    final newPlace = Place(name: name, image: copiedImage, location: location);
    final db = await _getDatabase();
    db.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.name,
      'image': newPlace.image,
      'lat': newPlace.location.latitude,
      'lng': newPlace.location.longitude,
      'address': newPlace.location.address
    });

    state = [newPlace, ...state];
  }
}

final userPlacesProvider =
    StateNotifierProvider<UserPlacesNotifier, List<Place>>(
        (ref) => UserPlacesNotifier());
