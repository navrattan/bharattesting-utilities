import 'package:flutter/material.dart';
import '../models/pdf_merger_state.dart';

class PdfPageGrid extends StatefulWidget {
  final List<PdfPageThumbnail> pages;
  final Function(String?) onPageSelected;
  final Function(String, PageRotation) onPageRotated;
  final Function(String) onPageDuplicated;
  final Function(String) onPageRemoved;
  final Function(int, int) onPagesReordered;

  const PdfPageGrid({
    super.key,
    required this.pages,
    required this.onPageSelected,
    required this.onPageRotated,
    required this.onPageDuplicated,
    required this.onPageRemoved,
    required this.onPagesReordered,
  });

  @override
  State<PdfPageGrid> createState() => _PdfPageGridState();
}

class _PdfPageGridState extends State<PdfPageGrid> {
  String? _draggedPageId;
  int? _dragTargetIndex;

  @override
  Widget build(BuildContext context) {
    if (widget.pages.isEmpty) {
      return const Center(
        child: Text('No pages to display'),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = _calculateCrossAxisCount(constraints.maxWidth);

        return ReorderableGridView(
          crossAxisCount: crossAxisCount,
          padding: const EdgeInsets.all(16),
          children: widget.pages.asMap().entries.map((entry) {
            final index = entry.key;
            final page = entry.value;

            return _buildPageCard(page, index);
          }).toList(),
          onReorder: (oldIndex, newIndex) {
            widget.onPagesReordered(oldIndex, newIndex);
          },
        );
      },
    );
  }

  Widget _buildPageCard(PdfPageThumbnail page, int index) {
    final theme = Theme.of(context);

    return Card(
      key: ValueKey(page.id),
      margin: const EdgeInsets.all(4),
      elevation: page.isSelected ? 4 : 1,
      child: InkWell(
        onTap: () => widget.onPageSelected(page.id),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: page.isSelected
                ? Border.all(
                    color: theme.colorScheme.primary,
                    width: 2,
                  )
                : null,
          ),
          child: Column(
            children: [
              // Header with page number and status
              _buildPageHeader(page, theme),

              // Thumbnail
              Expanded(
                child: _buildPageThumbnail(page, theme),
              ),

              // Footer with actions
              _buildPageActions(page, theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageHeader(PdfPageThumbnail page, ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: page.isSelected
            ? theme.colorScheme.primaryContainer
            : theme.colorScheme.surfaceVariant,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          Text(
            'Page ${page.displayGlobalNumber}',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: page.isSelected
                  ? theme.colorScheme.onPrimaryContainer
                  : theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const Spacer(),
          if (page.isDuplicate)
            Icon(
              Icons.content_copy,
              size: 12,
              color: page.isSelected
                  ? theme.colorScheme.onPrimaryContainer
                  : theme.colorScheme.onSurfaceVariant,
            ),
          if (page.rotation != PageRotation.none)
            Icon(
              Icons.rotate_right,
              size: 12,
              color: page.isSelected
                  ? theme.colorScheme.onPrimaryContainer
                  : theme.colorScheme.onSurfaceVariant,
            ),
        ],
      ),
    );
  }

  Widget _buildPageThumbnail(PdfPageThumbnail page, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: page.isReady && page.thumbnailData != null
          ? _buildActualThumbnail(page)
          : _buildPlaceholderThumbnail(page, theme),
    );
  }

  Widget _buildActualThumbnail(PdfPageThumbnail page) {
    Widget thumbnail = Image.memory(
      page.thumbnailData!,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return _buildErrorThumbnail();
      },
    );

    // Apply rotation transform
    if (page.rotation != PageRotation.none) {
      thumbnail = Transform.rotate(
        angle: page.rotation.degrees * 3.14159 / 180,
        child: thumbnail,
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: thumbnail,
    );
  }

  Widget _buildPlaceholderThumbnail(PdfPageThumbnail page, ThemeData theme) {
    if (page.status == ThumbnailStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (page.status == ThumbnailStatus.error) {
      return _buildErrorThumbnail();
    }

    // Default placeholder
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.picture_as_pdf_outlined,
            size: 32,
            color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
          ),
          const SizedBox(height: 4),
          Text(
            'PDF Page',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorThumbnail() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 32),
          SizedBox(height: 4),
          Text('Error', style: TextStyle(color: Colors.red, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildPageActions(PdfPageThumbnail page, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(
            icon: Icons.rotate_right,
            tooltip: 'Rotate 90°',
            onPressed: () => widget.onPageRotated(page.id, PageRotation.rotate90),
            theme: theme,
          ),
          _buildActionButton(
            icon: Icons.content_copy,
            tooltip: 'Duplicate',
            onPressed: () => widget.onPageDuplicated(page.id),
            theme: theme,
          ),
          _buildActionButton(
            icon: Icons.delete_outline,
            tooltip: 'Remove',
            onPressed: () => _confirmRemovePage(page),
            theme: theme,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
    required ThemeData theme,
  }) {
    return IconButton(
      icon: Icon(icon, size: 16),
      iconSize: 16,
      padding: const EdgeInsets.all(4),
      constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
      tooltip: tooltip,
      onPressed: onPressed,
      color: theme.colorScheme.onSurfaceVariant,
    );
  }

  void _confirmRemovePage(PdfPageThumbnail page) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Page?'),
        content: Text(
          'Remove page ${page.displayGlobalNumber} from the merge? '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              widget.onPageRemoved(page.id);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  int _calculateCrossAxisCount(double width) {
    if (width < 600) return 2;  // Mobile
    if (width < 900) return 3;  // Tablet
    if (width < 1200) return 4; // Small desktop
    return 5; // Large desktop
  }
}

// Custom reorderable grid view implementation
class ReorderableGridView extends StatefulWidget {
  final List<Widget> children;
  final int crossAxisCount;
  final EdgeInsets padding;
  final Function(int, int) onReorder;

  const ReorderableGridView({
    super.key,
    required this.children,
    required this.crossAxisCount,
    this.padding = EdgeInsets.zero,
    required this.onReorder,
  });

  @override
  State<ReorderableGridView> createState() => _ReorderableGridViewState();
}

class _ReorderableGridViewState extends State<ReorderableGridView> {
  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      padding: widget.padding,
      itemCount: _calculateRowCount(),
      onReorder: _handleReorder,
      itemBuilder: (context, rowIndex) {
        return _buildGridRow(rowIndex);
      },
    );
  }

  Widget _buildGridRow(int rowIndex) {
    final startIndex = rowIndex * widget.crossAxisCount;
    final endIndex = (startIndex + widget.crossAxisCount)
        .clamp(0, widget.children.length);

    final rowChildren = widget.children.sublist(startIndex, endIndex);

    return Container(
      key: ValueKey('row_$rowIndex'),
      height: 200, // Fixed height for grid items
      child: Row(
        children: rowChildren.map((child) {
          return Expanded(child: child);
        }).toList(),
      ),
    );
  }

  int _calculateRowCount() {
    return (widget.children.length / widget.crossAxisCount).ceil();
  }

  void _handleReorder(int oldIndex, int newIndex) {
    // Convert row-based indices to item-based indices
    final oldItemIndex = oldIndex * widget.crossAxisCount;
    final newItemIndex = newIndex * widget.crossAxisCount;

    if (oldItemIndex < widget.children.length &&
        newItemIndex < widget.children.length) {
      widget.onReorder(oldItemIndex, newItemIndex);
    }
  }
}
