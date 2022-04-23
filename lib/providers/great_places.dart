import 'package:flutter/foundation.dart';
import 'dart:io';
//
import '../models/place.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  void addPlace(String title, File image) {
    print("addPlace() called for new place ${title}...");
    final newPlace =
        Place(image: image, title: title, location: PlaceLocation.empty());
    _items.add(newPlace);
    print("New place added with id ${newPlace.id}...");
    notifyListeners();
  }
}
