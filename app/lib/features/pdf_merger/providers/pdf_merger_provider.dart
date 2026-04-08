import 'dart:typed_data';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:file_picker/file_picker.dart';
import '../models/pdf_merger_state.dart';
import '../utils/pdf_thumbnail_generator.dart';

part 'pdf_merger_provider.g.dart';

@riverpod
class PdfMerger extends _$PdfMerger {
  @override
  PdfMergerState build() {
    return const PdfMergerState();
  }

  /// Add PDF documents from file picker
  Future<void> addDocumentsFromPicker() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: true,
      withData: true,
    );

    if (result != null) {
      await _addDocuments(result.files);
    }
  }

  /// Add documents from drag and drop
  Future<void> addDocumentsFromDrop(List<PlatformFile> files) async {
    await _addDocuments(files);
  }

  Future<void> _addDocuments(List<PlatformFile> files) async {
    final newDocuments = <PdfDocument>[];
    final newPages = <PdfPageThumbnail>[];

    for (final file in files) {
      if (file.bytes == null) continue;

      final id = _generateId();
      final pageCount = await _estimatePageCount(file.bytes!);

      final doc = PdfDocument(
        id: id,
        fileName: file.name,
        data: file.bytes!,
        fileSize: file.bytes!.length,
        pageCount: pageCount,
      );

      newDocuments.add(doc);

      // Generate thumbnails and add pages
      for (int i = 0; i < pageCount; i++) {
        final thumbnail = await PdfThumbnailGenerator.generateThumbnail(
          file.bytes!,
          i,
        );

        newPages.add(PdfPageThumbnail(
          id: '${id}_$i',
          documentId: id,
          pageNumber: i,
          globalIndex: state.pages.length + newPages.length,
          dimensions: const PageDimensions(width: 595, height: 842),
          thumbnailData: thumbnail,
          status: ThumbnailStatus.ready,
        ));
      }
    }

    state = state.copyWith(
      documents: [...state.documents, ...newDocuments],
      pages: [...state.pages, ...newPages],
    );
  }

  /// Remove a document and its pages
  void removeDocument(String documentId) {
    state = state.copyWith(
      documents: state.documents.where((d) => d.id != documentId).toList(),
      pages: state.pages.where((p) => p.documentId != documentId).toList(),
    );
    _recalculateGlobalIndices();
  }

  /// Remove a single page
  void removePage(String pageId) {
    state = state.copyWith(
      pages: state.pages.where((p) => p.id != pageId).toList(),
    );
    _recalculateGlobalIndices();
  }

  /// Select a page
  void selectPage(PdfPageThumbnail? page) {
    state = state.copyWith(selectedPage: page);
  }

  /// Select a document
  void selectDocument(PdfDocument? document) {
    state = state.copyWith(selectedDocument: document);
  }

  /// Duplicate a page
  void duplicatePage(String pageId) {
    final index = state.pages.indexWhere((p) => p.id == pageId);
    if (index == -1) return;

    final page = state.pages[index];
    final newPage = page.copyWith(
      id: '${page.id}_dup_${DateTime.now().millisecondsSinceEpoch}',
      isDuplicate: true,
    );
    
    final newPages = List<PdfPageThumbnail>.from(state.pages);
    newPages.insert(index + 1, newPage);
    
    state = state.copyWith(pages: newPages);
    _recalculateGlobalIndices();
  }

  /// Reorder pages
  void reorderPages(int oldIndex, int newIndex) {
    final pages = List<PdfPageThumbnail>.from(state.pages);
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = pages.removeAt(oldIndex);
    pages.insert(newIndex, item);
    state = state.copyWith(pages: pages);
    _recalculateGlobalIndices();
  }

  /// Rotate a page
  void rotatePage(String pageId, PageRotation rotation) {
    final pages = state.pages.map((p) {
      if (p.id == pageId) {
        return p.copyWith(rotation: rotation);
      }
      return p;
    }).toList();
    state = state.copyWith(pages: pages);
  }

  /// Update merge options
  void updateMergeOptions(PdfMergeOptions options) {
    state = state.copyWith(mergeOptions: options);
  }

  /// Toggle encryption
  void toggleEncryption() {
    state = state.copyWith(enableEncryption: !state.enableEncryption);
  }

  /// Update output password
  void updateEncryptionPassword(String password) {
    state = state.copyWith(encryptionPassword: password);
  }

  /// Update permissions
  void updatePermissions(PdfPermissions permissions) {
    state = state.copyWith(permissions: permissions);
  }

  /// Toggle advanced settings
  void toggleAdvancedSettings() {
    state = state.copyWith(showAdvancedSettings: !state.showAdvancedSettings);
  }

  /// Toggle password dialog
  void setPasswordDialogVisible(bool visible) {
    state = state.copyWith(showPasswordDialog: visible);
  }

  /// Perform PDF merge operation
  Future<void> mergePdfs() async {
    if (state.pages.isEmpty) {
      _addError('No pages to merge');
      return;
    }

    try {
      state = state.copyWith(
        isProcessing: true,
        processingProgress: 0,
        processingErrors: [],
      );

      // Progress tracking
      _updateProgress(25);

      // Perform merge operation (placeholder)
      final mergedData = state.documents.isNotEmpty ? state.documents.first.data : Uint8List(0);

      _updateProgress(75);

      state = state.copyWith(
        isProcessing: false,
        processingProgress: 100,
        mergedPdfData: mergedData,
      );

    } catch (e) {
      state = state.copyWith(
        isProcessing: false,
        processingProgress: 0,
      );
      _addError('Merge failed: $e');
    }
  }

  /// Download merged PDF
  Future<void> downloadMergedPdf() async {
    if (state.mergedPdfData == null) return;
    debugPrint('Download merged PDF');
  }

  /// Clear all
  void clearAll() {
    state = const PdfMergerState();
  }

  /// Calculate statistics
  MergeStatistics calculateStatistics() {
    return MergeStatistics(
      totalDocuments: state.documents.length,
      totalPages: state.pages.length,
      totalSize: state.documents.fold(0, (sum, d) => sum + d.fileSize),
      estimatedOutputSize: state.pages.length * 500 * 1024,
    );
  }

  // Helper methods

  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  void _recalculateGlobalIndices() {
    final updatedPages = <PdfPageThumbnail>[];
    for (int i = 0; i < state.pages.length; i++) {
      updatedPages.add(state.pages[i].copyWith(globalIndex: i));
    }
    state = state.copyWith(pages: updatedPages);
  }

  Future<int> _estimatePageCount(Uint8List data) async {
    final content = String.fromCharCodes(data, 0, math.min(data.length, 10000));
    final pageMatches = RegExp(r'/Type\s*/Page[^s]').allMatches(content);
    return math.max(1, pageMatches.length);
  }

  void _updateProgress(int progress) {
    state = state.copyWith(
      processingProgress: progress,
    );
  }

  void _addError(String message) {
    state = state.copyWith(
      processingErrors: [...state.processingErrors, message],
    );
  }
}
