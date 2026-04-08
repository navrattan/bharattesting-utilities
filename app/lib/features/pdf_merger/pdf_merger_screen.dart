import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models/pdf_merger_state.dart';
import 'providers/pdf_merger_provider.dart';
import 'widgets/pdf_drop_zone.dart';
import 'widgets/pdf_page_grid.dart';
import 'widgets/pdf_document_list.dart';
import 'widgets/merge_controls_panel.dart';
import 'widgets/merge_statistics_panel.dart';
import 'widgets/password_dialog.dart';

class PdfMergerScreen extends ConsumerStatefulWidget {
  const PdfMergerScreen({super.key});

  @override
  ConsumerState<PdfMergerScreen> createState() => _PdfMergerScreenState();
}

class _PdfMergerScreenState extends ConsumerState<PdfMergerScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pdfMergerProvider);
    final notifier = ref.read(pdfMergerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Merger'),
        actions: [
          if (state.mergedPdfData != null)
            IconButton(
              icon: const Icon(Icons.download),
              onPressed: notifier.downloadMergedPdf,
              tooltip: 'Download Merged PDF',
            ),
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () => _showClearConfirmation(context, notifier),
            tooltip: 'Clear All',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Files', icon: Icon(Icons.description)),
            Tab(text: 'Pages', icon: Icon(Icons.grid_view)),
            Tab(text: 'Settings', icon: Icon(Icons.settings)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Files tab
          _buildFilesTab(context, state, notifier),

          // Pages tab
          _buildPagesTab(context, state, notifier),

          // Settings tab
          _buildSettingsTab(context, state, notifier),
        ],
      ),
      floatingActionButton: state.pages.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: state.isProcessing ? null : notifier.mergePdfs,
              icon: state.isProcessing
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.merge),
              label: Text(state.isProcessing ? 'Merging...' : 'Merge PDFs'),
            )
          : null,
    );
  }

  Widget _buildFilesTab(BuildContext context, PdfMergerState state, PdfMerger notifier) {
    return Column(
      children: [
        PdfDropZone(
          onFilesAdded: notifier.addDocumentsFromDrop,
        ),
        Expanded(
          child: state.documents.isEmpty
              ? _buildEmptyState(
                  context,
                  Icons.upload_file,
                  'No PDF files added yet',
                  'Add files to start merging',
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    PdfDocumentList(
                      documents: state.documents,
                      onDocumentSelected: notifier.selectDocument,
                      onDocumentRemoved: notifier.removeDocument,
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _buildPagesTab(BuildContext context, PdfMergerState state, PdfMerger notifier) {
    if (state.pages.isEmpty) {
      return _buildEmptyState(
        context,
        Icons.grid_on,
        'No pages to display',
        'Add PDF files first',
      );
    }

    return PdfPageGrid(
      pages: state.pages,
      onPageSelected: notifier.selectPage,
      onPageRotated: notifier.rotatePage,
      onPageDuplicated: notifier.duplicatePage,
      onPageRemoved: notifier.removePage,
      onPagesReordered: notifier.reorderPages,
    );
  }

  Widget _buildSettingsTab(BuildContext context, PdfMergerState state, PdfMerger notifier) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          MergeControlsPanel(
            enableEncryption: state.enableEncryption,
            onToggleEncryption: notifier.toggleEncryption,
            password: state.encryptionPassword,
            onPasswordChanged: notifier.updateEncryptionPassword,
            permissions: state.permissions,
            onPermissionsChanged: notifier.updatePermissions,
            mergeOptions: state.mergeOptions,
            onMergeOptionsChanged: notifier.updateMergeOptions,
          ),
          const SizedBox(height: 16),
          if (state.pages.isNotEmpty)
            MergeStatisticsPanel(
              statistics: notifier.calculateStatistics(),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, IconData icon, String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Theme.of(context).colorScheme.outline),
          const SizedBox(height: 16),
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }

  Future<void> _showClearConfirmation(BuildContext context, PdfMerger notifier) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All?'),
        content: const Text('This will remove all documents and pages.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      notifier.clearAll();
    }
  }
}
