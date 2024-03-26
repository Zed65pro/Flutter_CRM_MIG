import 'package:flutter/material.dart';

class ServicesSearchBar extends StatelessWidget {
  final Function(String) onSearchPressed;
  final Function() onFilterPressed;
  final TextEditingController searchController;

  const ServicesSearchBar({
    super.key,
    required this.onSearchPressed,
    required this.onFilterPressed,
    required this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.grey[200],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              onSearchPressed(
                  searchController.text); // Pass text from controller
              FocusScope.of(context).unfocus();
            },
          ),
          Expanded(
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: 'Search...',
                border: InputBorder.none,
              ),
              onSubmitted: (value) {
                onSearchPressed(
                    searchController.text); // Pass text from controller
                FocusScope.of(context).unfocus();
              },
            ),
          ),
          // IconButton(
          //   icon: const Icon(Icons.filter_list),
          //   onPressed: onFilterPressed,
          // ),
        ],
      ),
    );
  }
}
