// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class CustomDialogCreateNode extends StatefulWidget {
  Map<String, String?>? data;
  CustomDialogCreateNode({
    super.key,
    required this.data,
  });

  @override
  State<CustomDialogCreateNode> createState() => _CustomDialogCreateNodeState();
}

class _CustomDialogCreateNodeState extends State<CustomDialogCreateNode> {
  File? _selectedImage;
  late TextEditingController nameTextEditingController;
  late TextEditingController desTextEditingController;
  late Color _currentColor;

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      setState(() {
        // print(result.files.single.path);
        _selectedImage = File(result.files.single.path!);
      });
    }
  }

  void _pickColor() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pick a color!'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _currentColor,
              onColorChanged: (Color color) {
                setState(() {
                  _currentColor = color;
                });
              },
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Got it'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    widget.data ??= {};
    // if (widget.data?["color"] == null) {
    //   _currentColor = Colors.blue;
    // } else {
    //   _currentColor = Color(int.parse(widget.data?["color"] as String));
    // }
    // print(data);
    if (widget.data?["imgUrl"] != null && widget.data?["imgUrl"] != "") {
      _selectedImage = File(widget.data?["imgUrl"] as String);
    }

    nameTextEditingController =
        TextEditingController(text: widget.data?["name"]);
    desTextEditingController = TextEditingController(text: widget.data?["des"]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 3,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            'Node details',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          TextField(
            autofocus: true,
            controller: nameTextEditingController,
            style: const TextStyle(fontSize: 14),
            decoration: const InputDecoration(
              labelText: 'Name',
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              labelStyle: TextStyle(fontSize: 14),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          // _selectedImage == null
          //     ?
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                image: _selectedImage != null
                    ? DecorationImage(image: FileImage(_selectedImage!))
                    : null,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text("Select image"),
                  const SizedBox(height: 8),
                  ElevatedButton(
                      onPressed: _pickImage, child: const Text("Select"))
                ],
              ),
            ),
          ),
          // : Column(
          //     children: [
          //       ClipRRect(
          //         borderRadius: BorderRadius.circular(8),
          //         child:
          //       ),
          //       const SizedBox(height: 8),
          //       ElevatedButton(
          //           onPressed: _pickImage,
          //           child: const Text("Select again"))
          //     ],
          //   ),
          const SizedBox(height: 20),
          TextField(
            controller: desTextEditingController,
            style: const TextStyle(fontSize: 14),
            maxLines: 5,
            minLines: 3,
            decoration: const InputDecoration(
              labelText: 'Description',
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 10, vertical: 16),
              labelStyle: TextStyle(fontSize: 14),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Text("Select Node Color:"),
              IconButton(onPressed: () {}, icon: Icon(Icons.colorize_outlined)),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(
                width: 8,
              ),
              ElevatedButton(
                child: const Text('Submit'),
                onPressed: () {
                  if (nameTextEditingController.text.trim().isNotEmpty) {
                    // widget.data?["color"] = _currentColor.toString();
                    widget.data?["name"] =
                        nameTextEditingController.text.trim();
                    if (_selectedImage == null) {
                      widget.data?["imgUrl"] = "";
                    } else {
                      widget.data?["imgUrl"] = _selectedImage!.path;
                    }

                    widget.data?["des"] = desTextEditingController.text.trim();
                    Navigator.of(context).pop(widget.data);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
