import 'package:flutter/material.dart';

enum ToolIntent {
  faker,
  json,
  image,
  pdf,
  scanner,
  none;

  static ToolIntent fromPath(String path) {
    if (path.contains('indian-data-faker')) return ToolIntent.faker;
    if (path.contains('string-to-json')) return ToolIntent.json;
    if (path.contains('image-reducer')) return ToolIntent.image;
    if (path.contains('pdf-merger')) return ToolIntent.pdf;
    if (path.contains('document-scanner')) return ToolIntent.scanner;
    return ToolIntent.none;
  }
}

class ToolBranding {
  final String title;
  final String standaloneTitle;
  final Color primaryColor;
  final IconData icon;
  final String seoTitle;

  const ToolBranding({
    required this.title,
    required this.standaloneTitle,
    required this.primaryColor,
    required this.icon,
    required this.seoTitle,
  });

  static Map<ToolIntent, ToolBranding> get all => {
    ToolIntent.faker: const ToolBranding(
      title: 'Indian Data Faker',
      standaloneTitle: 'BT Faker',
      primaryColor: Colors.blue,
      icon: Icons.badge_outlined,
      seoTitle: 'Indian Data Faker | BharatTesting',
    ),
    ToolIntent.json: const ToolBranding(
      title: 'String to JSON',
      standaloneTitle: 'BT JSON',
      primaryColor: Colors.indigo,
      icon: Icons.data_object_outlined,
      seoTitle: 'JSON Converter & Repair | BharatTesting',
    ),
    ToolIntent.image: const ToolBranding(
      title: 'Image Size Reducer',
      standaloneTitle: 'BT Image',
      primaryColor: Colors.teal,
      icon: Icons.photo_size_select_large_outlined,
      seoTitle: 'Image Size Reducer | BharatTesting',
    ),
    ToolIntent.pdf: const ToolBranding(
      title: 'PDF Merger',
      standaloneTitle: 'BT PDF',
      primaryColor: Color(0xFFE53935),
      icon: Icons.picture_as_pdf_outlined,
      seoTitle: 'Secure PDF Merger | BharatTesting',
    ),
    ToolIntent.scanner: const ToolBranding(
      title: 'Document Scanner',
      standaloneTitle: 'BT Scanner',
      primaryColor: Color(0xFFFF8F00),
      icon: Icons.document_scanner_outlined,
      seoTitle: 'Document Scanner | BharatTesting',
    ),
  };
}
