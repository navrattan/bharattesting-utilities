import 'package:alchemist/alchemist.dart';
import 'package:bharattesting_utilities/features/pdf_merger/pdf_merger_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'golden_test_config.dart';

/// Golden tests for the PDF Merger
///
/// Tests the PDF upload interface, page thumbnails,
/// drag-and-drop reordering, and merge operations.
void main() {
  group('PDF Merger Golden Tests', () {
    goldenTest(
      'pdf merger initial state',
      fileName: 'pdf_merger_initial',
      constraints: GoldenTestConfig.constraints,
      builder: () => GoldenTestGroup(
        children: [
          for (final themeName in GoldenTestConfig.themes.keys)
            for (final device in GoldenTestConfig.devices)
              GoldenTestConfig.createScenario(
                name: 'initial_${themeName}_${device.name}',
                theme: themeName,
                device: device,
                child: const PdfMergerScreen(),
              ),
        ],
      ),
    );

    goldenTest(
      'pdf merger with files loaded',
      fileName: 'pdf_merger_loaded',
      constraints: GoldenTestConfig.constraints,
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestConfig.createScenario(
            name: 'loaded_dark_desktop',
            theme: 'dark',
            device: GoldenTestConfig.desktopDevice,
            child: GoldenTestConfig.withPdfFiles(
              const PdfMergerScreen(),
              files: [
                GoldenTestData.mockPdfFile('document1.pdf', 5, '2.1 MB'),
                GoldenTestData.mockPdfFile('report.pdf', 12, '4.8 MB'),
                GoldenTestData.mockPdfFile('invoice.pdf', 2, '156 KB'),
              ],
            ),
          ),
          GoldenTestConfig.createScenario(
            name: 'loaded_light_tablet',
            theme: 'light',
            device: GoldenTestConfig.tabletDevice,
            child: GoldenTestConfig.withPdfFiles(
              const PdfMergerScreen(),
              files: [
                GoldenTestData.mockPdfFile('contract.pdf', 8, '1.2 MB'),
                GoldenTestData.mockPdfFile('appendix.pdf', 3, '890 KB'),
              ],
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'pdf merger page thumbnails',
      fileName: 'pdf_merger_thumbnails',
      constraints: GoldenTestConfig.constraints,
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestConfig.createScenario(
            name: 'thumbnails_grid_dark_desktop',
            theme: 'dark',
            device: GoldenTestConfig.desktopDevice,
            child: GoldenTestConfig.withPdfThumbnails(
              const PdfMergerScreen(),
              totalPages: 15,
              selectedPages: [1, 3, 7],
            ),
          ),
          GoldenTestConfig.createScenario(
            name: 'thumbnails_list_light_mobile',
            theme: 'light',
            device: GoldenTestConfig.mobileDevice,
            child: GoldenTestConfig.withPdfThumbnails(
              const PdfMergerScreen(),
              totalPages: 8,
              layoutMode: 'list',
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'pdf merger drag and drop',
      fileName: 'pdf_merger_drag_drop',
      constraints: GoldenTestConfig.constraints,
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestConfig.createScenario(
            name: 'drag_indicator_dark_tablet',
            theme: 'dark',
            device: GoldenTestConfig.tabletDevice,
            child: GoldenTestConfig.withDragIndicator(
              const PdfMergerScreen(),
              draggedPage: 3,
              targetPosition: 1,
            ),
          ),
          GoldenTestConfig.createScenario(
            name: 'drop_zone_light_desktop',
            theme: 'light',
            device: GoldenTestConfig.desktopDevice,
            child: GoldenTestConfig.withDropZone(
              const PdfMergerScreen(),
              showDropZone: true,
              acceptedFileCount: 2,
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'pdf merger page operations',
      fileName: 'pdf_merger_operations',
      constraints: GoldenTestConfig.constraints,
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestConfig.createScenario(
            name: 'rotate_page_dark_mobile',
            theme: 'dark',
            device: GoldenTestConfig.mobileDevice,
            child: GoldenTestConfig.withPageRotation(
              const PdfMergerScreen(),
              pageIndex: 2,
              rotation: 90,
            ),
          ),
          GoldenTestConfig.createScenario(
            name: 'delete_page_light_tablet',
            theme: 'light',
            device: GoldenTestConfig.tabletDevice,
            child: GoldenTestConfig.withPageDeletion(
              const PdfMergerScreen(),
              pageIndex: 4,
              showConfirmation: true,
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'pdf merger security options',
      fileName: 'pdf_merger_security',
      constraints: GoldenTestConfig.constraints,
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestConfig.createScenario(
            name: 'password_dialog_dark_desktop',
            theme: 'dark',
            device: GoldenTestConfig.desktopDevice,
            child: GoldenTestConfig.withPasswordDialog(
              const PdfMergerScreen(),
            ),
          ),
          GoldenTestConfig.createScenario(
            name: 'security_options_light_tablet',
            theme: 'light',
            device: GoldenTestConfig.tabletDevice,
            child: GoldenTestConfig.withSecurityOptions(
              const PdfMergerScreen(),
              allowPrint: false,
              allowCopy: true,
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'pdf merger merge progress',
      fileName: 'pdf_merger_progress',
      constraints: GoldenTestConfig.constraints,
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestConfig.createScenario(
            name: 'merge_progress_dark_mobile',
            theme: 'dark',
            device: GoldenTestConfig.mobileDevice,
            child: GoldenTestConfig.withMergeProgress(
              const PdfMergerScreen(),
              progress: 0.65,
              currentOperation: 'Merging page 8 of 12...',
            ),
          ),
          GoldenTestConfig.createScenario(
            name: 'merge_complete_light_desktop',
            theme: 'light',
            device: GoldenTestConfig.desktopDevice,
            child: GoldenTestConfig.withMergeComplete(
              const PdfMergerScreen(),
              outputFileName: 'merged_document.pdf',
              outputSize: '6.8 MB',
              pageCount: 20,
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'pdf merger error states',
      fileName: 'pdf_merger_errors',
      constraints: GoldenTestConfig.constraints,
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestConfig.createScenario(
            name: 'corrupted_pdf_error_dark_tablet',
            theme: 'dark',
            device: GoldenTestConfig.tabletDevice,
            child: GoldenTestConfig.withError(
              const PdfMergerScreen(),
              'corrupted_file.pdf is corrupted and cannot be processed.',
            ),
          ),
          GoldenTestConfig.createScenario(
            name: 'size_limit_error_light_mobile',
            theme: 'light',
            device: GoldenTestConfig.mobileDevice,
            child: GoldenTestConfig.withError(
              const PdfMergerScreen(),
              'Total size exceeds 100MB limit. Please reduce files.',
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'pdf merger bookmarks',
      fileName: 'pdf_merger_bookmarks',
      constraints: GoldenTestConfig.constraints,
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestConfig.createScenario(
            name: 'bookmark_options_dark_desktop',
            theme: 'dark',
            device: GoldenTestConfig.desktopDevice,
            child: GoldenTestConfig.withBookmarkOptions(
              const PdfMergerScreen(),
              autoGenerateBookmarks: true,
              bookmarkStyle: 'filename',
            ),
          ),
        ],
      ),
    );
  });
}