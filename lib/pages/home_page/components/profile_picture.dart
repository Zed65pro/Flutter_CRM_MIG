import 'package:flutter/material.dart';
import 'dart:math';

class ProfilePicture extends StatelessWidget {
  final String username;
  final double size;

  const ProfilePicture({super.key, required this.username, required this.size});

  Color _getRandomColor() {
    final random = Random();
    int red = random.nextInt(128); // Random value from 0 to 127
    int green = random.nextInt(128); // Random value from 0 to 127
    int blue = random.nextInt(128); // Random value from 0 to 127
    return Color.fromARGB(
      255,
      red,
      green,
      blue,
    );
  }

  @override
  Widget build(BuildContext context) {
    String initials = getInitials(username);
    Color backgroundColor = _getRandomColor();
    return CircleAvatar(
      backgroundColor: backgroundColor,
      child: Text(
        initials,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  String getInitials(String username) {
    List<String> nameParts = username.split(' ');
    String initials = '';
    int numInitials = 2; // You can change this to show more or fewer initials
    for (var i = 0; i < nameParts.length; i++) {
      if (initials.length < numInitials) {
        initials += nameParts[i][0].toUpperCase();
      }
    }
    return initials;
  }
}
