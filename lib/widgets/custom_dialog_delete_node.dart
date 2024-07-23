import 'package:flutter/material.dart';

class CustomDialogDeleteNode extends StatefulWidget {
  final List<String> items;
  const CustomDialogDeleteNode({
    super.key,
    required this.items,
  });

  @override
  State<CustomDialogDeleteNode> createState() => _CustomDialogDeleteNodeState();
}

class _CustomDialogDeleteNodeState extends State<CustomDialogDeleteNode> {
  late int _selectedValue;

  @override
  void initState() {
    _selectedValue = 0;
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
            'Remove Node or Edge',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          const Text(
            'Which element do you want to delete?',
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          DropdownButton<int>(
            isExpanded: true,
            value: _selectedValue,
            hint: const Text("Select the item you want to delete"),
            items: widget.items.indexed
                .map((e) => DropdownMenuItem<int>(
                      value: e.$1,
                      child: Text(e.$2),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedValue = value ?? _selectedValue;
              });
            },
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
                  Navigator.of(context).pop(_selectedValue);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
