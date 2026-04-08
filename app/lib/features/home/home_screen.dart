/// Home screen with tool cards
library home_screen;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Home screen displaying all 5 tools as cards
///
/// Layout:
/// - Welcome text
/// - Grid of tool cards (responsive)
/// - Each card shows icon, name, description
/// - Tap to navigate to tool
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 24),

                // Welcome section
                Text(
                  'BharatTesting Utilities',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  '5 free, privacy-first, offline developer tools',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 32),

                // Tool cards grid
                Expanded(
                  child: _ToolCardsGrid(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Grid of tool cards
class _ToolCardsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: _getCrossAxisCount(context),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: const [
        _ToolCard(
          title: 'Indian Data Faker',
          description: 'Generate PAN, GSTIN, Aadhaar, etc.',
          icon: Icons.account_circle,
          route: '/indian-data-faker',
          status: 'Live',
        ),
        _ToolCard(
          title: 'String-to-JSON',
          description: 'Auto-repair broken JSON/CSV/YAML',
          icon: Icons.code,
          route: '/string-to-json',
          status: 'Live',
        ),
        _ToolCard(
          title: 'Image Size Reducer',
          description: 'Compress, resize, batch process',
          icon: Icons.photo_size_select_large,
          route: '/image-reducer',
          status: 'Coming Soon',
        ),
        _ToolCard(
          title: 'PDF Merger',
          description: 'Merge, rotate, password-protect',
          icon: Icons.picture_as_pdf,
          route: '/pdf-merger',
          status: 'Coming Soon',
        ),
        _ToolCard(
          title: 'Document Scanner',
          description: 'Camera + OCR → Searchable PDF',
          icon: Icons.document_scanner,
          route: '/document-scanner',
          status: 'Coming Soon',
        ),
      ],
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 1200) return 3;
    if (screenWidth > 600) return 2;
    return 1;
  }
}

/// Individual tool card
class _ToolCard extends StatelessWidget {
  const _ToolCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.route,
    required this.status,
  });

  final String title;
  final String description;
  final IconData icon;
  final String route;
  final String status;

  @override
  Widget build(BuildContext context) {
    final isLive = status == 'Live';

    return Card(
      child: InkWell(
        onTap: isLive ? () => context.go(route) : null,
        borderRadius: BorderRadius.circular(12),
        child: Opacity(
          opacity: isLive ? 1.0 : 0.6,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 48,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isLive
                        ? Theme.of(context).colorScheme.secondaryContainer
                        : Theme.of(context).colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    status,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: isLive
                              ? Theme.of(context).colorScheme.onSecondaryContainer
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}