import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:bharattesting_core/core.dart';
import '../models/document_scanner_state.dart';

/// Widget for displaying a list of scanned page thumbnails
class PageThumbnailList extends StatelessWidget {
  const PageThumbnailList({
    super.key,
    required this.pages,
    this.selectedPageId,
    required this.onPageSelected,
    required this.onPageDeleted,
    this.onPageReordered,
    this.isVertical = false,
    this.showDetails = false,
    this.maxHeight = 120,
  });

  final List<ScannedPage> pages;
  final String? selectedPageId;
  final void Function(String pageId) onPageSelected;
  final void Function(String pageId) onPageDeleted;
  final void Function(int oldIndex, int newIndex)? onPageReordered;
  final bool isVertical;
  final bool showDetails;
  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    if (pages.isEmpty) {
      return SizedBox(
        height: isVertical ? null : maxHeight,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                LucideIcons.imageOff,
                size: 32,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
              const SizedBox(height: 8),
              Text(
                'No pages scanned yet',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (isVertical) {
      return _buildVerticalList(context);
    } else {
      return _buildHorizontalList(context);
    }
  }

  /// Build horizontal scrolling list
  Widget _buildHorizontalList(BuildContext context) {
    return Container(
      height: maxHeight,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: onPageReordered != null
        ? ReorderableListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: pages.length,
            onReorder: onPageReordered!,
            itemBuilder: (context, index) {
              return _PageThumbnailTile(
                key: ValueKey(pages[index].id),
                page: pages[index],
                isSelected: pages[index].id == selectedPageId,
                isVertical: false,
                showDetails: showDetails,
                onTap: () => onPageSelected(pages[index].id),
                onDelete: () => onPageDeleted(pages[index].id),
                index: index,
              );
            },
          )
        : ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: pages.length,
            itemBuilder: (context, index) {
              return _PageThumbnailTile(
                key: ValueKey(pages[index].id),
                page: pages[index],
                isSelected: pages[index].id == selectedPageId,
                isVertical: false,
                showDetails: showDetails,
                onTap: () => onPageSelected(pages[index].id),
                onDelete: () => onPageDeleted(pages[index].id),
                index: index,
              );
            },
          ),
    );
  }

  /// Build vertical scrolling list
  Widget _buildVerticalList(BuildContext context) {
    if (onPageReordered != null) {
      return ReorderableListView.builder(
        itemCount: pages.length,
        onReorder: onPageReordered!,
        itemBuilder: (context, index) {
          return _PageThumbnailTile(
            key: ValueKey(pages[index].id),
            page: pages[index],
            isSelected: pages[index].id == selectedPageId,
            isVertical: true,
            showDetails: showDetails,
            onTap: () => onPageSelected(pages[index].id),
            onDelete: () => onPageDeleted(pages[index].id),
            index: index,
          );
        },
      );
    } else {
      return ListView.builder(
        itemCount: pages.length,
        itemBuilder: (context, index) {
          return _PageThumbnailTile(
            key: ValueKey(pages[index].id),
            page: pages[index],
            isSelected: pages[index].id == selectedPageId,
            isVertical: true,
            showDetails: showDetails,
            onTap: () => onPageSelected(pages[index].id),
            onDelete: () => onPageDeleted(pages[index].id),
            index: index,
          );
        },
      );
    }
  }
}

/// Individual page thumbnail tile
class _PageThumbnailTile extends StatelessWidget {
  const _PageThumbnailTile({
    super.key,
    required this.page,
    required this.isSelected,
    required this.isVertical,
    required this.showDetails,
    required this.onTap,
    required this.onDelete,
    required this.index,
  });

  final ScannedPage page;
  final bool isSelected;
  final bool isVertical;
  final bool showDetails;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final int index;

  @override
  Widget build(BuildContext context) {
    if (isVertical) {
      return _buildVerticalTile(context);
    } else {
      return _buildHorizontalTile(context);
    }
  }

  /// Build horizontal tile (for bottom list)
  Widget _buildHorizontalTile(BuildContext context) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            // Thumbnail container
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.outline,
                    width: isSelected ? 2 : 1,
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
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(7),
                  child: Stack(
                    children: [
                      // Thumbnail image
                      _buildThumbnailImage(),

                      // Status overlay
                      _buildStatusOverlay(context),

                      // Delete button
                      Positioned(
                        top: 4,
                        right: 4,
                        child: _buildDeleteButton(context),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Page number
            const SizedBox(height: 4),
            Text(
              '${index + 1}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build vertical tile (for side panel)
  Widget _buildVerticalTile(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        elevation: isSelected ? 4 : 1,
        color: isSelected
          ? Theme.of(context).colorScheme.primaryContainer
          : null,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Thumbnail
                Container(
                  width: 60,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: Stack(
                      children: [
                        _buildThumbnailImage(),
                        _buildStatusOverlay(context),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Page ${index + 1}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),

                      if (showDetails) ...[
                        Text(
                          '${page.bestImageDimensions.$1} × ${page.bestImageDimensions.$2}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          page.fileSizeText,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        if (page.hasOcrText)
                          Text(
                            'OCR detected',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        Text(
                          page.appliedFilter.displayName,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ] else ...[
                        Text(
                          page.fileSizeText,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          page.status.displayName,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: _getStatusColor(context, page.status),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Actions
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildDeleteButton(context),
                    const SizedBox(height: 8),
                    Icon(
                      LucideIcons.gripVertical,
                      size: 16,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build thumbnail image
  Widget _buildThumbnailImage() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.grey[100],
      child: page.thumbnailData != null
        ? Image.memory(
            page.thumbnailData!,
            fit: BoxFit.cover,
          )
        : page.bestImageData.isNotEmpty
        ? Image.memory(
            page.bestImageData,
            fit: BoxFit.cover,
          )
        : Icon(
            LucideIcons.image,
            size: isVertical ? 24 : 20,
            color: Colors.grey[400],
          ),
    );
  }

  /// Build status overlay
  Widget _buildStatusOverlay(BuildContext context) {
    if (page.status == PageStatus.processing) {
      return Container(
        color: Colors.black54,
        child: const Center(
          child: SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ),
      );
    }

    if (page.status == PageStatus.error) {
      return Container(
        color: Colors.red.withOpacity(0.8),
        child: const Center(
          child: Icon(
            LucideIcons.alertCircle,
            color: Colors.white,
            size: 16,
          ),
        ),
      );
    }

    // Show OCR indicator
    if (page.hasOcrText) {
      return Positioned(
        bottom: 2,
        left: 2,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Icon(
            LucideIcons.type,
            color: Colors.white,
            size: 8,
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  /// Build delete button
  Widget _buildDeleteButton(BuildContext context) {
    return GestureDetector(
      onTap: onDelete,
      child: Container(
        width: isVertical ? 24 : 20,
        height: isVertical ? 24 : 20,
        decoration: BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Icon(
          LucideIcons.x,
          color: Colors.white,
          size: isVertical ? 12 : 10,
        ),
      ),
    );
  }

  /// Get color for page status
  Color _getStatusColor(BuildContext context, PageStatus status) {
    switch (status) {
      case PageStatus.captured:
        return Theme.of(context).colorScheme.onSurface.withOpacity(0.7);
      case PageStatus.processing:
        return Theme.of(context).colorScheme.primary;
      case PageStatus.processed:
        return Theme.of(context).colorScheme.secondary;
      case PageStatus.error:
        return Theme.of(context).colorScheme.error;
    }
  }
}

/// Page thumbnail grid for desktop layout
class PageThumbnailGrid extends StatelessWidget {
  const PageThumbnailGrid({
    super.key,
    required this.pages,
    this.selectedPageId,
    required this.onPageSelected,
    required this.onPageDeleted,
    this.onPageReordered,
    this.crossAxisCount = 3,
    this.childAspectRatio = 0.7,
  });

  final List<ScannedPage> pages;
  final String? selectedPageId;
  final void Function(String pageId) onPageSelected;
  final void Function(String pageId) onPageDeleted;
  final void Function(int oldIndex, int newIndex)? onPageReordered;
  final int crossAxisCount;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    if (pages.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              LucideIcons.imageOff,
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No pages scanned yet',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Capture or upload documents to get started',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: pages.length,
      itemBuilder: (context, index) {
        return _PageThumbnailCard(
          page: pages[index],
          isSelected: pages[index].id == selectedPageId,
          onTap: () => onPageSelected(pages[index].id),
          onDelete: () => onPageDeleted(pages[index].id),
          index: index,
        );
      },
    );
  }
}

/// Page thumbnail card for grid view
class _PageThumbnailCard extends StatelessWidget {
  const _PageThumbnailCard({
    required this.page,
    required this.isSelected,
    required this.onTap,
    required this.onDelete,
    required this.index,
  });

  final ScannedPage page;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 8 : 2,
      color: isSelected
        ? Theme.of(context).colorScheme.primaryContainer
        : null,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image area
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(7),
                  child: Stack(
                    children: [
                      Container(
                        color: Colors.grey[100],
                        child: page.thumbnailData != null
                          ? Image.memory(
                              page.thumbnailData!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            )
                          : const Center(
                              child: Icon(
                                LucideIcons.image,
                                size: 32,
                                color: Colors.grey,
                              ),
                            ),
                      ),

                      // Status overlay
                      if (page.status == PageStatus.processing)
                        Container(
                          color: Colors.black54,
                          child: const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                        ),

                      // Delete button
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: onDelete,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                            child: const Icon(
                              LucideIcons.x,
                              color: Colors.white,
                              size: 12,
                            ),
                          ),
                        ),
                      ),

                      // OCR indicator
                      if (page.hasOcrText)
                        Positioned(
                          bottom: 4,
                          left: 4,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              LucideIcons.type,
                              color: Colors.white,
                              size: 10,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            // Info section
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Page ${index + 1}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    page.fileSizeText,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    '${page.bestImageDimensions.$1} × ${page.bestImageDimensions.$2}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}