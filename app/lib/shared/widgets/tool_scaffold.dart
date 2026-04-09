/// Tool scaffold - shared layout with navigation and footer
library tool_scaffold;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'responsive_layout.dart';
import 'btqa_footer.dart';
import 'github_buttons.dart';
import '../providers/locale_provider.dart';
import '../../router/app_router.dart';
import '../../theme/app_theme.dart';

/// Main scaffold that wraps all tool screens
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
    final content = body ?? child ?? const SizedBox.shrink();

    return ResponsiveLayout(
      mobile: _MobileLayout(
        child: content,
        title: title,
        actions: actions,
        drawer: drawer,
        endDrawer: endDrawer,
      ),
      tablet: _TabletLayout(
        child: content,
        title: title,
        subtitle: subtitle,
        actions: actions,
        drawer: drawer,
        endDrawer: endDrawer,
      ),
      desktop: _DesktopLayout(
        child: content,
        title: title,
        subtitle: subtitle,
        actions: actions,
        drawer: drawer,
        endDrawer: endDrawer,
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
  });

  final Widget child;
  final String? title;
  final List<Widget>? actions;
  final Widget? drawer;
  final Widget? endDrawer;

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).uri.path;
    final currentIndex = AppRouter.getCurrentIndex(currentLocation);

    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? 'BharatTesting'),
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
        onDestinationSelected: (index) {
          AppRouter.navigateToIndex(context, index);
        },
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
  });

  final Widget child;
  final String? title;
  final String? subtitle;
  final List<Widget>? actions;
  final Widget? drawer;
  final Widget? endDrawer;

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
            onDestinationSelected: (index) {
              AppRouter.navigateToIndex(context, index);
            },
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
                  title: Text(title ?? 'BharatTesting Utilities'),
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

/// Desktop layout with top navigation and side rail
class _DesktopLayout extends StatelessWidget {
  const _DesktopLayout({
    required this.child,
    this.title,
    this.subtitle,
    this.actions,
    this.drawer,
    this.endDrawer,
  });

  final Widget child;
  final String? title;
  final String? subtitle;
  final List<Widget>? actions;
  final Widget? drawer;
  final Widget? endDrawer;

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).uri.path;
    final currentIndex = AppRouter.getCurrentIndex(currentLocation);

    return Scaffold(
      drawer: drawer,
      endDrawer: endDrawer,
      body: Column(
        children: [
          // Top navigation bar
          Material(
            elevation: 1,
            child: Container(
              height: 64,
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingXl,
              ),
              child: Row(
                children: [
                  Text(
                    title ?? 'BharatTesting Utilities',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
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
                                onTap: () => AppRouter.navigateToIndex(
                                  context,
                                  entry.key,
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                  if (actions != null) ...actions!,
                  const SizedBox(width: AppTheme.spacingSm),
                  const LanguageSwitcher(),
                  const GitHubButtons(),
                ],
              ),
            ),
          ),
          if (subtitle != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppTheme.spacingXl,
                AppTheme.spacingMd,
                AppTheme.spacingXl,
                AppTheme.spacingSm,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  subtitle!,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          Expanded(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: Breakpoints.desktop,
              ),
              child: child,
            ),
          ),
          const BTQAFooter(),
        ],
      ),
    );
  }
}

/// Desktop navigation item
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingSm),
      child: TextButton.icon(
        onPressed: onTap,
        icon: isSelected ? selectedIcon : icon,
        label: Text(label),
        style: TextButton.styleFrom(
          foregroundColor: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSurfaceVariant,
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingLg,
            vertical: AppTheme.spacingMd,
          ),
        ),
      ),
    );
  }
}

class LanguageSwitcher extends ConsumerWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.language),
      tooltip: 'Switch Language',
      onSelected: (String languageCode) {
        ref.read(localeNotifierProvider.notifier).setLanguageCode(languageCode);
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'en',
          child: Text('English'),
        ),
        const PopupMenuItem<String>(
          value: 'hi',
          child: Text('हिन्दी (Hindi)'),
        ),
        const PopupMenuItem<String>(
          value: 'bn',
          child: Text('বাংলা (Bengali)'),
        ),
        const PopupMenuItem<String>(
          value: 'mr',
          child: Text('मराठी (Marathi)'),
        ),
        const PopupMenuItem<String>(
          value: 'te',
          child: Text('తెలుగు (Telugu)'),
        ),
        const PopupMenuItem<String>(
          value: 'pa',
          child: Text('ਪੰਜਾਬੀ (Punjabi)'),
        ),
      ],
    );
  }
}
