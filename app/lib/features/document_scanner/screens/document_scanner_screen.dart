import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/l10n.dart';
import '../providers/document_scanner_provider.dart';
import '../widgets/document_upload_zone.dart';
import '../widgets/scanner_preview_panel.dart';
import '../widgets/scanner_controls_panel.dart';

class DocumentScannerScreen extends ConsumerWidget {
  const DocumentScannerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(documentScannerProvider);
    final notifier = ref.read(documentScannerProvider.notifier);

    return Column(
      children: [
        if (state.isProcessing)
          const LinearProgressIndicator(),
        
        Expanded(
          child: !state.hasDocument
              ? _buildEmptyState(context, notifier)
              : _buildScannerInterface(context, state, notifier),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, DocumentScannerNotifier notifier) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: DocumentUploadZone(
          onDocumentSelected: notifier.addDocument,
          onDocumentPicked: () => notifier.pickDocument(),
        ),
      ),
    );
  }

  Widget _buildScannerInterface(
    BuildContext context,
    DocumentScannerState state,
    DocumentScannerNotifier notifier,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 900;

        if (isWide) {
          return Row(
            children: [
              Expanded(
                flex: 2,
                child: ScannerPreviewPanel(
                  document: state.currentDocument!,
                  onEnhance: notifier.enhanceDocument,
                ),
              ),
              const VerticalDivider(width: 1),
              SizedBox(
                width: 300,
                child: ScannerControlsPanel(
                  state: state,
                  onDownload: notifier.downloadDocument,
                  onClear: notifier.clearDocument,
                ),
              ),
            ],
          );
        } else {
          return Column(
            children: [
              Expanded(
                child: ScannerPreviewPanel(
                  document: state.currentDocument!,
                  onEnhance: notifier.enhanceDocument,
                ),
              ),
              const Divider(height: 1),
              ScannerControlsPanel(
                state: state,
                onDownload: notifier.downloadDocument,
                onClear: notifier.clearDocument,
              ),
            ],
          );
        }
      },
    );
  }
}
