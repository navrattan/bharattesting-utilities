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
import '../../shared/widgets/responsive_layout.dart';

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
        bottom: isMobile(context)
            ? TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(icon: Icon(Icons.upload_file), text: 'Upload'),
                  Tab(icon: Icon(Icons.view_module), text: 'Pages'),
                  Tab(icon: Icon(Icons.settings), text: 'Settings'),
                ],
              )
            : null,
        actions: [
          if (state.documents.isNotEmpty)
            IconButton(
              onPressed: () => _showClearConfirmation(context, notifier),
              icon: const Icon(Icons.clear_all),
              tooltip: 'Clear all',
            ),
          if (state.mergedPdfData != null)
            IconButton(
              onPressed: notifier.downloadMergedPdf,
              icon: const Icon(Icons.download),
              tooltip: 'Download merged PDF',
            ),
          IconButton(
            onPressed: notifier.toggleAdvancedSettings,
            icon: Icon(state.showAdvancedSettings
                ? Icons.settings
                : Icons.settings_outlined),
            tooltip: 'Advanced settings',
          ),
        ],
      ),
      body: Stack(
        children: [
          // Main content
          isMobile(context)
              ? _buildMobileLayout(state, notifier)
              : isTablet(context)
                  ? _buildTabletLayout(state, notifier)
                  : _buildDesktopLayout(state, notifier),

          // Processing overlay
          if (state.isProcessing) _buildProcessingOverlay(state),

          // Password dialog
          if (state.showPasswordDialog)
            PasswordDialog(
              onPasswordSet: (password) {
                notifier.updateEncryptionPassword(password);
                notifier.setPasswordDialogVisible(false);
              },
              onCancel: () => notifier.setPasswordDialogVisible(false),
            ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(PdfMergerState state, PdfMerger notifier) {
    return TabBarView(
      controller: _tabController,
      children: [
        // Upload tab
        SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              PdfDropZone(
                onFilesAdded: notifier.addDocumentsFromDrop,
                isLoading: state.isProcessing,
              ),
              const SizedBox(height: 16),
              if (state.documents.isNotEmpty)
                PdfDocumentList(
                  documents: state.documents,
                  onDocumentSelected: notifier.selectDocument,
                  onDocumentRemoved: notifier.removeDocument,
                ),
            ],
          ),
        ),

        // Pages tab
        state.pages.isEmpty
            ? const Center(
                child: Text('Upload PDF files to see pages'),
              )
            : PdfPageGrid(
                pages: state.pages,
                onPageSelected: notifier.selectPage,
                onPageRotated: notifier.rotatePage,
                onPageDuplicated: notifier.duplicatePage,
                onPageRemoved: notifier.removePage,
                onPagesReordered: notifier.reorderPages,
              ),

        // Settings tab
        SingleChildScrollView(
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
        ),
      ],
    );
  }

  Widget _buildTabletLayout(PdfMergerState state, PdfMerger notifier) {
    return Row(
      children: [
        // Left panel - Upload & Documents
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                PdfDropZone(
                  onFilesAdded: notifier.addDocumentsFromDrop,
                  isLoading: state.isProcessing,
                ),
                const SizedBox(height: 16),
                if (state.documents.isNotEmpty)
                  PdfDocumentList(
                    documents: state.documents,
                    onDocumentSelected: notifier.selectDocument,
                    onDocumentRemoved: notifier.removeDocument,
                  ),
                const SizedBox(height: 16),
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
              ],
            ),
          ),
        ),

        const VerticalDivider(width: 1),

        // Right panel - Page Grid
        Expanded(
          flex: 2,
          child: state.pages.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.picture_as_pdf_outlined,
                          size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('Upload PDF files to see pages'),
                    ],
                  ),
                )
              : Column(
                  children: [
                    if (state.pages.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: MergeStatisticsPanel(
                          statistics: notifier.calculateStatistics(),
                        ),
                      ),
                    Expanded(
                      child: PdfPageGrid(
                        pages: state.pages,
                        onPageSelected: notifier.selectPage,
                        onPageRotated: notifier.rotatePage,
                        onPageDuplicated: notifier.duplicatePage,
                        onPageRemoved: notifier.removePage,
                        onPagesReordered: notifier.reorderPages,
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(PdfMergerState state, PdfMerger notifier) {
    return Row(
      children: [
        // Left sidebar - Upload & Controls
        SizedBox(
          width: 350,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PdfDropZone(
                  onFilesAdded: notifier.addDocumentsFromDrop,
                  isLoading: state.isProcessing,
                ),
                const SizedBox(height: 24),

                if (state.documents.isNotEmpty) ...[
                  Text(
                    'Loaded Documents',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 12),
                  PdfDocumentList(
                    documents: state.documents,
                    onDocumentSelected: notifier.selectDocument,
                    onDocumentRemoved: notifier.removeDocument,
                  ),
                  const SizedBox(height: 24),
                ],

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

                const SizedBox(height: 24),

                if (state.pages.isNotEmpty)
                  MergeStatisticsPanel(
                    statistics: notifier.calculateStatistics(),
                  ),

                const SizedBox(height: 24),

                // Merge button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: state.pages.isEmpty || state.isProcessing
                        ? null
                        : notifier.mergePdfs,
                    icon: state.isProcessing
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.merge),
                    label:
                        Text(state.isProcessing ? 'Merging...' : 'Merge PDFs'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const VerticalDivider(width: 1),

        // Main area - Page Grid
        Expanded(
          child: state.pages.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.picture_as_pdf_outlined,
                        size: 96,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurfaceVariant
                            .withOpacity(0.5),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'No PDF Files Loaded',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Upload PDF files to the left or drag them here to get started',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant
                                  .withOpacity(0.8),
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: notifier.addDocumentsFromPicker,
                        icon: const Icon(Icons.upload_file),
                        label: const Text('Choose PDF Files'),
                      ),
                    ],
                  ),
                )
              : PdfPageGrid(
                  pages: state.pages,
                  onPageSelected: notifier.selectPage,
                  onPageRotated: notifier.rotatePage,
                  onPageDuplicated: notifier.duplicatePage,
                  onPageRemoved: notifier.removePage,
                  onPagesReordered: notifier.reorderPages,
                ),
        ),
      ],
    );
  }

  Widget _buildProcessingOverlay(PdfMergerState state) {
    return Positioned.fill(
      child: Container(
        color: Colors.black54,
        child: Center(
          child: Card(
            margin: const EdgeInsets.all(32),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 24),
                  Text(
                    'Processing PDF Merge',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: state.processingProgress / 100,
                  ),
                  const SizedBox(height: 8),
                  Text('${state.processingProgress}% Complete'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showClearConfirmation(BuildContext context, PdfMerger notifier) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Documents?'),
        content: const Text(
          'This will remove all uploaded PDF files and reset the merger. '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              notifier.clearAll();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}
