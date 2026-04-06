import 'dart:typed_data';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:bharattesting_core/core.dart';
import '../models/pdf_merger_state.dart';
import '../utils/pdf_thumbnail_generator.dart';
import '../utils/pdf_merger_utils.dart';

part 'pdf_merger_provider.g.dart';

@riverpod
class PdfMerger extends _$PdfMerger {
  @override
  PdfMergerState build() {
    return const PdfMergerState();
  }

  /// Add PDF documents from file picker
  Future<void> addDocumentsFromPicker() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final validFiles = result.files.where((file) =>
          file.bytes != null && file.bytes!.isNotEmpty
        ).take(20).toList(); // Max 20 files

        if (validFiles.isNotEmpty) {
          await _addDocuments(validFiles);
        }
      }
    } catch (e) {
      _addError('Failed to select files: $e');
    }
  }

  /// Add documents from dropped files
  Future<void> addDocumentsFromDrop(List<PlatformFile> files) async {
    try {
      final pdfFiles = files.where((file) =>
        file.extension?.toLowerCase() == 'pdf' &&
        file.bytes != null &&
        file.bytes!.isNotEmpty
      ).take(20).toList();

      if (pdfFiles.isNotEmpty) {
        await _addDocuments(pdfFiles);
      } else {
        _addError('No valid PDF files found');
      }
    } catch (e) {
      _addError('Failed to process dropped files: $e');
    }
  }

  /// Process and add documents to state
  Future<void> _addDocuments(List<PlatformFile> files) async {
    final newDocuments = <PdfDocument>[];

    for (final file in files) {
      try {
        final document = await _createPdfDocument(file);
        newDocuments.add(document);
      } catch (e) {
        _addError('Failed to process ${file.name}: $e');
      }
    }

    if (newDocuments.isNotEmpty) {
      final updatedDocuments = [...state.documents, ...newDocuments];
      final allPages = await _generatePageThumbnails(updatedDocuments);

      state = state.copyWith(
        documents: updatedDocuments,
        pages: allPages,
      );
    }
  }

  /// Create PDF document from file
  Future<PdfDocument> _createPdfDocument(PlatformFile file) async {
    final data = file.bytes!;

    // Validate PDF format
    if (!_isValidPdf(data)) {
      throw Exception('Invalid PDF format');
    }

    // Check if encrypted
    final isEncrypted = PdfEncryptor.isPdfEncrypted(data);

    // Estimate page count (simplified)
    final pageCount = await _estimatePageCount(data);

    return PdfDocument(
      id: _generateId(),
      fileName: file.name,
      data: data,
      fileSize: data.length,
      pageCount: pageCount,
      isEncrypted: isEncrypted,
      lastModified: DateTime.now(),
      status: DocumentStatus.loaded,
    );
  }

  /// Generate thumbnails for all pages
  Future<List<PdfPageThumbnail>> _generatePageThumbnails(
    List<PdfDocument> documents,
  ) async {
    final thumbnails = <PdfPageThumbnail>[];
    int globalIndex = 0;

    for (final document in documents) {
      if (!document.isReady) continue;

      for (int pageIndex = 0; pageIndex < document.pageCount; pageIndex++) {
        final thumbnail = await _createPageThumbnail(
          document,
          pageIndex,
          globalIndex,
        );
        thumbnails.add(thumbnail);
        globalIndex++;
      }
    }

    return thumbnails;
  }

  /// Create individual page thumbnail
  Future<PdfPageThumbnail> _createPageThumbnail(
    PdfDocument document,
    int pageIndex,
    int globalIndex,
  ) async {
    final thumbnailData = await PdfThumbnailGenerator.generateThumbnail(
      document.data,
      pageIndex,
    );

    final dimensions = PdfThumbnailGenerator.getPageDimensions(
      document.data,
      pageIndex,
    ) ?? PageDimensions.a4();

    return PdfPageThumbnail(
      id: _generateId(),
      documentId: document.id,
      pageNumber: pageIndex,
      globalIndex: globalIndex,
      dimensions: dimensions,
      thumbnailData: thumbnailData,
      status: ThumbnailStatus.ready,
    );
  }

  /// Remove document and its pages
  void removeDocument(String documentId) {
    final updatedDocuments = state.documents
        .where((doc) => doc.id != documentId)
        .toList();

    final updatedPages = state.pages
        .where((page) => page.documentId != documentId)
        .toList();

    // Renumber global indices
    final renumberedPages = _renumberPages(updatedPages);

    state = state.copyWith(
      documents: updatedDocuments,
      pages: renumberedPages,
      selectedDocument: state.selectedDocument?.id == documentId ? null : state.selectedDocument,
    );
  }

  /// Remove specific page
  void removePage(String pageId) {
    final updatedPages = state.pages
        .where((page) => page.id != pageId)
        .toList();

    final renumberedPages = _renumberPages(updatedPages);

    state = state.copyWith(
      pages: renumberedPages,
      selectedPage: state.selectedPage?.id == pageId ? null : state.selectedPage,
    );
  }

  /// Reorder pages (drag and drop)
  void reorderPages(int fromIndex, int toIndex) {
    if (fromIndex == toIndex ||
        fromIndex < 0 || fromIndex >= state.pages.length ||
        toIndex < 0 || toIndex >= state.pages.length) {
      return;
    }

    final pages = List<PdfPageThumbnail>.from(state.pages);
    final movedPage = pages.removeAt(fromIndex);
    pages.insert(toIndex, movedPage);

    final renumberedPages = _renumberPages(pages);

    state = state.copyWith(pages: renumberedPages);
  }

  /// Rotate page
  Future<void> rotatePage(String pageId, PageRotation rotation) async {
    final pageIndex = state.pages.indexWhere((page) => page.id == pageId);
    if (pageIndex == -1) return;

    final page = state.pages[pageIndex];
    final newRotation = _combineRotations(page.rotation, rotation);

    final updatedPage = page.copyWith(rotation: newRotation);
    final updatedPages = List<PdfPageThumbnail>.from(state.pages);
    updatedPages[pageIndex] = updatedPage;

    state = state.copyWith(pages: updatedPages);
  }

  /// Duplicate page
  void duplicatePage(String pageId) {
    final pageIndex = state.pages.indexWhere((page) => page.id == pageId);
    if (pageIndex == -1) return;

    final originalPage = state.pages[pageIndex];
    final duplicatedPage = originalPage.copyWith(
      id: _generateId(),
      isDuplicate: true,
    );

    final updatedPages = List<PdfPageThumbnail>.from(state.pages);
    updatedPages.insert(pageIndex + 1, duplicatedPage);

    final renumberedPages = _renumberPages(updatedPages);
    state = state.copyWith(pages: renumberedPages);
  }

  /// Select page
  void selectPage(String? pageId) {
    final selectedPage = pageId != null
        ? state.pages.firstWhere((page) => page.id == pageId)
        : null;

    state = state.copyWith(selectedPage: selectedPage);
  }

  /// Select document
  void selectDocument(String? documentId) {
    final selectedDocument = documentId != null
        ? state.documents.firstWhere((doc) => doc.id == documentId)
        : null;

    state = state.copyWith(selectedDocument: selectedDocument);
  }

  /// Toggle encryption
  void toggleEncryption() {
    state = state.copyWith(enableEncryption: !state.enableEncryption);
  }

  /// Update encryption password
  void updateEncryptionPassword(String password) {
    state = state.copyWith(encryptionPassword: password);
  }

  /// Update merge options
  void updateMergeOptions(PdfMergeOptions options) {
    state = state.copyWith(mergeOptions: options);
  }

  /// Update permissions
  void updatePermissions(PdfPermissions permissions) {
    state = state.copyWith(permissions: permissions);
  }

  /// Toggle advanced settings
  void toggleAdvancedSettings() {
    state = state.copyWith(showAdvancedSettings: !state.showAdvancedSettings);
  }

  /// Show/hide password dialog
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

      // Group pages by document to create input files
      final inputFiles = await _createInputFiles();

      // Configure merge options
      final options = _configureMergeOptions();

      // Progress tracking
      _updateProgress(25, 'Preparing documents...');

      // Perform merge operation
      final mergedData = await PdfMerger.mergePdfs(inputFiles, options: options);

      _updateProgress(75, 'Applying encryption...');

      // Apply encryption if enabled
      final finalData = state.enableEncryption
          ? await _applyEncryption(mergedData)
          : mergedData;

      _updateProgress(100, 'Merge completed successfully');

      // Generate output filename
      final outputFileName = PdfMergerUtils.generateOutputFileName(
        state.documents.map((doc) => doc.displayName).toList(),
      );

      state = state.copyWith(
        isProcessing: false,
        processingProgress: 100,
        mergedPdfData: finalData,
        outputFileName: outputFileName,
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

    try {
      await PdfMergerUtils.downloadPdf(
        data: state.mergedPdfData!,
        fileName: state.outputFileName,
      );
    } catch (e) {
      _addError('Download failed: $e');
    }
  }

  /// Clear all documents and start over
  void clearAll() {
    state = const PdfMergerState();
  }

  /// Private helper methods

  bool _isValidPdf(Uint8List data) {
    if (data.length < 8) return false;
    final header = String.fromCharCodes(data.take(8));
    return header.startsWith('%PDF-');
  }

  Future<int> _estimatePageCount(Uint8List data) async {
    // Simplified page count estimation
    // In real implementation, would parse PDF structure
    final content = String.fromCharCodes(data, 0, math.min(data.length, 10000));
    final pageMatches = RegExp(r'/Type\s*/Page[^s]').allMatches(content);
    return math.max(1, pageMatches.length);
  }

  PageRotation _combineRotations(PageRotation current, PageRotation additional) {
    final totalDegrees = (current.degrees + additional.degrees) % 360;
    return PageRotation.fromDegrees(totalDegrees);
  }

  List<PdfPageThumbnail> _renumberPages(List<PdfPageThumbnail> pages) {
    return pages.asMap().entries.map((entry) {
      return entry.value.copyWith(globalIndex: entry.key);
    }).toList();
  }

  Future<List<PdfInputFile>> _createInputFiles() async {
    final files = <PdfInputFile>[];

    for (final document in state.documents) {
      if (!document.isReady) continue;

      final documentPages = state.pages.where(
        (page) => page.documentId == document.id,
      ).toList();

      if (documentPages.isNotEmpty) {
        files.add(PdfInputFile(
          fileName: document.fileName,
          data: document.data,
          password: document.password,
        ));
      }
    }

    return files;
  }

  PdfMergeOptions _configureMergeOptions() {
    return state.mergeOptions.copyWith(
      title: 'Merged Document - ${DateTime.now().toIso8601String()}',
      author: 'BharatTesting PDF Merger',
    );
  }

  Future<Uint8List> _applyEncryption(Uint8List data) async {
    if (state.encryptionPassword.isEmpty) {
      throw Exception('Encryption password is required');
    }

    final options = PdfEncryptionOptions(
      userPassword: state.encryptionPassword,
      permissions: state.permissions,
    );

    return await PdfEncryptor.encryptPdf(data, options);
  }

  void _updateProgress(int progress, String message) {
    state = state.copyWith(
      processingProgress: progress,
    );
  }

  void _addError(String error) {
    state = state.copyWith(
      processingErrors: [...state.processingErrors, error],
    );
  }

  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString() +
           math.Random().nextInt(1000).toString();
  }

  /// Calculate merge statistics
  MergeStatistics calculateStatistics() {
    final totalSize = state.documents.fold<int>(
      0,
      (sum, doc) => sum + doc.fileSize,
    );

    final orientationCounts = <PageOrientation, int>{};
    for (final page in state.pages) {
      final orientation = page.orientation;
      orientationCounts[orientation] = (orientationCounts[orientation] ?? 0) + 1;
    }

    final estimatedOutputSize = (totalSize * 0.85).round(); // Rough estimate
    final estimatedTime = Duration(seconds: (state.pages.length * 0.5).round());

    return MergeStatistics(
      totalDocuments: state.documents.length,
      totalPages: state.pages.length,
      totalSize: totalSize,
      estimatedOutputSize: estimatedOutputSize,
      estimatedTime: estimatedTime,
      orientationCounts: orientationCounts,
    );
  }
}