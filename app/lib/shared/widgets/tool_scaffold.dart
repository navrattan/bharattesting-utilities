/// Tool scaffold - shared layout with navigation and footer
library tool_scaffold;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'responsive_layout.dart';
import 'btqa_footer.dart';
import 'github_buttons.dart';
import 'language_switcher.dart';
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
    final path = GoRouterState.of(context).uri.path;
    final intent = ToolIntent.fromPath(path);
    final branding = ToolBranding.all[intent];
    
    // Update browser title
    BrandingService.updateBrowserTitle(path);

    // Provide the content
    final Widget mainContent = body ?? child ?? const SizedBox.shrink();

    // FIX: Ensure we inherit the FULL theme and only override specific branding colors
    final baseTheme = Theme.of(context);
    final brandedTheme = branding != null 
        ? baseTheme.copyWith(
            colorScheme: baseTheme.colorScheme.copyWith(
              primary: branding.primaryColor,
              secondary: branding.primaryColor,
              onPrimary: Colors.white,
            ),
            // Ensure icons and primary buttons use the brand color
            primaryColor: branding.primaryColor,
            floatingActionButtonTheme: baseTheme.floatingActionButtonTheme.copyWith(
              backgroundColor: branding.primaryColor,
            ),
          )
        : baseTheme;

    return Theme(
      data: brandedTheme,
      child: Column(
        children: [
          const LegalDisclaimer(),
          Expanded(
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
          ),
        ],
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
        backgroundColor: branding?.primaryColor,
        foregroundColor: branding != null ? Colors.white : null,
        actions: [
          ...?actions,
          const LanguageSwitcher(),
          const GitHubButtons(compact: true),
        ],
      ),
      drawer: drawer,
      endDrawer: endDrawer,
      body: child,
      bottomNavigationBar: branding != null ? null : NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) => AppRouter.navigateToIndex(context, index),
        destinations: AppRouter.destinations,
      ),
    );
  }
}

/// Tablet layout
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
          if (branding == null) ...[
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
          ],
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
                  automaticallyImplyLeading: branding != null,
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

/// Desktop layout with FIXED visibility constraints
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
          // Dynamic Header
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
                  if (branding == null)
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
                                  onTap: () => AppRouter.navigateToIndex(context, entry.key),
                                ))
                            .toList(),
                      ),
                    )
                  else
                    const Spacer(),
                  if (actions != null) ...actions!,
                  LanguageSwitcher(isBranded: branding != null),
                  const GitHubButtons(),
                ],
              ),
            ),
          ),
          // Content Area - FIXED: Removed centering logic which caused height collapse on Web
          Expanded(
            child: Container(
              width: double.infinity,
              height: double.infinity, // Force full height
              color: theme.colorScheme.background,
              child: child,
            ),
          ),
          const BTQAFooter(),
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
  });

  final String label;
  final Widget icon;
  final Widget selectedIcon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingSm),
      child: TextButton.icon(
        onPressed: onTap,
        icon: isSelected ? selectedIcon : icon,
        label: Text(label),
        style: TextButton.styleFrom(
          foregroundColor: isSelected 
              ? theme.colorScheme.primary 
              : theme.colorScheme.onSurfaceVariant,
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingLg, 
            vertical: AppTheme.spacingMd,
          ),
        ),
      ),
    );
  }
}
