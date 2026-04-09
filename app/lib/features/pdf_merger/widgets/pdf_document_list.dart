import 'package:flutter/material.dart';
import '../models/pdf_merger_state.dart';

class PdfDocumentList extends StatelessWidget {
  final List<PdfDocument> documents;
  final void Function(PdfDocument?) onDocumentSelected;
  final void Function(String) onDocumentRemoved;
  final void Function(int, int) onReorder;

  const PdfDocumentList({
    super.key,
    required this.documents,
    required this.onDocumentSelected,
    required this.onDocumentRemoved,
    required this.onReorder,
  });

  @override
  Widget build(BuildContext context) {
    if (documents.isEmpty) return const SizedBox.shrink();
    
    return ReorderableListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      onReorder: onReorder,
      children: documents.map((doc) => _buildDocumentCard(context, doc)).toList(),
    );
  }

  Widget _buildDocumentCard(BuildContext context, PdfDocument doc) {
    return Card(
      key: ValueKey(doc.id),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.description),
        title: Text(doc.fileName),
        subtitle: Text(doc.fileSizeText),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: () => onDocumentRemoved(doc.id),
        ),
        onTap: () => onDocumentSelected(doc),
      ),
    );
  }
}
