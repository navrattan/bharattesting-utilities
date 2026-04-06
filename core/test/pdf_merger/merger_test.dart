import 'dart:typed_data';
import 'package:test/test.dart';
import 'package:bharattesting_core/core.dart';

void main() {
  group('PdfMerger', () {
    late List<PdfInputFile> testFiles;

    setUp(() {
      // Create test PDF files (mock data)
      testFiles = [
        PdfInputFile(
          fileName: 'document1.pdf',
          data: _createMockPdfData('Document 1 Content'),
        ),
        PdfInputFile(
          fileName: 'document2.pdf',
          data: _createMockPdfData('Document 2 Content'),
        ),
        PdfInputFile(
          fileName: 'document3.pdf',
          data: _createMockPdfData('Document 3 Content'),
        ),
      ];
    });

    group('mergePdfs', () {
      test('should merge multiple PDFs successfully', () async {
        final result = await PdfMerger.mergePdfs(testFiles);

        expect(result, isA<Uint8List>());
        expect(result.length, greaterThan(0));

        // Verify it looks like PDF content
        final resultString = String.fromCharCodes(result.take(10));
        expect(resultString, contains('%PDF'));
      });

      test('should generate bookmarks when enabled', () async {
        const options = PdfMergeOptions(
          generateBookmarks: true,
          title: 'Merged Test Document',
        );

        final result = await PdfMerger.mergePdfs(testFiles, options: options);

        expect(result, isA<Uint8List>());
        expect(result.length, greaterThan(0));
      });

      test('should preserve metadata when requested', () async {
        const options = PdfMergeOptions(
          preserveMetadata: true,
          author: 'BharatTesting',
          subject: 'Test Merge',
          keywords: ['test', 'merge', 'pdf'],
        );

        final result = await PdfMerger.mergePdfs(testFiles, options: options);

        expect(result, isA<Uint8List>());
        expect(result.length, greaterThan(0));
      });

      test('should handle single file merge', () async {
        final singleFile = [testFiles.first];

        final result = await PdfMerger.mergePdfs(singleFile);

        expect(result, isA<Uint8List>());
        expect(result.length, greaterThan(0));
      });

      test('should throw exception for empty input', () async {
        expect(
          () => PdfMerger.mergePdfs([]),
          throwsA(isA<PdfMergeException>()),
        );
      });

      test('should throw exception for too many files', () async {
        final tooManyFiles = List.generate(25, (index) => PdfInputFile(
          fileName: 'file$index.pdf',
          data: _createMockPdfData('Content $index'),
        ));

        expect(
          () => PdfMerger.mergePdfs(tooManyFiles),
          throwsA(isA<PdfMergeException>()),
        );
      });

      test('should throw exception for invalid PDF data', () async {
        final invalidFiles = [
          PdfInputFile(
            fileName: 'invalid.pdf',
            data: Uint8List.fromList([1, 2, 3, 4]), // Invalid PDF
          ),
        ];

        expect(
          () => PdfMerger.mergePdfs(invalidFiles),
          throwsA(isA<PdfMergeException>()),
        );
      });

      test('should handle different compression levels', () async {
        const optionsNone = PdfMergeOptions(
          compressionLevel: PdfCompressionLevel.none,
        );
        const optionsMax = PdfMergeOptions(
          compressionLevel: PdfCompressionLevel.maximum,
        );

        final resultNone = await PdfMerger.mergePdfs(testFiles, options: optionsNone);
        final resultMax = await PdfMerger.mergePdfs(testFiles, options: optionsMax);

        expect(resultNone, isA<Uint8List>());
        expect(resultMax, isA<Uint8List>());

        // Max compression should generally produce smaller files
        // (though not always with our mock data)
        expect(resultMax.length, lessThanOrEqualTo(resultNone.length * 1.1));
      });

      test('should detect duplicate filenames', () async {
        final duplicateFiles = [
          testFiles.first,
          testFiles.first, // Duplicate
        ];

        expect(
          () => PdfMerger.mergePdfs(duplicateFiles),
          throwsA(predicate((e) =>
              e is PdfMergeException &&
              e.message.contains('Duplicate filenames'))),
        );
      });

      test('should handle large file size limits', () async {
        // Create a very large mock file
        final largeFile = PdfInputFile(
          fileName: 'large.pdf',
          data: Uint8List(200 * 1024 * 1024), // 200MB
        );

        expect(
          () => PdfMerger.mergePdfs([largeFile]),
          throwsA(isA<PdfMergeException>()),
        );
      });
    });

    group('PdfInputFile', () {
      test('should create valid input file', () {
        final file = testFiles.first;

        expect(file.fileName, equals('document1.pdf'));
        expect(file.displayName, equals('document1'));
        expect(file.fileSize, greaterThan(0));
        expect(file.fileSizeText, contains('B'));
        expect(file.isEncrypted, isFalse);
      });

      test('should handle encrypted files', () {
        final encryptedFile = PdfInputFile(
          fileName: 'encrypted.pdf',
          data: _createMockPdfData('Encrypted Content'),
          password: 'test123',
        );

        expect(encryptedFile.isEncrypted, isTrue);
      });

      test('should calculate file size correctly', () {
        final file = PdfInputFile(
          fileName: 'test.pdf',
          data: Uint8List(1024), // 1KB
        );

        expect(file.fileSize, equals(1024));
        expect(file.fileSizeText, contains('1.0 KB'));
      });

      test('should handle equality correctly', () {
        final file1 = testFiles.first;
        final file2 = PdfInputFile(
          fileName: file1.fileName,
          data: Uint8List.fromList(file1.data),
        );
        final file3 = testFiles.last;

        expect(file1, equals(file2));
        expect(file1, isNot(equals(file3)));
      });

      test('should extract display name correctly', () {
        const testCases = [
          ('document.pdf', 'document'),
          ('my-file.pdf', 'my-file'),
          ('no-extension', 'no-extension'),
          ('multiple.dots.pdf', 'multiple.dots'),
          ('.hidden.pdf', '.hidden'),
        ];

        for (final (fileName, expected) in testCases) {
          final file = PdfInputFile(
            fileName: fileName,
            data: Uint8List(10),
          );
          expect(file.displayName, equals(expected));
        }
      });
    });

    group('PdfMergeOptions', () {
      test('should create default options', () {
        const options = PdfMergeOptions();

        expect(options.generateBookmarks, isTrue);
        expect(options.preserveMetadata, isTrue);
        expect(options.optimizeForSize, isFalse);
        expect(options.compressionLevel, equals(PdfCompressionLevel.balanced));
      });

      test('should support copyWith', () {
        const original = PdfMergeOptions(
          title: 'Original Title',
          generateBookmarks: true,
        );

        final modified = original.copyWith(
          title: 'Modified Title',
          generateBookmarks: false,
        );

        expect(modified.title, equals('Modified Title'));
        expect(modified.generateBookmarks, isFalse);
        expect(modified.preserveMetadata, equals(original.preserveMetadata));
      });
    });

    group('PdfCompressionLevel', () {
      test('should have all expected levels', () {
        expect(PdfCompressionLevel.values.length, equals(4));
        expect(PdfCompressionLevel.values, contains(PdfCompressionLevel.none));
        expect(PdfCompressionLevel.values, contains(PdfCompressionLevel.fast));
        expect(PdfCompressionLevel.values, contains(PdfCompressionLevel.balanced));
        expect(PdfCompressionLevel.values, contains(PdfCompressionLevel.maximum));
      });
    });

    group('Error Handling', () {
      test('PdfMergeException should provide useful error information', () {
        const exception = PdfMergeException('Test error', 'Additional details');

        expect(exception.message, equals('Test error'));
        expect(exception.details, equals('Additional details'));
        expect(exception.toString(), contains('Test error'));
        expect(exception.toString(), contains('Additional details'));
      });

      test('PdfMergeException should work without details', () {
        const exception = PdfMergeException('Simple error');

        expect(exception.message, equals('Simple error'));
        expect(exception.details, isNull);
        expect(exception.toString(), contains('Simple error'));
        expect(exception.toString(), isNot(contains('Details:')));
      });
    });

    group('Performance Tests', () {
      test('should handle moderate number of files efficiently', () async {
        final manyFiles = List.generate(10, (index) => PdfInputFile(
          fileName: 'doc$index.pdf',
          data: _createMockPdfData('Content $index'),
        ));

        final stopwatch = Stopwatch()..start();
        final result = await PdfMerger.mergePdfs(manyFiles);
        stopwatch.stop();

        expect(result, isA<Uint8List>());
        expect(stopwatch.elapsedMilliseconds, lessThan(5000)); // Under 5 seconds
      });

      test('should handle large individual files efficiently', () async {
        final largeFile = PdfInputFile(
          fileName: 'large.pdf',
          data: _createLargeMockPdfData(5 * 1024 * 1024), // 5MB
        );

        final stopwatch = Stopwatch()..start();
        final result = await PdfMerger.mergePdfs([largeFile]);
        stopwatch.stop();

        expect(result, isA<Uint8List>());
        expect(stopwatch.elapsedMilliseconds, lessThan(3000)); // Under 3 seconds
      });
    });
  });
}

/// Create mock PDF data for testing
Uint8List _createMockPdfData(String content) {
  final header = '%PDF-1.4\n';
  final body = '''
1 0 obj
<<
/Type /Catalog
/Pages 2 0 R
>>
endobj

2 0 obj
<<
/Type /Pages
/Kids [3 0 R]
/Count 1
>>
endobj

3 0 obj
<<
/Type /Page
/Parent 2 0 R
/MediaBox [0 0 612 792]
/Contents 4 0 R
>>
endobj

4 0 obj
<<
/Length ${content.length + 20}
>>
stream
BT
/F1 12 Tf
72 720 Td
($content) Tj
ET
endstream
endobj

xref
0 5
0000000000 65535 f
0000000010 00000 n
0000000079 00000 n
0000000173 00000 n
0000000301 00000 n
trailer
<<
/Size 5
/Root 1 0 R
>>
startxref
${400 + content.length}
%%EOF
''';

  return Uint8List.fromList((header + body).codeUnits);
}

/// Create large mock PDF data for performance testing
Uint8List _createLargeMockPdfData(int targetSize) {
  final baseContent = 'This is repeated content. ';
  final repetitions = (targetSize / baseContent.length).ceil();
  final largeContent = baseContent * repetitions;

  return _createMockPdfData(largeContent);
}