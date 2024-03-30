import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
AppBar ServicesAppBar() {
  return AppBar(
    title: const Text(
      'Services',
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
    centerTitle: true,
    elevation: 1,
    actions: [
      PopupMenuButton(
        itemBuilder: (BuildContext context) {
          return [
            const PopupMenuItem(
              value: '0',
              child: Text('Option 1'),
            ),
            const PopupMenuItem(
              value: '1',
              child: Text('Option 2'),
            ),
          ];
        },
        onSelected: (selectedValue) {
          // Handle selected option
          debugPrint(selectedValue);
        },
      ),
    ],
  );
}
