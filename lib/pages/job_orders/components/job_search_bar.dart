import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JobOrdersSearchBar extends StatefulWidget {
  final Function(String) onSearchPressed;
  final Function(List<String>) onFilterPressed;
  final TextEditingController searchController;
  const JobOrdersSearchBar(
      {super.key,
      required this.onSearchPressed,
      required this.onFilterPressed,
      required this.searchController,});

  @override
  State<JobOrdersSearchBar> createState() => _JobOrdersSearchBarState();
}

class _JobOrdersSearchBarState extends State<JobOrdersSearchBar> {
  List<String> filters = ['Active', 'Inactive', 'Completed'];
  List<String> selectedFilters = [];

  void _showFilterMenu() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Filters'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: filters.map((filter) {
                  return CheckboxListTile(
                    title: Text(filter),
                    value: selectedFilters.contains(filter),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value != null && value) {
                          selectedFilters.add(filter);
                        } else {
                          selectedFilters.remove(filter);
                        }
                      });
                    },
                  );
                }).toList(),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Get.back();
                widget.onFilterPressed(selectedFilters);
              },
              child: const Text('Apply'),
            ),
          ],
        );
      },
    );
  }

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
              widget.onSearchPressed(widget.searchController.text);
              FocusScope.of(context).unfocus();
            },
          ),
          Expanded(
            child: TextField(
              controller: widget.searchController,
              decoration: const InputDecoration(
                hintText: 'Search...',
                border: InputBorder.none,
              ),
              onSubmitted: (value) {
                widget.onSearchPressed(widget.searchController.text);
                FocusScope.of(context).unfocus();
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterMenu,
          ),
        ],
      ),
    );
  }
}
