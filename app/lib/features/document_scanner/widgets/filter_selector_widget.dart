import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:bharattesting_core/core.dart';

/// Widget for selecting document image filters
class FilterSelectorWidget extends StatelessWidget {
  const FilterSelectorWidget({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
    this.showPreview = false,
    this.previewImageData,
    this.isCompact = false,
  });

  final DocumentFilter selectedFilter;
  final void Function(DocumentFilter filter) onFilterChanged;
  final bool showPreview;
  final List<int>? previewImageData;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return _buildCompactSelector(context);
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Document Filters',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            // Filter chips
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: DocumentFilter.values.map((filter) {
                return _FilterChip(
                  filter: filter,
                  isSelected: filter == selectedFilter,
                  onTap: () => onFilterChanged(filter),
                );
              }).toList(),
            ),

            const SizedBox(height: 12),

            // Description
            Text(
              selectedFilter.description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),

            // Preview section
            if (showPreview && previewImageData != null)
              _buildPreviewSection(context),
          ],
        ),
      ),
    );
  }

  /// Build compact horizontal selector
  Widget _buildCompactSelector(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: DocumentFilter.values.length,
        itemBuilder: (context, index) {
          final filter = DocumentFilter.values[index];
          return Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? 16 : 4,
              right: index == DocumentFilter.values.length - 1 ? 16 : 4,
            ),
            child: _FilterButton(
              filter: filter,
              isSelected: filter == selectedFilter,
              onTap: () => onFilterChanged(filter),
              isCompact: true,
            ),
          );
        },
      ),
    );
  }

  /// Build preview section with before/after comparison
  Widget _buildPreviewSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          'Filter Preview',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.outline,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              // Original
              Expanded(
                child: Column(
                  children: [
                    Container(
                      height: 20,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(7),
                          topRight: Radius.circular(7),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Original',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(7),
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            LucideIcons.image,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                color: Theme.of(context).colorScheme.outline,
              ),
              // Filtered
              Expanded(
                child: Column(
                  children: [
                    Container(
                      height: 20,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(7),
                          topRight: Radius.circular(7),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          selectedFilter.displayName,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: _getFilterPreviewColor(selectedFilter),
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(7),
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            _getFilterIcon(selectedFilter),
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Get preview color for filter
  Color _getFilterPreviewColor(DocumentFilter filter) {
    switch (filter) {
      case DocumentFilter.original:
        return Colors.grey;
      case DocumentFilter.autoColor:
        return Colors.blue;
      case DocumentFilter.grayscale:
        return Colors.grey[600]!;
      case DocumentFilter.blackAndWhite:
        return Colors.black;
      case DocumentFilter.magicColor:
        return Colors.purple;
      case DocumentFilter.whiteboard:
        return Colors.grey[300]!;
    }
  }

  /// Get icon for filter
  IconData _getFilterIcon(DocumentFilter filter) {
    switch (filter) {
      case DocumentFilter.original:
        return LucideIcons.image;
      case DocumentFilter.autoColor:
        return LucideIcons.sparkles;
      case DocumentFilter.grayscale:
        return LucideIcons.circle;
      case DocumentFilter.blackAndWhite:
        return LucideIcons.square;
      case DocumentFilter.magicColor:
        return LucideIcons.wand2;
      case DocumentFilter.whiteboard:
        return LucideIcons.clipboard;
    }
  }
}

/// Individual filter chip
class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.filter,
    required this.isSelected,
    required this.onTap,
  });

  final DocumentFilter filter;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline,
              width: 1,
            ),
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getFilterIcon(filter),
                size: 16,
                color: isSelected
                  ? Colors.white
                  : Theme.of(context).colorScheme.onSurface,
              ),
              const SizedBox(width: 8),
              Text(
                filter.displayName,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isSelected
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurface,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getFilterIcon(DocumentFilter filter) {
    switch (filter) {
      case DocumentFilter.original:
        return LucideIcons.image;
      case DocumentFilter.autoColor:
        return LucideIcons.sparkles;
      case DocumentFilter.grayscale:
        return LucideIcons.circle;
      case DocumentFilter.blackAndWhite:
        return LucideIcons.square;
      case DocumentFilter.magicColor:
        return LucideIcons.wand2;
      case DocumentFilter.whiteboard:
        return LucideIcons.clipboard;
    }
  }
}

/// Compact filter button
class _FilterButton extends StatelessWidget {
  const _FilterButton({
    required this.filter,
    required this.isSelected,
    required this.onTap,
    required this.isCompact,
  });

  final DocumentFilter filter;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: isCompact ? 64 : 80,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline,
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getFilterIcon(filter),
                size: isCompact ? 16 : 20,
                color: isSelected
                  ? Colors.white
                  : Theme.of(context).colorScheme.onSurface,
              ),
              const SizedBox(height: 4),
              Text(
                _getShortName(filter),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isSelected
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurface,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  fontSize: isCompact ? 10 : 12,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getShortName(DocumentFilter filter) {
    switch (filter) {
      case DocumentFilter.original:
        return 'Original';
      case DocumentFilter.autoColor:
        return 'Auto';
      case DocumentFilter.grayscale:
        return 'Gray';
      case DocumentFilter.blackAndWhite:
        return 'B&W';
      case DocumentFilter.magicColor:
        return 'Magic';
      case DocumentFilter.whiteboard:
        return 'Board';
    }
  }

  IconData _getFilterIcon(DocumentFilter filter) {
    switch (filter) {
      case DocumentFilter.original:
        return LucideIcons.image;
      case DocumentFilter.autoColor:
        return LucideIcons.sparkles;
      case DocumentFilter.grayscale:
        return LucideIcons.circle;
      case DocumentFilter.blackAndWhite:
        return LucideIcons.square;
      case DocumentFilter.magicColor:
        return LucideIcons.wand2;
      case DocumentFilter.whiteboard:
        return LucideIcons.clipboard;
    }
  }
}

/// Advanced filter options widget
class AdvancedFilterOptions extends StatelessWidget {
  const AdvancedFilterOptions({
    super.key,
    required this.selectedFilter,
    required this.filterOptions,
    required this.onFilterOptionsChanged,
  });

  final DocumentFilter selectedFilter;
  final FilterOptions filterOptions;
  final void Function(FilterOptions options) onFilterOptionsChanged;

  @override
  Widget build(BuildContext context) {
    if (selectedFilter == DocumentFilter.original) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Advanced ${selectedFilter.displayName} Options',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            if (selectedFilter == DocumentFilter.autoColor) ...[
              _buildSliderOption(
                context,
                'CLAHE Clip Limit',
                filterOptions.claheClipLimit,
                1.0,
                5.0,
                (value) => onFilterOptionsChanged(
                  filterOptions.copyWith(claheClipLimit: value),
                ),
              ),
            ],

            if (selectedFilter == DocumentFilter.blackAndWhite) ...[
              _buildSliderOption(
                context,
                'Block Size',
                filterOptions.adaptiveBlockSize.toDouble(),
                3.0,
                31.0,
                (value) => onFilterOptionsChanged(
                  filterOptions.copyWith(adaptiveBlockSize: value.toInt()),
                ),
                divisions: 14,
              ),
              _buildSliderOption(
                context,
                'Threshold Constant',
                filterOptions.adaptiveC.toDouble(),
                0.0,
                20.0,
                (value) => onFilterOptionsChanged(
                  filterOptions.copyWith(adaptiveC: value.toInt()),
                ),
                divisions: 20,
              ),
            ],

            // Reset to defaults button
            const SizedBox(height: 16),
            Center(
              child: TextButton.icon(
                onPressed: () => onFilterOptionsChanged(const FilterOptions()),
                icon: const Icon(LucideIcons.rotateCounterClockwise),
                label: const Text('Reset to Defaults'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliderOption(
    BuildContext context,
    String label,
    double value,
    double min,
    double max,
    void Function(double) onChanged, {
    int? divisions,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              value.toStringAsFixed(1),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          onChanged: onChanged,
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

/// Filter comparison widget for A/B testing
class FilterComparisonWidget extends StatelessWidget {
  const FilterComparisonWidget({
    super.key,
    required this.originalImageData,
    required this.filteredImageData,
    required this.filterName,
    this.width = 300,
    this.height = 200,
  });

  final List<int> originalImageData;
  final List<int> filteredImageData;
  final String filterName;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(11),
        child: Row(
          children: [
            // Original half
            Expanded(
              child: Container(
                color: Colors.grey[200],
                child: Stack(
                  children: [
                    if (originalImageData.isNotEmpty)
                      Image.memory(
                        originalImageData as List<int>,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Original',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Divider
            Container(
              width: 2,
              color: Theme.of(context).colorScheme.primary,
            ),

            // Filtered half
            Expanded(
              child: Container(
                color: Colors.grey[200],
                child: Stack(
                  children: [
                    if (filteredImageData.isNotEmpty)
                      Image.memory(
                        filteredImageData as List<int>,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          filterName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}