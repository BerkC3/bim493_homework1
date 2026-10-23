import 'package:flutter/material.dart';

import '../models/campus_event.dart';

class SearchFilterBar extends StatelessWidget {
  const SearchFilterBar({
    super.key,
    required this.controller,
    required this.selectedCategory,
    required this.onQueryChanged,
    required this.onClearSearch,
    required this.onCategorySelected,
  });

  final TextEditingController controller;
  final EventCategory? selectedCategory;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onClearSearch;
  final ValueChanged<EventCategory?> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          child: TextField(
            controller: controller,
            onChanged: onQueryChanged,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: 'Search events by title',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: controller.text.isEmpty
                  ? null
                  : IconButton(
                      tooltip: 'Clear search',
                      icon: const Icon(Icons.close_rounded),
                      onPressed: onClearSearch,
                    ),
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              _categoryChip(context, null, 'All', Icons.apps_rounded),
              for (final category in EventCategory.values)
                _categoryChip(context, category, category.label, category.icon),
            ],
          ),
        ),
      ],
    );
  }

  Widget _categoryChip(
    BuildContext context,
    EventCategory? category,
    String label,
    IconData icon,
  ) {
    final selected = selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        avatar: selected ? null : Icon(icon, size: 18),
        label: Text(label),
        selected: selected,
        onSelected: (_) => onCategorySelected(category),
      ),
    );
  }
}
