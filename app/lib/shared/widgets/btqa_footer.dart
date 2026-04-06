/// BTQA footer widget - required on every screen
library btqa_footer;

import 'package:flutter/material.dart';
import '../../../theme/app_typography.dart';
import '../../../theme/app_theme.dart';

/// Footer widget that appears on every screen
///
/// Requirements:
/// - Text: "Built by BTQA Services Pvt Ltd • Open Source on GitHub • Made in Bengaluru"
/// - "BTQA Services Pvt Ltd" links to btqas.com
/// - Subtle styling (small gray text)
/// - Must be on EVERY screen without exception
class BTQAFooter extends StatelessWidget {
  const BTQAFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline,
            width: 1,
          ),
        ),
      ),
      child: Center(
        child: Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              'Built by ',
              style: AppTypography.footer.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  // TODO: Launch URL to btqas.com
                  debugPrint('Navigate to btqas.com');
                },
                child: Text(
                  'BTQA Services Pvt Ltd',
                  style: AppTypography.footer.copyWith(
                    color: theme.colorScheme.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            Text(
              ' • ',
              style: AppTypography.footer.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  // TODO: Launch GitHub URL
                  debugPrint('Navigate to GitHub');
                },
                child: Text(
                  'Open Source on GitHub',
                  style: AppTypography.footer.copyWith(
                    color: theme.colorScheme.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            Text(
              ' • Made in Bengaluru',
              style: AppTypography.footer.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Compact footer for mobile layouts
class CompactBTQAFooter extends StatelessWidget {
  const CompactBTQAFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingLg,
        vertical: AppTheme.spacingMd,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline,
            width: 1,
          ),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  debugPrint('Navigate to btqas.com');
                },
                child: Text(
                  'BTQA Services Pvt Ltd',
                  style: AppTypography.footer.copyWith(
                    color: theme.colorScheme.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Open Source • Made in Bengaluru',
              style: AppTypography.footer.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}