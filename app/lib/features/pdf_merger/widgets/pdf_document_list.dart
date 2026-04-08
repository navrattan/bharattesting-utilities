import 'package:flutter/material.dart';
import '../models/pdf_merger_state.dart';

class PdfDocumentList extends StatelessWidget {
  final List<PdfDocument> documents;
  final Function(PdfDocument?) onDocumentSelected;
  final Function(String) onDocumentRemoved;

  const PdfDocumentList({
    super.key,
    required this.documents,
    required this.onDocumentSelected,
    required this.onDocumentRemoved,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: documents.map((doc) => _buildDocumentCard(context, doc)).toList(),
    );
  }

  Widget _buildDocumentCard(BuildContext context, PdfDocument document) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => onDocumentSelected(document),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.picture_as_pdf,
                  color: theme.colorScheme.onPrimaryContainer,
                  size: 20,
                ),
              ),

              const SizedBox(width: 12),

              // Document info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      document.displayName,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${document.pageCountText} • ${document.fileSizeText}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              // Status indicator
              _buildStatusIndicator(document, theme),

              const SizedBox(width: 8),

              // Remove button
              IconButton(
                onPressed: () => onDocumentRemoved(document.id),
                icon: const Icon(Icons.close, size: 18),
                visualDensity: VisualDensity.compact,
                tooltip: 'Remove document',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(PdfDocument document, ThemeData theme) {
    switch (document.status) {
      case DocumentStatus.loading:
        return const SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        );

      case DocumentStatus.ready:
        return const Icon(
          Icons.check_circle,
          size: 16,
          color: Colors.green,
        );

      case DocumentStatus.loading:
        return const SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        );

      case DocumentStatus.error:
        return Icon(
          Icons.error,
          size: 16,
          color: theme.colorScheme.error,
        );
    }
  }
}