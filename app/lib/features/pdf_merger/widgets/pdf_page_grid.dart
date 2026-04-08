import 'package:flutter/material.dart';
import '../models/pdf_merger_state.dart';

class PdfPageGrid extends StatefulWidget {
  final List<PdfPageThumbnail> pages;
  final void Function(PdfPageThumbnail?) onPageSelected;
  final void Function(String, PageRotation) onPageRotated;
  final void Function(String) onPageDuplicated;
  final void Function(String) onPageRemoved;
  final void Function(int, int) onPagesReordered;

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
  @override
  Widget build(BuildContext context) {
    if (widget.pages.isEmpty) {
      return const Center(child: Text('No pages found'));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: widget.pages.length,
      itemBuilder: (context, index) {
        final page = widget.pages[index];
        return _buildPageCard(context, page);
      },
    );
  }

  Widget _buildPageCard(BuildContext context, PdfPageThumbnail page) {
    final theme = Theme.of(context);

    return Card(
      key: ValueKey(page.id),
      margin: const EdgeInsets.all(4),
      elevation: page.isSelected ? 4 : 1,
      child: InkWell(
        onTap: () => widget.onPageSelected(page),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: page.isSelected
                ? Border.all(color: theme.colorScheme.primary, width: 2)
                : null,
          ),
          child: Column(
            children: [
              _buildPageHeader(theme, page),
              Expanded(
                child: _buildPageThumbnail(theme, page),
              ),
              _buildPageFooter(theme, page),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageHeader(ThemeData theme, PdfPageThumbnail page) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: page.isSelected
            ? theme.colorScheme.primaryContainer
            : theme.colorScheme.surfaceContainerHighest,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Page ${page.displayGlobalNumber}',
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: page.isSelected ? theme.colorScheme.onPrimaryContainer : null,
            ),
          ),
          if (page.isDuplicate)
            Icon(
              Icons.copy,
              size: 12,
              color: theme.colorScheme.onSurfaceVariant,
            ),
        ],
      ),
    );
  }

  Widget _buildPageThumbnail(ThemeData theme, PdfPageThumbnail page) {
    if (page.thumbnailData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RotatedBox(
        quarterTurns: page.rotation.degrees ~/ 90,
        child: Image.memory(
          page.thumbnailData!,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildPageFooter(ThemeData theme, PdfPageThumbnail page) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.rotate_right, size: 18),
            onPressed: () {
              final nextRotation = PageRotation.fromDegrees(page.rotation.degrees + 90);
              widget.onPageRotated(page.id, nextRotation);
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          IconButton(
            icon: const Icon(Icons.copy, size: 18),
            onPressed: () => widget.onPageDuplicated(page.id),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 18),
            onPressed: () => widget.onPageRemoved(page.id),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
