/// Tool scaffold - shared layout with navigation and footer
library tool_scaffold;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'responsive_layout.dart';
import 'btqa_footer.dart';
import 'github_buttons.dart';
import '../../router/app_router.dart';
import '../../theme/app_theme.dart';

/// Main scaffold that wraps all tool screens
///
/// Features:
/// - Responsive navigation (bottom nav on mobile, navigation rail on tablet/desktop)
/// - App bar with title and GitHub buttons
/// - Footer on every screen
/// - Consistent layout and spacing
class ToolScaffold extends StatelessWidget {
  const ToolScaffold({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: _MobileLayout(child: child),
      tablet: _TabletLayout(child: child),
      desktop: _DesktopLayout(child: child),
    );
  }
}

/// Mobile layout with bottom navigation
class _MobileLayout extends StatelessWidget {
  const _MobileLayout({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).uri.path;
    final currentIndex = AppRouter.getCurrentIndex(currentLocation);

    return Scaffold(
      appBar: AppBar(
        title: const Text('BharatTesting'),
        actions: const [
          GitHubButtons(compact: true),
        ],
      ),
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
  const _TabletLayout({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).uri.path;
    final currentIndex = AppRouter.getCurrentIndex(currentLocation);

    return Scaffold(
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
                      selectedIcon: dest.selectedIcon,
                      label: Text(dest.label),
                    ))
                .toList(),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Column(
              children: [
                AppBar(
                  title: const Text('BharatTesting Utilities'),
                  actions: const [GitHubButtons()],
                  automaticallyImplyLeading: false,
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
  const _DesktopLayout({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).uri.path;
    final currentIndex = AppRouter.getCurrentIndex(currentLocation);

    return Scaffold(
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
                    'BharatTesting Utilities',
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
                                selectedIcon: entry.value.selectedIcon,
                                isSelected: entry.key == currentIndex,
                                onTap: () => AppRouter.navigateToIndex(
                                  context,
                                  entry.key,
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                  const GitHubButtons(),
                ],
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