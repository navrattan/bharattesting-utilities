import 'package:flutter/material.dart';
import '../models/pdf_merger_state.dart';

class PdfDocumentList extends StatelessWidget {
  final List<PdfDocument> documents;
  final void Function(PdfDocument?) onDocumentSelected;
  final void Function(String) onDocumentRemoved;

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
              _buildStatusIcon(theme, document.status),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      document.displayName,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${document.pageCountText} • ${document.fileSizeText}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 18),
                onPressed: () => onDocumentRemoved(document.id),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                visualDensity: VisualData.compactDensity,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIcon(ThemeData theme, DocumentStatus status) {
    switch (status) {
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
      case DocumentStatus.error:
        return Icon(
          Icons.error,
          size: 16,
          color: theme.colorScheme.error,
        );
    }
  }
}

class VisualData {
  static const visualDensity = VisualDensity.compact;
  static const compactDensity = VisualDensity(horizontal: -2, vertical: -2);
}
