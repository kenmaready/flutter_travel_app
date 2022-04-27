import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
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
                  const SizedBox(height: 10),
                  TestingImageInput(
                    onSelectImage: _selectImage,
                  ),
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

class TestingImageInput extends StatelessWidget {
  final default_image_filename = 'assets/test_image.jpeg';
  final Function onSelectImage;

  TestingImageInput({Key? key, required this.onSelectImage}) : super(key: key);

  Future<void> _selectTestingImage() async {
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final localPath = appDir.path;

    File file = File('$localPath/${path.split('/').last}/test_image.jpeg');

    final ByteData imageBytes = await rootBundle.load("assets/test_image.jpeg");
    final buffer = imageBytes.buffer;

    final savedImage = await file.writeAsBytes(
        buffer.asUint8List(imageBytes.offsetInBytes, imageBytes.lengthInBytes));

    print("savedImage stored at ${savedImage.path}");
    onSelectImage(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(width: 3, color: Colors.red.shade300),
          color: Colors.pink.shade200),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Container(
          width: 90,
          height: 45,
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey.shade400)),
          child: Image.asset(default_image_filename,
              fit: BoxFit.cover, width: double.infinity),
        ),
        Container(
            width: 120,
            child: ElevatedButton(
                child: Text("Add Default Test Image?"),
                onPressed: _selectTestingImage))
      ]),
    );
  }
}
