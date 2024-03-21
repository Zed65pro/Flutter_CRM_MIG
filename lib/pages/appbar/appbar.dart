import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final void Function(int) onMenuSelected;

  const CustomAppBar({super.key, required this.onMenuSelected});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Your App Name',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          PopupMenuButton<int>(
            onSelected: onMenuSelected,
            itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
              const PopupMenuItem<int>(
                value: 0,
                child: Text('Customers'),
              ),
              const PopupMenuItem<int>(
                value: 1,
                child: Text('Services'),
              ),
              const PopupMenuItem<int>(
                value: 2,
                child: Text('Logout'),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: Colors.blue, // Change the background color as needed
    );
  }
}
