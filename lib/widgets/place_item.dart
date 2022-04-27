import 'package:flutter/material.dart';
//
import '../screens/place_detail.dart';
import '../models/place.dart';

class PlaceItem extends StatelessWidget {
  final Place place;

  const PlaceItem({Key? key, required this.place}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: CircleAvatar(backgroundImage: FileImage(place.image)),
        title: Text(place.title),
        subtitle: Text(place.location.address),
        onTap: () => Navigator.of(context)
            .pushNamed(PlaceDetailScreen.routeName, arguments: place.id));
  }
}
