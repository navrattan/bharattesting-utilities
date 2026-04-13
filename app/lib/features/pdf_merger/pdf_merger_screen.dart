import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/l10n.dart';
import 'models/pdf_merger_state.dart';
import 'providers/pdf_merger_provider.dart';
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

    return Column(
      children: [
        Material(
          color: Theme.of(context).colorScheme.surface,
          child: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Files', icon: Icon(Icons.description)),
              Tab(text: 'Pages', icon: Icon(Icons.grid_view)),
              Tab(text: 'Settings', icon: Icon(Icons.settings)),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildFilesTab(context, state, notifier),
              _buildPagesTab(context, state, notifier),
              _buildSettingsTab(context, state, notifier),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilesTab(BuildContext context, PdfMergerState state, PdfMerger notifier) {
    return Column(
      children: [
        PdfDropZone(
          onFilesAdded: (files) => notifier.addDocuments(files),
        ),
        Expanded(
          child: state.documents.isEmpty
              ? _buildEmptyState(
                  context,
                  Icons.upload_file,
                  'No PDF files added',
                  'Drag and drop PDF files here or click to upload',
                )
              : PdfDocumentList(
                  documents: state.documents,
                  onDocumentRemoved: (id) => notifier.removeDocument(id),
                  onDocumentSelected: (doc) => notifier.selectDocument(doc),
                  onReorder: (oldIdx, newIdx) => notifier.reorderDocuments(oldIdx, newIdx),
                ),
        ),
      ],
    );
  }

  Widget _buildPagesTab(BuildContext context, PdfMergerState state, PdfMerger notifier) {
    if (state.documents.isEmpty) {
      return _buildEmptyState(
        context,
        Icons.grid_view,
        'No pages to display',
        'Add PDF files first to manage individual pages',
      );
    }

    return Column(
      children: [
        MergeStatisticsPanel(statistics: notifier.statistics),
        Expanded(
          child: PdfPageGrid(
            pages: state.pages,
            onPageSelected: (page) => notifier.selectPage(page?.id ?? ''),
            onPageRemoved: (id) => notifier.removePage(id),
            onPageRotated: (id, rotation) => notifier.rotatePage(id, rotation),
            onPageDuplicated: (id) => notifier.duplicatePage(id),
            onPagesReordered: (oldIdx, newIdx) => notifier.reorderPages(oldIdx, newIdx),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsTab(BuildContext context, PdfMergerState state, PdfMerger notifier) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: MergeControlsPanel(
        mergeOptions: state.mergeOptions,
        onMergeOptionsChanged: (options) => notifier.updateMergeOptions(options),
        enableEncryption: state.enableEncryption,
        onToggleEncryption: () => notifier.toggleEncryption(!state.enableEncryption),
        password: state.encryptionPassword,
        onPasswordChanged: (val) => notifier.updateEncryptionPassword(val),
        permissions: state.permissions,
        onPermissionsChanged: (perms) => notifier.updatePermissions(perms),
        isProcessing: state.isProcessing,
        onMerge: () => notifier.mergePdfs(),
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
}
