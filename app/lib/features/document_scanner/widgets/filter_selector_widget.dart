import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:bharattesting_core/core.dart' as core;
import '../models/document_scanner_state.dart';

/// Widget for selecting document image filters
class FilterSelectorWidget extends StatelessWidget {
  const FilterSelectorWidget({
    super.key,
    required this.onFilterSelected,
    required this.selectedFilter,
    this.thumbnailData,
  });

  final Function(core.DocumentFilter) onFilterSelected;
  final core.DocumentFilter selectedFilter;
  final Uint8List? thumbnailData;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: core.DocumentFilter.values.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final filter = core.DocumentFilter.values[index];
          final isSelected = filter == selectedFilter;

          return _FilterItem(
            filter: filter,
            isSelected: isSelected,
            onTap: () => onFilterSelected(filter),
            thumbnailData: thumbnailData,
          );
        },
      ),
    );
  }
}

class _FilterItem extends StatelessWidget {
  const _FilterItem({
    required this.filter,
    required this.isSelected,
    required this.onTap,
    this.thumbnailData,
  });

  final core.DocumentFilter filter;
  final bool isSelected;
  final VoidCallback onTap;
  final Uint8List? thumbnailData;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          border: isSelected ? Border.all(color: Theme.of(context).colorScheme.primary, width: 2) : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: thumbnailData != null
                    ? Image.memory(thumbnailData!, fit: BoxFit.cover)
                    : Container(color: Colors.grey[300], child: const Icon(Icons.filter)),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              filter.name,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
