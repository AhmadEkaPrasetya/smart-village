import 'package:flutter/material.dart';

class CategoryFilter extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onSelected;

  const CategoryFilter({
    super.key,
    required this.selectedCategory,
    required this.onSelected,
  });

  static const List<String> categories = [
    'Semua',
    'Rumah Sakit',
    'Puskesmas',
    'Klinik',
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: categories.map((category) {
        return ChoiceChip(
          label: Text(category),
          selected: selectedCategory == category,
          selectedColor: const Color(0xFFB8E5D7),
          onSelected: (_) => onSelected(category),
        );
      }).toList(),
    );
  }
}
