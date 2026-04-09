import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:bharattesting_core/core.dart' as core;
import '../models/pdf_merger_state.dart';
import '../utils/pdf_thumbnail_generator.dart';

part 'pdf_merger_provider.g.dart';

@riverpod
class PdfMerger extends _$PdfMerger {
  @override
  PdfMergerState build() {
    return const PdfMergerState();
  }

  /// Add documents to the list
  Future<void> addDocuments(List<PlatformFile> files) async {
    final newDocs = <PdfDocument>[];
    
    for (final file in files) {
      if (file.bytes == null) continue;
      
      final doc = PdfDocument(
        id: DateTime.now().millisecondsSinceEpoch.toString() + file.name,
        fileName: file.name,
        fileSize: file.size,
        data: file.bytes!,
        pageCount: 0,
      );
      newDocs.add(doc);
    }

    state = state.copyWith(
      documents: [...state.documents, ...newDocs],
    );

    for (final doc in newDocs) {
      _generateThumbnailsForDoc(doc);
    }
  }

  /// Alias for addDocuments used by drag and drop
  Future<void> addDocumentsFromDrop(List<PlatformFile> files) => addDocuments(files);

  Future<void> _generateThumbnailsForDoc(PdfDocument doc) async {
    try {
      final thumbnails = await PdfThumbnailGenerator.generate(doc.data);
      
      final updatedDoc = doc.copyWith(pageCount: thumbnails.length);
      final updatedDocs = state.documents.map((d) => d.id == doc.id ? updatedDoc : d).toList();
      
      final newPages = <PdfPageThumbnail>[];
      for (int i = 0; i < thumbnails.length; i++) {
        newPages.add(PdfPageThumbnail(
          id: '${doc.id}_$i',
          documentId: doc.id,
          pageNumber: i + 1,
          globalIndex: state.pages.length + i,
          dimensions: const PageDimensions(width: 595, height: 842),
          thumbnailData: thumbnails[i],
          status: ThumbnailStatus.ready,
        ));
      }

      state = state.copyWith(
        documents: updatedDocs,
        pages: [...state.pages, ...newPages],
      );
    } catch (e) {
      _addError('Failed to process ${doc.fileName}: $e');
    }
  }

  /// Select a document
  void selectDocument(PdfDocument? doc) {
    state = state.copyWith(selectedDocument: doc);
  }

  /// Select a page
  void selectPage(PdfPageThumbnail? page) {
    state = state.copyWith(selectedPage: page);
  }

  /// Remove a page
  void removePage(String pageId) {
    state = state.copyWith(
      pages: state.pages.where((p) => p.id != pageId).toList(),
    );
  }

  /// Remove a document
  void removeDocument(String docId) {
    state = state.copyWith(
      documents: state.documents.where((d) => d.id != docId).toList(),
      pages: state.pages.where((p) => p.documentId != docId).toList(),
    );
  }

  /// Duplicate a page
  void duplicatePage(String pageId) {
    final index = state.pages.indexWhere((p) => p.id == pageId);
    if (index == -1) return;

    final original = state.pages[index];
    final copy = original.copyWith(
      id: '${original.id}_copy_${DateTime.now().millisecondsSinceEpoch}',
    );

    final updatedPages = List<PdfPageThumbnail>.from(state.pages);
    updatedPages.insert(index + 1, copy);
    state = state.copyWith(pages: updatedPages);
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
  }

  /// Rotate a page
  Future<void> rotatePage(String pageId, core.PageRotation rotation) async {
    final pages = state.pages.map((p) {
      if (p.id == pageId) {
        // Map core.PageRotation to app's PageRotation
        final appRotation = PageRotation.fromDegrees(rotation.degrees);
        return p.copyWith(rotation: appRotation);
      }
      return p;
    }).toList();
    state = state.copyWith(pages: pages);
  }

  /// Toggle encryption
  void toggleEncryption() {
    state = state.copyWith(enableEncryption: !state.enableEncryption);
  }

  /// Update encryption password
  void updateEncryptionPassword(String password) {
    state = state.copyWith(encryptionPassword: password);
  }

  /// Update permissions
  void updatePermissions(PdfPermissions permissions) {
    state = state.copyWith(permissions: permissions);
  }

  /// Update merge options
  void updateMergeOptions(PdfMergeOptions options) {
    state = state.copyWith(mergeOptions: options);
  }

  /// Calculate statistics
  MergeStatistics calculateStatistics() {
    return MergeStatistics(
      totalPages: state.pages.length,
      totalSize: state.documents.fold(0, (sum, doc) => sum + doc.fileSize),
      estimatedOutputSize: state.documents.fold(0, (sum, doc) => sum + doc.fileSize),
      totalDocuments: state.documents.length,
    );
  }

  /// Clear all
  void clearAll() {
    state = const PdfMergerState();
  }

  /// Download merged PDF
  Future<void> downloadMergedPdf() async {
    // Download logic
  }

  /// Merge PDFs
  Future<void> mergePdfs() async {
    if (state.pages.isEmpty) return;

    state = state.copyWith(isProcessing: true, processingProgress: 0);

    try {
      final inputFiles = state.documents.map((doc) => core.PdfInputFile(
        data: doc.data,
        fileName: doc.fileName,
      )).toList();

      final mergedData = await core.PdfMerger.mergePdfs(
        inputFiles,
        options: core.PdfMergeOptions(
          generateBookmarks: state.mergeOptions.generateBookmarks,
          preserveMetadata: state.mergeOptions.preserveMetadata,
          optimizeForSize: state.mergeOptions.optimizeForSize,
        ),
      );

      state = state.copyWith(
        isProcessing: false,
        processingProgress: 100,
        mergedPdfData: mergedData,
      );
    } catch (e) {
      state = state.copyWith(
        isProcessing: false,
        processingErrors: [...state.processingErrors, e.toString()],
      );
    }
  }

  void _addError(String message) {
    state = state.copyWith(
      processingErrors: [...state.processingErrors, message],
    );
  }
}
