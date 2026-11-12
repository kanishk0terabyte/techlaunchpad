import 'package:flutter/material.dart';

class CategoryChips extends StatelessWidget {
  final List<String> categories;
  final String? selected;
  final ValueChanged<String> onSelected;
  final EdgeInsets padding;

  const CategoryChips({
    super.key,
    required this.categories,
    this.selected,
    required this.onSelected,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: padding,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isActive = selected == cat;
          return ChoiceChip(
            label: Text(cat),
            selected: isActive,
            onSelected: (_) => onSelected(cat),
            labelStyle: theme.textTheme.labelLarge?.copyWith(
              color: isActive ? Colors.white : theme.colorScheme.onSurfaceVariant,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            ),
            selectedColor: theme.colorScheme.primary,
            backgroundColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.4),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            side: BorderSide(color: isActive ? Colors.transparent : theme.colorScheme.outlineVariant.withOpacity(0.3)),
            elevation: isActive ? 2 : 0,
            pressElevation: 4,
            showCheckmark: false,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          );
        },
      ),
    );
  }
}
