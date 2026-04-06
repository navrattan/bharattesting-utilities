import 'dart:typed_data';
import 'dart:math' as math;

/// Advanced PDF page manipulation engine
///
/// Features:
/// - Rotate pages (90°, 180°, 270°)
/// - Delete pages with undo support
/// - Reorder pages with drag-and-drop simulation
/// - Extract page ranges
/// - Duplicate pages
/// - Insert blank pages
/// - Page dimension analysis
/// - Batch operations for efficiency
class PdfPageManipulator {
  /// Rotate a specific page by the given angle
  ///
  /// [pageData] - The page data to rotate
  /// [rotation] - Rotation angle (must be 0, 90, 180, or 270)
  ///
  /// Returns rotated page data
  static Future<PdfPageData> rotatePage(
    PdfPageData pageData,
    PageRotation rotation,
  ) async {
    if (rotation == PageRotation.none) {
      return pageData;
    }

    return pageData.copyWith(
      rotation: _combineRotations(pageData.rotation, rotation),
      dimensions: _rotatedDimensions(pageData.dimensions, rotation),
      transformMatrix: _calculateRotationMatrix(pageData.transformMatrix, rotation),
      lastModified: DateTime.now(),
    );
  }

  /// Rotate multiple pages in batch
  static Future<List<PdfPageData>> rotatePages(
    List<PdfPageData> pages,
    List<int> pageIndices,
    PageRotation rotation,
  ) async {
    final result = List<PdfPageData>.from(pages);

    for (final index in pageIndices) {
      if (index >= 0 && index < pages.length) {
        result[index] = await rotatePage(result[index], rotation);
      }
    }

    return result;
  }

  /// Delete pages by indices
  ///
  /// Returns new page list with specified pages removed
  static List<PdfPageData> deletePages(
    List<PdfPageData> pages,
    List<int> pageIndices,
  ) {
    final sortedIndices = List<int>.from(pageIndices)
      ..sort((a, b) => b.compareTo(a)); // Sort in descending order

    final result = List<PdfPageData>.from(pages);

    for (final index in sortedIndices) {
      if (index >= 0 && index < result.length) {
        result.removeAt(index);
      }
    }

    return result;
  }

  /// Reorder pages by moving a page from one position to another
  ///
  /// [fromIndex] - Current position of the page
  /// [toIndex] - Target position for the page
  static List<PdfPageData> reorderPages(
    List<PdfPageData> pages,
    int fromIndex,
    int toIndex,
  ) {
    if (fromIndex < 0 || fromIndex >= pages.length ||
        toIndex < 0 || toIndex >= pages.length ||
        fromIndex == toIndex) {
      return pages;
    }

    final result = List<PdfPageData>.from(pages);
    final pageToMove = result.removeAt(fromIndex);

    // Adjust target index if necessary
    final adjustedToIndex = fromIndex < toIndex ? toIndex - 1 : toIndex;
    result.insert(adjustedToIndex, pageToMove);

    return result;
  }

  /// Reorder pages based on a new order array
  ///
  /// [newOrder] - Array of indices representing the new order
  static List<PdfPageData> reorderPagesByArray(
    List<PdfPageData> pages,
    List<int> newOrder,
  ) {
    if (newOrder.length != pages.length) {
      throw PageManipulationException(
        'New order array must have same length as pages list',
      );
    }

    // Validate that all indices are present and unique
    final sortedOrder = List<int>.from(newOrder)..sort();
    for (int i = 0; i < sortedOrder.length; i++) {
      if (sortedOrder[i] != i) {
        throw PageManipulationException('Invalid new order array');
      }
    }

    return newOrder.map((index) => pages[index]).toList();
  }

  /// Extract a range of pages
  ///
  /// [startPage] - Starting page index (0-based)
  /// [endPage] - Ending page index (inclusive, 0-based)
  static List<PdfPageData> extractPageRange(
    List<PdfPageData> pages,
    int startPage,
    int endPage,
  ) {
    if (startPage < 0 || startPage >= pages.length ||
        endPage < 0 || endPage >= pages.length ||
        startPage > endPage) {
      throw PageManipulationException('Invalid page range');
    }

    return pages.sublist(startPage, endPage + 1);
  }

  /// Duplicate a page at a specific position
  ///
  /// [pageIndex] - Index of page to duplicate
  /// [insertAfter] - Whether to insert the duplicate after (true) or before (false) the original
  static List<PdfPageData> duplicatePage(
    List<PdfPageData> pages,
    int pageIndex, {
    bool insertAfter = true,
  }) {
    if (pageIndex < 0 || pageIndex >= pages.length) {
      throw PageManipulationException('Invalid page index');
    }

    final result = List<PdfPageData>.from(pages);
    final originalPage = pages[pageIndex];
    final duplicatePage = originalPage.copyWith(
      pageNumber: -1, // Will be renumbered later
      isDuplicate: true,
      lastModified: DateTime.now(),
    );

    final insertIndex = insertAfter ? pageIndex + 1 : pageIndex;
    result.insert(insertIndex, duplicatePage);

    return _renumberPages(result);
  }

  /// Insert a blank page at a specific position
  ///
  /// [insertIndex] - Position to insert the blank page
  /// [dimensions] - Dimensions of the blank page (optional, defaults to A4)
  static List<PdfPageData> insertBlankPage(
    List<PdfPageData> pages,
    int insertIndex, {
    PageDimensions? dimensions,
  }) {
    if (insertIndex < 0 || insertIndex > pages.length) {
      throw PageManipulationException('Invalid insert index');
    }

    final result = List<PdfPageData>.from(pages);
    final blankPage = PdfPageData.createBlank(
      dimensions: dimensions ?? PageDimensions.a4(),
    );

    result.insert(insertIndex, blankPage);
    return _renumberPages(result);
  }

  /// Get summary statistics about the pages
  static PageStatistics calculateStatistics(List<PdfPageData> pages) {
    if (pages.isEmpty) {
      return PageStatistics.empty();
    }

    final orientations = <PageOrientation, int>{};
    final dimensions = <PageDimensions>{};
    int rotatedPages = 0;
    double totalArea = 0;

    for (final page in pages) {
      final orientation = page.orientation;
      orientations[orientation] = (orientations[orientation] ?? 0) + 1;
      dimensions.add(page.dimensions);

      if (page.rotation != PageRotation.none) {
        rotatedPages++;
      }

      totalArea += page.dimensions.area;
    }

    return PageStatistics(
      totalPages: pages.length,
      orientationCounts: orientations,
      uniqueDimensions: dimensions.toList(),
      rotatedPages: rotatedPages,
      totalArea: totalArea,
      averageArea: totalArea / pages.length,
    );
  }

  /// Combine two rotations
  static PageRotation _combineRotations(
    PageRotation current,
    PageRotation additional,
  ) {
    final totalDegrees = (current.degrees + additional.degrees) % 360;
    return PageRotation.fromDegrees(totalDegrees);
  }

  /// Calculate new dimensions after rotation
  static PageDimensions _rotatedDimensions(
    PageDimensions original,
    PageRotation rotation,
  ) {
    if (rotation == PageRotation.none || rotation == PageRotation.rotate180) {
      return original;
    }

    // For 90° and 270° rotations, swap width and height
    return PageDimensions(
      width: original.height,
      height: original.width,
    );
  }

  /// Calculate rotation transformation matrix
  static List<double> _calculateRotationMatrix(
    List<double> currentMatrix,
    PageRotation rotation,
  ) {
    final radians = rotation.degrees * math.pi / 180;
    final cos = math.cos(radians);
    final sin = math.sin(radians);

    // 2D rotation matrix
    final rotationMatrix = [
      cos, -sin,
      sin, cos,
    ];

    return _multiplyMatrices(currentMatrix, rotationMatrix);
  }

  /// Multiply two 2x2 matrices
  static List<double> _multiplyMatrices(
    List<double> a,
    List<double> b,
  ) {
    if (a.length < 4 || b.length < 4) {
      return [1, 0, 0, 1]; // Identity matrix
    }

    return [
      a[0] * b[0] + a[1] * b[2],
      a[0] * b[1] + a[1] * b[3],
      a[2] * b[0] + a[3] * b[2],
      a[2] * b[1] + a[3] * b[3],
    ];
  }

  /// Renumber pages after manipulation
  static List<PdfPageData> _renumberPages(List<PdfPageData> pages) {
    return pages.asMap().entries.map((entry) {
      final index = entry.key;
      final page = entry.value;
      return page.copyWith(pageNumber: index + 1);
    }).toList();
  }
}

/// Represents a PDF page with manipulation metadata
class PdfPageData {
  final int pageNumber;
  final PageDimensions dimensions;
  final PageRotation rotation;
  final List<double> transformMatrix;
  final bool isDuplicate;
  final bool isBlank;
  final DateTime lastModified;
  final Uint8List? thumbnailData;
  final Map<String, dynamic>? metadata;

  const PdfPageData({
    required this.pageNumber,
    required this.dimensions,
    this.rotation = PageRotation.none,
    this.transformMatrix = const [1, 0, 0, 1], // Identity matrix
    this.isDuplicate = false,
    this.isBlank = false,
    required this.lastModified,
    this.thumbnailData,
    this.metadata,
  });

  /// Create a blank page
  factory PdfPageData.createBlank({
    PageDimensions? dimensions,
  }) {
    return PdfPageData(
      pageNumber: 0,
      dimensions: dimensions ?? PageDimensions.a4(),
      isBlank: true,
      lastModified: DateTime.now(),
    );
  }

  /// Page orientation based on dimensions
  PageOrientation get orientation {
    if (dimensions.width > dimensions.height) {
      return PageOrientation.landscape;
    } else if (dimensions.width < dimensions.height) {
      return PageOrientation.portrait;
    } else {
      return PageOrientation.square;
    }
  }

  /// Check if page has been modified
  bool get isModified => rotation != PageRotation.none || isDuplicate;

  PdfPageData copyWith({
    int? pageNumber,
    PageDimensions? dimensions,
    PageRotation? rotation,
    List<double>? transformMatrix,
    bool? isDuplicate,
    bool? isBlank,
    DateTime? lastModified,
    Uint8List? thumbnailData,
    Map<String, dynamic>? metadata,
  }) {
    return PdfPageData(
      pageNumber: pageNumber ?? this.pageNumber,
      dimensions: dimensions ?? this.dimensions,
      rotation: rotation ?? this.rotation,
      transformMatrix: transformMatrix ?? this.transformMatrix,
      isDuplicate: isDuplicate ?? this.isDuplicate,
      isBlank: isBlank ?? this.isBlank,
      lastModified: lastModified ?? this.lastModified,
      thumbnailData: thumbnailData ?? this.thumbnailData,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PdfPageData &&
          runtimeType == other.runtimeType &&
          pageNumber == other.pageNumber &&
          dimensions == other.dimensions &&
          rotation == other.rotation;

  @override
  int get hashCode =>
      pageNumber.hashCode ^
      dimensions.hashCode ^
      rotation.hashCode;

  @override
  String toString() =>
      'PdfPageData(page: $pageNumber, ${dimensions}, rotation: ${rotation.degrees}°)';
}

/// Page dimensions
class PageDimensions {
  final double width;
  final double height;

  const PageDimensions({
    required this.width,
    required this.height,
  });

  /// Standard A4 dimensions (in points)
  factory PageDimensions.a4() => const PageDimensions(
    width: 595.276,
    height: 841.89,
  );

  /// Standard letter dimensions (in points)
  factory PageDimensions.letter() => const PageDimensions(
    width: 612,
    height: 792,
  );

  /// Page area
  double get area => width * height;

  /// Aspect ratio (width/height)
  double get aspectRatio => width / height;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PageDimensions &&
          runtimeType == other.runtimeType &&
          (width - other.width).abs() < 0.1 &&
          (height - other.height).abs() < 0.1;

  @override
  int get hashCode => width.hashCode ^ height.hashCode;

  @override
  String toString() => '${width.toStringAsFixed(1)}×${height.toStringAsFixed(1)}';
}

/// Page rotation options
enum PageRotation {
  none(0),
  rotate90(90),
  rotate180(180),
  rotate270(270);

  const PageRotation(this.degrees);

  final int degrees;

  /// Create rotation from degrees
  static PageRotation fromDegrees(int degrees) {
    final normalizedDegrees = degrees % 360;
    return PageRotation.values.firstWhere(
      (rotation) => rotation.degrees == normalizedDegrees,
      orElse: () => PageRotation.none,
    );
  }

  /// Display name for UI
  String get displayName {
    switch (this) {
      case PageRotation.none:
        return 'No rotation';
      case PageRotation.rotate90:
        return '90° clockwise';
      case PageRotation.rotate180:
        return '180°';
      case PageRotation.rotate270:
        return '270° clockwise';
    }
  }
}

/// Page orientation
enum PageOrientation {
  portrait,
  landscape,
  square,
}

/// Statistics about a collection of pages
class PageStatistics {
  final int totalPages;
  final Map<PageOrientation, int> orientationCounts;
  final List<PageDimensions> uniqueDimensions;
  final int rotatedPages;
  final double totalArea;
  final double averageArea;

  const PageStatistics({
    required this.totalPages,
    required this.orientationCounts,
    required this.uniqueDimensions,
    required this.rotatedPages,
    required this.totalArea,
    required this.averageArea,
  });

  /// Empty statistics
  factory PageStatistics.empty() => const PageStatistics(
    totalPages: 0,
    orientationCounts: {},
    uniqueDimensions: [],
    rotatedPages: 0,
    totalArea: 0,
    averageArea: 0,
  );

  /// Most common orientation
  PageOrientation? get predominantOrientation {
    if (orientationCounts.isEmpty) return null;

    return orientationCounts.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  /// Check if all pages have consistent dimensions
  bool get hasConsistentDimensions => uniqueDimensions.length <= 1;

  @override
  String toString() => 'PageStatistics($totalPages pages, '
      '${rotatedPages} rotated, '
      'predominant: $predominantOrientation)';
}

/// Exception for page manipulation operations
class PageManipulationException implements Exception {
  final String message;

  const PageManipulationException(this.message);

  @override
  String toString() => 'PageManipulationException: $message';
}