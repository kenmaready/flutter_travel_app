import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
//
import '../providers/great_places.dart';
import './map.dart';

class PlaceDetailScreen extends StatelessWidget {
  static const routeName = "/place";
  const PlaceDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)?.settings.arguments as String;
    final selectedPlace =
        Provider.of<GreatPlaces>(context, listen: false).findById(id);
    return Scaffold(
        appBar: AppBar(title: Text(selectedPlace.title)),
        body: Column(
          children: [
            Container(
                height: 250,
                width: double.infinity,
                child: Image.file(selectedPlace.image,
                    fit: BoxFit.cover, width: double.infinity)),
            SizedBox(height: 20),
            Text(selectedPlace.location.address,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.black54)),
            TextButton(
              child: Text('View on Map'),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (ctx) => MapScreen(
                        location: selectedPlace.location,
                      ))),
            )
          ],
        ));
  }
}
