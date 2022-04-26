import 'package:flutter/foundation.dart';
import 'dart:io';
//
import '../helpers/location_helper.dart';
import '../helpers/db_helper.dart';
import '../models/place.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  Future<void> addPlace(
      String title, File image, PlaceLocation location) async {
    print("addPlace() called for new place ${title}...");

    final address = await LocationHelper.getPlaceAddress(
        lat: location.lat, long: location.long);
    final updatedLocation =
        PlaceLocation(lat: location.lat, long: location.long, address: address);

    final newPlace =
        Place(image: image, title: title, location: updatedLocation);
    _items.add(newPlace);

    print("New place added with id ${newPlace.id}...");
    notifyListeners();

    DBHelper.insert('places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'lat': newPlace.location.lat,
      'long': newPlace.location.long,
      'address': newPlace.location.address
    });
  }

  Future<void> fetchPlaces() async {
    final data = await DBHelper.get('places');
    _items = data
        .map((item) => Place.withId(
            id: item['id'] as String,
            title: item['title'] as String,
            image: File(item['image'] as String),
            location: PlaceLocation(
                lat: item['lat'] as double,
                long: item['long'] as double,
                address: item['address'] as String)))
        .toList();
    notifyListeners();
  }
}
