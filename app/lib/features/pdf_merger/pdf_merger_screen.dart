import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models/pdf_merger_state.dart' hide PdfMerger;
import 'providers/pdf_merger_provider.dart';
import 'package:bharattesting_core/core.dart' as core;
import 'widgets/pdf_drop_zone.dart';
import 'widgets/pdf_page_grid.dart';
import 'widgets/pdf_document_list.dart';
import 'widgets/merge_controls_panel.dart';
import 'widgets/merge_statistics_panel.dart';

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
              onPressed: () => notifier.downloadMergedPdf(),
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
          _buildFilesTab(context, state, notifier),
          _buildPagesTab(context, state, notifier),
          _buildSettingsTab(context, state, notifier),
        ],
      ),
      floatingActionButton: state.pages.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: state.isProcessing ? null : () => notifier.mergePdfs(),
              icon: state.isProcessing
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.merge_type),
              label: Text(state.isProcessing ? 'Merging...' : 'Merge PDFs'),
            )
          : null,
    );
  }

  Widget _buildFilesTab(BuildContext context, PdfMergerState state, PdfMerger notifier) {
    return Column(
      children: [
        PdfDropZone(
          onFilesAdded: (files) => notifier.addDocumentsFromDrop(files),
        ),
        Expanded(
          child: state.documents.isEmpty
              ? _buildEmptyState(
                  context,
                  Icons.upload_file,
                  'No PDF files added',
                  'Upload or drag and drop PDF files to start merging',
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    PdfDocumentList(
                      documents: state.documents,
                      onDocumentSelected: (doc) => notifier.selectDocument(doc),
                      onDocumentRemoved: (id) => notifier.removeDocument(id),
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
        Icons.grid_view,
        'No pages to display',
        'Add PDF files first to manage individual pages',
      );
    }

    return PdfPageGrid(
      pages: state.pages,
      onPageSelected: (page) => notifier.selectPage(page),
      onPageRotated: (id, rot) => notifier.rotatePage(id, core.PageRotation.fromDegrees(rot.degrees)),
      onPageDuplicated: (id) => notifier.duplicatePage(id),
      onPageRemoved: (id) => notifier.removePage(id),
      onPagesReordered: (oldIdx, newIdx) => notifier.reorderPages(oldIdx, newIdx),
    );
  }

  Widget _buildSettingsTab(BuildContext context, PdfMergerState state, PdfMerger notifier) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          MergeControlsPanel(
            enableEncryption: state.enableEncryption,
            onToggleEncryption: () => notifier.toggleEncryption(),
            password: state.encryptionPassword,
            onPasswordChanged: (val) => notifier.updateEncryptionPassword(val),
            permissions: core.PdfPermissions(
              allowPrinting: state.permissions.allowPrinting,
              allowCopy: state.permissions.allowCopy,
              allowModification: state.permissions.allowModification,
              allowAnnotations: state.permissions.allowAnnotations,
            ),
            onPermissionsChanged: (val) => notifier.updatePermissions(PdfPermissions(
              allowPrinting: val.allowPrinting,
              allowCopy: val.allowCopy,
              allowModification: val.allowModification,
              allowAnnotations: val.allowAnnotations,
            )),
            mergeOptions: core.PdfMergeOptions(
              generateBookmarks: state.mergeOptions.generateBookmarks,
              preserveMetadata: state.mergeOptions.preserveMetadata,
              optimizeForSize: state.mergeOptions.optimizeForSize,
            ),
            onMergeOptionsChanged: (val) => notifier.updateMergeOptions(PdfMergeOptions(
              generateBookmarks: val.generateBookmarks,
              preserveMetadata: val.preserveMetadata,
              optimizeForSize: val.optimizeForSize,
            )),
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
          Icon(icon, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(subtitle, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[600])),
        ],
      ),
    );
  }

  Future<void> _showClearConfirmation(BuildContext context, PdfMerger notifier) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All?'),
        content: const Text('This will remove all documents and pages. This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
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
