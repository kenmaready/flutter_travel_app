import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
//
import '../providers/great_places.dart';
import '../widgets/place_item.dart';
import './add_place.dart';

class PlacesListScreen extends StatelessWidget {
  const PlacesListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Great Places!'), actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
      ]),
      body: Center(
          child: Column(children: [
        Expanded(
          child: FutureBuilder(
            future:
                Provider.of<GreatPlaces>(context, listen: false).fetchPlaces(),
            builder: (ctx, snapshot) =>
                snapshot.connectionState == ConnectionState.waiting
                    ? const Center(child: CircularProgressIndicator())
                    : Consumer<GreatPlaces>(
                        child: Center(
                            child: const Text(
                                "No Places Saved Yet, Start Adding Some!")),
                        builder: (ctx, greatPlaces, ch) =>
                            (greatPlaces.items.length <= 0)
                                ? ch as Text
                                : ListView.builder(
                                    itemCount: greatPlaces.items.length,
                                    itemBuilder: (ctx, index) => PlaceItem(
                                        place: greatPlaces.items[index]))),
          ),
        ),
        SizedBox(
          width: 50,
          height: 50,
          child: ElevatedButton(
            child: const Icon(
              Icons.add,
            ),
            style: ElevatedButton.styleFrom(),
            onPressed: () =>
                Navigator.of(context).pushNamed(AddPlaceScreen.routeName),
          ),
        )
      ])),
    );
  }
}
