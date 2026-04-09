/// Home screen with tool cards
library home_screen;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/l10n.dart';
import '../../theme/app_theme.dart';
import '../../shared/widgets/tool_scaffold.dart';
import '../../shared/widgets/responsive_layout.dart';
import '../../shared/widgets/language_switcher.dart';

/// Home screen displaying all tools in a professional Bento grid
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return CustomScrollView(
      slivers: [
        // Elegant App Bar with Language Switcher
        SliverAppBar(
          expandedHeight: 180.0,
          floating: false,
          pinned: true,
          backgroundColor: theme.colorScheme.surface,
          elevation: 0,
          actions: const [
            LanguageSwitcher(),
            SizedBox(width: 8),
          ],
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            titlePadding: const EdgeInsets.only(bottom: 16),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'BT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'BharatTesting',
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.colorScheme.primary.withOpacity(0.05),
                    theme.colorScheme.surface,
                  ],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Icon(
                      Icons.verified_user_outlined,
                      size: 40,
                      color: theme.colorScheme.primary.withOpacity(0.2),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Main Content
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                
                // Trust Badge
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.green.withOpacity(0.2)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.lock_outline, size: 16, color: Colors.green),
                        const SizedBox(width: 8),
                        Text(
                          '100% Private & Offline - No Data Leaves Your Device',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: Colors.green[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 40),
                
                Text(
                  l10n.homeTitle,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                
                // Bento Grid
                _BentoToolGrid(),
                
                const SizedBox(height: 60),
                
                // Privacy & Security Section
                Text(
                  'Privacy & Security',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const _PrivacySection(),
                
                const SizedBox(height: 60),
                
                // Footer info
                Center(
                  child: Opacity(
                    opacity: 0.5,
                    child: Text(
                      '© 2026 BharatTesting Utilities • v1.0.0',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _BentoToolGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 1200 ? 3 : (screenWidth > 700 ? 2 : 1);

    final tools = [
      _ToolData(
        title: l10n.dataFakerTitle,
        description: l10n.dataFakerSubtitle,
        icon: Icons.badge_outlined,
        route: '/indian-data-faker',
        color: Colors.blue,
      ),
      _ToolData(
        title: l10n.jsonConverterTitle,
        description: l10n.jsonConverterSubtitle,
        icon: Icons.data_object_outlined,
        route: '/string-to-json',
        color: Colors.indigo,
      ),
      _ToolData(
        title: l10n.imageSizeReducerTitle,
        description: 'Optimize images for official portals and uploads.',
        icon: Icons.photo_size_select_large_outlined,
        route: '/image-reducer',
        color: Colors.teal,
      ),
      _ToolData(
        title: l10n.pdfMergerTitle,
        description: 'Combine and organize PDF documents securely.',
        icon: Icons.picture_as_pdf_outlined,
        route: '/pdf-merger',
        color: Colors.redAccent,
      ),
      _ToolData(
        title: l10n.documentScannerTitle,
        description: 'Professional scanning with OCR and edge detection.',
        icon: Icons.document_scanner_outlined,
        route: '/document-scanner',
        color: Colors.amber[800]!,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 1.5,
      ),
      itemCount: tools.length,
      itemBuilder: (context, index) {
        final tool = tools[index];
        return _BentoCard(data: tool);
      },
    );
  }
}

class _ToolData {
  final String title;
  final String description;
  final IconData icon;
  final String route;
  final Color color;

  _ToolData({
    required this.title,
    required this.description,
    required this.icon,
    required this.route,
    required this.color,
  });
}

class _BentoCard extends StatelessWidget {
  final _ToolData data;

  const _BentoCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: theme.colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () => context.go(data.route),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                data.color.withOpacity(0.05),
                theme.colorScheme.surface,
              ],
            ),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: data.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  data.icon,
                  color: data.color,
                  size: 28,
                ),
              ),
              const Spacer(),
              Text(
                data.title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                data.description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PrivacySection extends StatelessWidget {
  const _PrivacySection();

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: Column(
        children: const [
          _PrivacyItem(
            icon: Icons.cloud_off_outlined,
            title: '100% Offline',
            description: 'All processing happens locally. Your files never leave your device.',
          ),
          SizedBox(height: 12),
          _PrivacyItem(
            icon: Icons.analytics_outlined,
            title: 'No Tracking',
            description: 'We do not collect any personal data or usage metrics.',
          ),
          SizedBox(height: 12),
          _PrivacyItem(
            icon: Icons.code_outlined,
            title: 'Open Source',
            description: 'Transparent and verifiable code built for the community.',
          ),
        ],
      ),
      tablet: Row(
        children: const [
          Expanded(
            child: _PrivacyItem(
              icon: Icons.cloud_off_outlined,
              title: '100% Offline',
              description: 'All processing happens locally. Your files never leave your device.',
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: _PrivacyItem(
              icon: Icons.analytics_outlined,
              title: 'No Tracking',
              description: 'We do not collect any personal data or usage metrics.',
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: _PrivacyItem(
              icon: Icons.code_outlined,
              title: 'Open Source',
              description: 'Transparent and verifiable code built for the community.',
            ),
          ),
        ],
      ),
    );
  }
}

class _PrivacyItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _PrivacyItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: theme.colorScheme.primary, size: 24),
          const SizedBox(height: 12),
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
