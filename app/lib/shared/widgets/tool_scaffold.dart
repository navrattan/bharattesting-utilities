/// Tool scaffold - shared layout with navigation and footer
library tool_scaffold;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'responsive_layout.dart';
import 'btqa_footer.dart';
import 'github_buttons.dart';
import '../providers/locale_provider.dart';
import '../models/tool_branding.dart';
import '../services/branding_service.dart';
import '../../router/app_router.dart';
import '../../theme/app_theme.dart';

/// Main scaffold that wraps all tool screens with Dynamic Branding
class ToolScaffold extends ConsumerWidget {
  const ToolScaffold({
    this.child,
    this.body,
    this.title,
    this.subtitle,
    this.icon,
    this.actions,
    this.drawer,
    this.endDrawer,
    super.key,
  });

  final Widget? child;
  final Widget? body;
  final String? title;
  final String? subtitle;
  final IconData? icon;
  final List<Widget>? actions;
  final Widget? drawer;
  final Widget? endDrawer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We assume the caller handles scrolling if body is provided.
    // If child is provided, we wrap it in a SingleChildScrollView.
    final Widget mainContent = body ?? (child != null ? SingleChildScrollView(child: child!) : const SizedBox.shrink());
    
    final path = GoRouterState.of(context).uri.path;
    final intent = ToolIntent.fromPath(path);
    final branding = ToolBranding.all[intent];
    
    // Update browser title
    BrandingService.updateBrowserTitle(path);

    // Apply branding color if available
    return Theme(
      data: branding != null 
        ? Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: branding.primaryColor,
            ),
          )
        : Theme.of(context),
      child: ResponsiveLayout(
        mobile: _MobileLayout(
          child: mainContent,
          title: branding?.standaloneTitle ?? title,
          actions: actions,
          drawer: drawer,
          endDrawer: endDrawer,
          branding: branding,
        ),
        tablet: _TabletLayout(
          child: mainContent,
          title: branding?.title ?? title,
          subtitle: subtitle,
          actions: actions,
          drawer: drawer,
          endDrawer: endDrawer,
          branding: branding,
        ),
        desktop: _DesktopLayout(
          child: mainContent,
          title: branding?.title ?? title,
          subtitle: subtitle,
          actions: actions,
          drawer: drawer,
          endDrawer: endDrawer,
          branding: branding,
        ),
      ),
    );
  }
}

/// Mobile layout with bottom navigation
class _MobileLayout extends StatelessWidget {
  const _MobileLayout({
    required this.child,
    this.title,
    this.actions,
    this.drawer,
    this.endDrawer,
    this.branding,
  });

  final Widget child;
  final String? title;
  final List<Widget>? actions;
  final Widget? drawer;
  final Widget? endDrawer;
  final ToolBranding? branding;

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).uri.path;
    final currentIndex = AppRouter.getCurrentIndex(currentLocation);

    return Scaffold(
      appBar: AppBar(
        title: title != null ? Text(title!) : null,
        backgroundColor: branding != null ? branding!.primaryColor : null,
        foregroundColor: branding != null ? Colors.white : null,
        actions: [
          ...?actions,
          const LanguageSwitcher(),
          const GitHubButtons(compact: true),
        ],
      ),
      drawer: drawer,
      endDrawer: endDrawer,
      body: Column(
        children: [
          Expanded(child: child),
          const CompactBTQAFooter(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) => AppRouter.navigateToIndex(context, index),
        destinations: AppRouter.destinations,
      ),
    );
  }
}

/// Tablet layout with navigation rail
class _TabletLayout extends StatelessWidget {
  const _TabletLayout({
    required this.child,
    this.title,
    this.subtitle,
    this.actions,
    this.drawer,
    this.endDrawer,
    this.branding,
  });

  final Widget child;
  final String? title;
  final String? subtitle;
  final List<Widget>? actions;
  final Widget? drawer;
  final Widget? endDrawer;
  final ToolBranding? branding;

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).uri.path;
    final currentIndex = AppRouter.getCurrentIndex(currentLocation);

    return Scaffold(
      drawer: drawer,
      endDrawer: endDrawer,
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: currentIndex,
            onDestinationSelected: (index) => AppRouter.navigateToIndex(context, index),
            labelType: NavigationRailLabelType.selected,
            destinations: AppRouter.destinations
                .map((dest) => NavigationRailDestination(
                      icon: dest.icon,
                      selectedIcon: dest.selectedIcon ?? dest.icon,
                      label: Text(dest.label),
                    ))
                .toList(),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Column(
              children: [
                AppBar(
                  title: Text(title ?? 'BharatTesting'),
                  backgroundColor: branding != null ? branding!.primaryColor.withOpacity(0.1) : null,
                  actions: [
                    ...?actions,
                    const LanguageSwitcher(),
                    const GitHubButtons(),
                  ],
                  automaticallyImplyLeading: false,
                ),
                if (subtitle != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        subtitle!,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                Expanded(child: child),
                const BTQAFooter(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Desktop layout with top navigation
class _DesktopLayout extends StatelessWidget {
  const _DesktopLayout({
    required this.child,
    this.title,
    this.subtitle,
    this.actions,
    this.drawer,
    this.endDrawer,
    this.branding,
  });

  final Widget child;
  final String? title;
  final String? subtitle;
  final List<Widget>? actions;
  final Widget? drawer;
  final Widget? endDrawer;
  final ToolBranding? branding;

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).uri.path;
    final currentIndex = AppRouter.getCurrentIndex(currentLocation);
    final theme = Theme.of(context);

    return Scaffold(
      drawer: drawer,
      endDrawer: endDrawer,
      body: Column(
        children: [
          // Dynamic Branded Header
          Material(
            elevation: 1,
            color: branding != null ? branding!.primaryColor : theme.colorScheme.surface,
            child: Container(
              height: 64,
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingXl),
              child: Row(
                children: [
                  if (branding != null) ...[
                    Icon(branding!.icon, color: Colors.white),
                    const SizedBox(width: 12),
                  ],
                  Text(
                    title ?? 'BharatTesting Utilities',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: branding != null ? Colors.white : null,
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingXl),
                  Expanded(
                    child: Row(
                      children: AppRouter.destinations
                          .asMap()
                          .entries
                          .map((entry) => _DesktopNavItem(
                                label: entry.value.label,
                                icon: entry.value.icon,
                                selectedIcon: entry.value.selectedIcon ?? entry.value.icon,
                                isSelected: entry.key == currentIndex,
                                isBranded: branding != null,
                                onTap: () => AppRouter.navigateToIndex(context, entry.key),
                              ))
                          .toList(),
                    ),
                  ),
                  if (actions != null) ...actions!,
                  const LanguageSwitcher(isBranded: true),
                  const GitHubButtons(),
                ],
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                if (subtitle != null)
                  Padding(
                    padding: const EdgeInsets.all(AppTheme.spacingXl),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(subtitle!, style: theme.textTheme.bodyLarge),
                    ),
                  ),
                Expanded(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: child,
                    ),
                  ),
                ),
                const BTQAFooter(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DesktopNavItem extends StatelessWidget {
  const _DesktopNavItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.isSelected,
    required this.onTap,
    this.isBranded = false,
  });

  final String label;
  final Widget icon;
  final Widget selectedIcon;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isBranded;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isBranded 
        ? (isSelected ? Colors.white : Colors.white70)
        : (isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingSm),
      child: TextButton.icon(
        onPressed: onTap,
        icon: isSelected ? selectedIcon : icon,
        label: Text(label),
        style: TextButton.styleFrom(
          foregroundColor: color,
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg, vertical: AppTheme.spacingMd),
        ),
      ),
    );
  }
}

class LanguageSwitcher extends ConsumerWidget {
  final bool isBranded;
  const LanguageSwitcher({this.isBranded = false, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.language, color: isBranded ? Colors.white : null),
      tooltip: 'Switch Language',
      onSelected: (String languageCode) {
        ref.read(localeNotifierProvider.notifier).setLanguageCode(languageCode);
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(value: 'en', child: Text('English')),
        const PopupMenuItem<String>(value: 'hi', child: Text('हिन्दी (Hindi)')),
        const PopupMenuItem<String>(value: 'bn', child: Text('বাংলা (Bengali)')),
        const PopupMenuItem<String>(value: 'mr', child: Text('मਰਾਠੀ (Marathi)')),
        const PopupMenuItem<String>(value: 'te', child: Text('తెలుగు (Telugu)')),
        const PopupMenuItem<String>(value: 'pa', child: Text('ਪੰਜਾਬੀ (Punjabi)')),
      ],
    );
  }
}
