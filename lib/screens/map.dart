import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_config/flutter_config.dart';
// import 'package:flutter_map/flutter_map.dart';
import 'package:flutter/material.dart';
// import 'package:latlong2/latlong.dart';
//
import '../models/place.dart';

const defaultInitialLocation = PlaceLocation(
    lat: 28.385233, long: -81.563873, address: 'The Happiest Place on Earth');

class MapScreen extends StatefulWidget {
  final PlaceLocation initialLocation;
  final bool isSelecting;

  const MapScreen(
      {Key? key, location = defaultInitialLocation, this.isSelecting = false})
      : initialLocation = location,
        super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedLocation;

  void _selectLocation(LatLng position) {
    setState(() {
      _pickedLocation = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Select Location'), actions: [
          if (widget.isSelecting)
            IconButton(
                icon: const Icon(Icons.check_box),
                onPressed: _pickedLocation == null
                    ? null
                    : () {
                        Navigator.of(context).pop(_pickedLocation);
                      })
        ]),
        body: GoogleMap(
            initialCameraPosition: CameraPosition(
                target: LatLng(
                    widget.initialLocation.lat, widget.initialLocation.long),
                zoom: 13),
            onTap: widget.isSelecting ? _selectLocation : null,
            markers: _pickedLocation == null
                ? {}
                : <Marker>{
                    Marker(
                        markerId: const MarkerId('x'),
                        position: _pickedLocation as LatLng)
                  }));
  }
}
