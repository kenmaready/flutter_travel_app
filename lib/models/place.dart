import 'package:uuid/uuid.dart';
import 'dart:io';

var uuid = Uuid();

class PlaceLocation {
  final double lat;
  final double long;
  final String address;

  PlaceLocation({required this.lat, required this.long, this.address = ''});

  PlaceLocation.empty()
      : lat = 0.0,
        long = 0.0,
        address = ''; // for testing
}

class Place {
  final String id;
  final String title;
  final PlaceLocation location;
  final File image;

  Place({required this.title, required this.location, required this.image})
      : id = uuid.v1();

  Place.withId(
      {required this.id,
      required this.title,
      required this.location,
      required this.image});
}
