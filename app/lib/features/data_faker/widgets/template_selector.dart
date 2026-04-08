/// Template selector widget for Indian Data Faker
///
/// Provides a horizontal list or grid of predefined data templates

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../faker_state.dart';

/// Widget for selecting a data generation template
class TemplateSelector extends StatelessWidget {
  const TemplateSelector({
    required this.selectedTemplate,
    required this.onTemplateChanged,
    super.key,
  });

  final TemplateType selectedTemplate;
  final ValueChanged<TemplateType> onTemplateChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Template',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: _getCrossAxisCount(context),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 2.2,
          children: TemplateType.values.map((type) {
            return _TemplateCard(
              type: type,
              isSelected: selectedTemplate == type,
              onTap: () => onTemplateChanged(type),
            );
          }).toList(),
        ),
      ],
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 900) return 3;
    if (width > 600) return 2;
    return 1;
  }
}

class _TemplateCard extends StatelessWidget {
  const _TemplateCard({
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  final TemplateType type;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primaryContainer
              : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withValues(alpha: 0.1),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.colorScheme.primary.withValues(alpha: 0.1)
                    : theme.colorScheme.surface.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getIconForType(type),
                size: 20,
                color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    type.displayName,
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? theme.colorScheme.onPrimaryContainer : null,
                    ),
                  ),
                  Text(
                    _getDescriptionForType(type),
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 10,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                size: 16,
                color: theme.colorScheme.primary,
              ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForType(TemplateType type) {
    switch (type) {
      case TemplateType.individual:
        return LucideIcons.user;
      case TemplateType.company:
        return LucideIcons.building;
      case TemplateType.proprietorship:
        return LucideIcons.userCheck;
      case TemplateType.partnership:
        return LucideIcons.users;
      case TemplateType.trust:
        return LucideIcons.landmark;
    }
  }

  String _getDescriptionForType(TemplateType type) {
    switch (type) {
      case TemplateType.individual:
        return 'Personal PAN, Aadhaar...';
      case TemplateType.company:
        return 'CIN, GSTIN, TAN...';
      case TemplateType.proprietorship:
        return 'Individual + Business IDs';
      case TemplateType.partnership:
        return 'Partnership Firm IDs';
      case TemplateType.trust:
        return 'NGO and Trust IDs';
    }
  }
}
