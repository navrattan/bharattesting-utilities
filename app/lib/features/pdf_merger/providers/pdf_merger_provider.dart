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
    try {
      // Validate input
      if (files.isEmpty) {
        throw Exception('No files selected');
      }

      final newDocs = <PdfDocument>[];

      for (final file in files) {
        if (file.bytes == null) {
          throw Exception('Invalid file: ${file.name} has no data');
        }

        // Check file size (limit to 50MB per file)
        if (file.size > 50 * 1024 * 1024) {
          throw Exception('File ${file.name} is too large (max 50MB)');
        }

        // Check total document limit
        if (state.documents.length >= 20) {
          throw Exception('Maximum 20 documents allowed');
        }

        final doc = PdfDocument(
          id: DateTime.now().millisecondsSinceEpoch.toString() + file.name,
          fileName: file.name,
          fileSize: file.size,
          data: file.bytes!,
          pageCount: 0,
        );
        newDocs.add(doc);
      }

      state = state.copyWith(documents: [...state.documents, ...newDocs]);
      await _generateAllThumbnails();
    } catch (error) {
      state = state.copyWith(processingErrors: [...state.processingErrors, error.toString()]);
    }
  }

  void removeDocument(String id) {
    state = state.copyWith(
      documents: state.documents.where((doc) => doc.id != id).toList(),
      pages: state.pages.where((page) => page.documentId != id).toList(),
    );
  }

  void reorderDocuments(int oldIndex, int newIndex) {
    final docs = List<PdfDocument>.from(state.documents);
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = docs.removeAt(oldIndex);
    docs.insert(newIndex, item);
    state = state.copyWith(documents: docs);
    _rebuildPagesFromDocs();
  }

  void selectDocument(PdfDocument? doc) {
    state = state.copyWith(selectedDocument: doc);
  }

  void selectPage(String id) {
    final page = state.pages.firstWhere((p) => p.id == id);
    state = state.copyWith(selectedPage: page);
  }

  void removePage(String id) {
    state = state.copyWith(
      pages: state.pages.where((p) => p.id != id).toList(),
    );
  }

  void rotatePage(String id, core.PageRotation rotation) {
    state = state.copyWith(
      pages: state.pages.map((p) => p.id == id ? p.copyWith(rotation: rotation) : p).toList(),
    );
  }

  void duplicatePage(String id) {
    final index = state.pages.indexWhere((p) => p.id == id);
    if (index == -1) return;
    
    final page = state.pages[index];
    final newPage = page.copyWith(id: '${page.id}_copy_${DateTime.now().millisecondsSinceEpoch}');
    
    final newPages = List<PdfPageThumbnail>.from(state.pages);
    newPages.insert(index + 1, newPage);
    state = state.copyWith(pages: newPages);
  }

  void reorderPages(int oldIndex, int newIndex) {
    final pages = List<PdfPageThumbnail>.from(state.pages);
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = pages.removeAt(oldIndex);
    pages.insert(newIndex, item);
    state = state.copyWith(pages: pages);
  }

  void updateMergeOptions(core.PdfMergeOptions options) {
    state = state.copyWith(mergeOptions: options);
  }

  void toggleEncryption(bool enabled) {
    state = state.copyWith(enableEncryption: enabled);
  }

  void updateEncryptionPassword(String password) {
    state = state.copyWith(encryptionPassword: password);
  }

  void updatePermissions(core.PdfPermissions perms) {
    state = state.copyWith(permissions: perms);
  }

  Future<void> _generateAllThumbnails() async {
    // Implementation for thumbnail generation
  }

  void _rebuildPagesFromDocs() {
    // Logic to rebuild pages list when documents are reordered
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
        options: state.mergeOptions,
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

  void downloadMergedPdf() {
    // Web download logic
  }

  /// Get merge statistics
  MergeStatistics get statistics {
    return MergeStatistics(
      totalDocuments: state.documents.length,
      totalPages: state.pages.length,
      totalSize: state.documents.fold(0, (sum, doc) => sum + doc.fileSize),
      estimatedOutputSize: state.documents.fold(0, (sum, doc) => sum + doc.fileSize),
    );
  }
}
