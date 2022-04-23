import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

class ImageInputField extends StatefulWidget {
  final Function onSelectImage;

  const ImageInputField({Key? key, required this.onSelectImage})
      : super(key: key);

  @override
  State<ImageInputField> createState() => _ImageInputFieldState();
}

class _ImageInputFieldState extends State<ImageInputField> {
  File? _storedImage;

  Future<void> _takePicture() async {
    final imagePicker = ImagePicker();
    try {
      final imageFile = await imagePicker.pickImage(
          source: ImageSource.camera, maxWidth: 600);

      // check to see if user actually took an image:
      if (imageFile == null) return;

      setState(() {
        _storedImage = File((imageFile as XFile).path);
      });

      // find the appropriate file paths for saving photos:
      final appDir = await syspaths.getApplicationDocumentsDirectory();
      final fileName = path.basename((imageFile as XFile).path);
      final savedImage =
          await (_storedImage as File).copy('${appDir.path}/$fileName');
      print("savedImage stored at ${savedImage.path}");
      widget.onSelectImage(savedImage);
    } catch (error) {
      print("Error: ${error.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 240,
          height: 120,
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey.shade400)),
          child: (_storedImage != null && _storedImage is File)
              ? Image.file(_storedImage as File,
                  fit: BoxFit.cover, width: double.infinity)
              : const Text(
                  'No Image Provided',
                  textAlign: TextAlign.center,
                ),
          alignment: Alignment.center,
        ),
        const SizedBox(width: 10),
        Expanded(
            child: TextButton.icon(
          icon: const Icon(Icons.camera),
          label: const Text('Take a Pic'),
          onPressed: _takePicture,
          style: TextButton.styleFrom(
              textStyle:
                  TextStyle(color: Theme.of(context).colorScheme.secondary)),
        ))
      ],
    );
  }
}
