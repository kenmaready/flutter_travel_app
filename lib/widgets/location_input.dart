import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
//
import '../helpers/location_helper.dart';
import '../screens/map.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectLocation;

  const LocationInput({Key? key, required this.onSelectLocation})
      : super(key: key);

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String _previewImageUrl = '';

  Future<void> _getCurrentUserLocation() async {
    try {
      final locationData = await Geolocator.getCurrentPosition();
      _showPreviewOfLocation(locationData.latitude, locationData.longitude);
      widget.onSelectLocation(
          lat: locationData.latitude, long: locationData.longitude);
    } catch (error) {
      print("error in _getCurrentUserLocation(): ${error}");
      return;
    }
  }

  Future<void> _selectLocationOnMap() async {
    final LatLng selectedLocation = await Navigator.of(context).push(
        MaterialPageRoute(
            builder: (ctx) => const MapScreen(isSelecting: true),
            fullscreenDialog: true));

    if (selectedLocation == null) return;

    _showPreviewOfLocation(
        selectedLocation.latitude, selectedLocation.longitude);
    widget.onSelectLocation(
        lat: selectedLocation.latitude, long: selectedLocation.longitude);
  }

  void _showPreviewOfLocation(double lat, double long) {
    setState(() {
      _previewImageUrl =
          LocationHelper.generateLocationPreviewImage(lat: lat, long: long);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            height: 170,
            width: double.infinity,
            alignment: Alignment.center,
            decoration:
                BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
            child: _previewImageUrl == null || _previewImageUrl == ''
                ? const Text(
                    'No Location Chosen',
                    textAlign: TextAlign.center,
                  )
                : Image.network(_previewImageUrl,
                    fit: BoxFit.cover, width: double.infinity)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.location_on),
              label: const Text('Current location'),
              onPressed: _getCurrentUserLocation,
            ),
            TextButton.icon(
                icon: const Icon(Icons.map),
                label: const Text('Choose a location'),
                onPressed: _selectLocationOnMap)
          ],
        )
      ],
    );
  }
}
