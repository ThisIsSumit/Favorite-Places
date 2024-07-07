import 'dart:io';

import 'package:uuid/uuid.dart';

const uuid = Uuid();

class PlaceLocation {
  PlaceLocation(
      {required this.latitude, required this.longitude, required this.address});
  final double latitude;
  final double longitude;
  final String address;
}

class Place {
  Place({required this.name, required this.image, required this.location}) : id = uuid.v4();
  String id;
  String name;
  final File image;
  final PlaceLocation location;
}
