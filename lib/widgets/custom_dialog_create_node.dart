// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDialogCreateNode extends StatelessWidget {
  Map<String, String?>? data;
  CustomDialogCreateNode({
    super.key,
    required this.data,
  });

  late TextEditingController nameTextEditingController;
  late TextEditingController desTextEditingController;
  late TextEditingController imgUTextEditingController;

  @override
  Widget build(BuildContext context) {
    data ??= {};
    print(data);
    nameTextEditingController = TextEditingController(text: data?["name"]);
    imgUTextEditingController = TextEditingController(text: data?["imgUrl"]);
    desTextEditingController = TextEditingController(text: data?["des"]);

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
          TextField(
            controller: imgUTextEditingController,
            style: const TextStyle(fontSize: 14),
            decoration: const InputDecoration(
              labelText: 'Image URL',
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              labelStyle: TextStyle(fontSize: 14),
              border: OutlineInputBorder(),
            ),
          ),
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
                  if (nameTextEditingController.text.trim().isNotEmpty &&
                      (imgUTextEditingController.text.isURL ||
                          imgUTextEditingController.text.trim().isEmpty)) {
                    data?["name"] = nameTextEditingController.text.trim();
                    data?["imgUrl"] = imgUTextEditingController.text.trim();
                    data?["des"] = desTextEditingController.text.trim();
                    Navigator.of(context).pop(data);
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
