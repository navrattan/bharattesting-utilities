import 'package:flutter/material.dart';
import '../models/document_scanner_state.dart';

class PageThumbnailList extends StatelessWidget {
  final List<ScannedPage> pages;
  final String? selectedPageId;
  final void Function(ScannedPage) onPageSelected;
  final void Function(String) onPageDeleted;
  final void Function(int, int) onPagesReordered;

  const PageThumbnailList({
    super.key,
    required this.pages,
    required this.selectedPageId,
    required this.onPageSelected,
    required this.onPageDeleted,
    required this.onPagesReordered,
  });

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: pages.length,
      onReorder: onPagesReordered,
      itemBuilder: (context, index) {
        final page = pages[index];
        final isSelected = page.id == selectedPageId;

        return _ThumbnailItem(
          key: ValueKey(page.id),
          page: page,
          isSelected: isSelected,
          onTap: () => onPageSelected(page),
          onDelete: () => onPageDeleted(page.id),
          index: index,
        );
      },
    );
  }
}

class _ThumbnailItem extends StatelessWidget {
  final ScannedPage page;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final int index;

  const _ThumbnailItem({
    required super.key,
    required this.page,
    required this.isSelected,
    required this.onTap,
    required this.onDelete,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Stack(
            children: [
              InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected 
                          ? theme.colorScheme.primary 
                          : theme.colorScheme.outline.withValues(alpha: 0.3),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: page.thumbnailData != null
                        ? Image.memory(
                            page.thumbnailData!,
                            fit: BoxFit.cover,
                          )
                        : const Center(
                            child: Icon(Icons.description_outlined, size: 32),
                          ),
                  ),
                ),
              ),
              if (isSelected)
                Positioned(
                  top: 2,
                  right: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              Positioned(
                top: -8,
                left: -8,
                child: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.error.withValues(alpha: 0.8),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 10,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: onDelete,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Page ${index + 1}',
            style: theme.textTheme.labelSmall?.copyWith(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : null,
              color: isSelected ? theme.colorScheme.primary : null,
            ),
          ),
        ],
      ),
    );
  }
}
