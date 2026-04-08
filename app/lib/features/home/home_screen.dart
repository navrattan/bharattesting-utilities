/// Home screen with tool cards
library home_screen;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Home screen displaying all 6 tools as cards
///
/// Layout:
/// - BT Logo
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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  // BT Logo
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF58A6FF), Color(0xFF0969DA)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF58A6FF).withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'BT',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -2,
                        ),
                      ),
                    ),
                  ),

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
                    'Free, privacy-first, 100% offline developer tools',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 40),

                  // Tool cards grid
                  _ToolCardsGrid(),

                  const SizedBox(height: 40),
                ],
              ),
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
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
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
          status: 'Live',
        ),
        _ToolCard(
          title: 'PDF Merger',
          description: 'Merge, rotate, password-protect',
          icon: Icons.picture_as_pdf,
          route: '/pdf-merger',
          status: 'Live',
        ),
        _ToolCard(
          title: 'Document Scanner',
          description: 'Camera + OCR → Searchable PDF',
          icon: Icons.document_scanner,
          route: '/document-scanner',
          status: 'Live',
        ),
        _ToolCard(
          title: 'About BharatTesting',
          description: 'Project info, mission, and open source',
          icon: Icons.info_outline,
          route: '/about',
          status: 'Live',
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
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: InkWell(
        onTap: () => context.go(route),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  status,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
