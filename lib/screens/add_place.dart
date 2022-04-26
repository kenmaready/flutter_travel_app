import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'dart:io';
//
import '../providers/great_places.dart';
import '../widgets/location_input.dart';
import '../widgets/image_input.dart';
import '../models/place.dart';

class AddPlaceScreen extends StatefulWidget {
  static const routeName = '/places/add';

  const AddPlaceScreen({Key? key}) : super(key: key);

  @override
  State<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _titleController = TextEditingController();
  File? _selectedImage;
  PlaceLocation? _selectedLocation;

  void _selectImage(File selectedImage) {
    _selectedImage = selectedImage;
    print("_selectImage called from within AddPlace...");
  }

  void _selectLocation({required double lat, required double long}) {
    setState(() {
      _selectedLocation = PlaceLocation(lat: lat, long: long);
    });
  }

  void _savePlace() {
    print("_savePlace() called...");
    // check to see if info provided, if not just return:
    if (_titleController.text.isEmpty ||
        _selectedImage == null ||
        _selectedLocation == null) {
      if (_titleController.text.isEmpty) {
        print("_titleController.text is Empty...");
      }

      if (_selectedImage == null) {
        print("_selectedImage is null...");
      }

      if (_selectedLocation == null) {
        print("_selectedLocation is null...");
      }
      return;
    }

    try {
      Provider.of<GreatPlaces>(context, listen: false).addPlace(
          _titleController.text,
          _selectedImage as File,
          _selectedLocation as PlaceLocation);
      print("Save place succeeded...");
      Navigator.of(context).pop();
    } catch (error) {
      print("Error in _savePlace(): ${error.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    var expanded = Expanded;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add a New Place'),
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                  child: SingleChildScrollView(
                      child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(children: [
                  TextField(
                    decoration: const InputDecoration(labelText: 'Title'),
                    controller: _titleController,
                  ),
                  const SizedBox(height: 10),
                  ImageInputField(onSelectImage: _selectImage),
                  const SizedBox(height: 10),
                  LocationInput(onSelectLocation: _selectLocation),
                ]),
              ))),
              ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Add Place'),
                  onPressed: _savePlace,
                  style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).colorScheme.secondary,
                      padding: const EdgeInsets.only(top: 12, bottom: 30),
                      elevation: 0,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap)),
            ]));
  }
}
