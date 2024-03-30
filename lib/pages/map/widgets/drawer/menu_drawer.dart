import 'package:flutter/material.dart';

class MenuDrawer extends StatelessWidget {
  final String currentRoute;

  const MenuDrawer(this.currentRoute, {super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/ProjectIcon.png',
                  height: 48,
                ),
                const SizedBox(height: 16),
                const Text(
                  'flutter_map Demo',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text(
                  '© flutter_map Authors & Contributors',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
