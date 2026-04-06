/// Template selector widget for Indian Data Faker
///
/// Allows users to select between different entity templates

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../faker_state.dart';

/// Widget for selecting template type
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(LucideIcons.fileText),
                const SizedBox(width: 8),
                Text(
                  'Entity Template',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Template options
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: TemplateType.values.map((template) {
                final isSelected = template == selectedTemplate;

                return FilterChip(
                  selected: isSelected,
                  onSelected: (_) => onTemplateChanged(template),
                  avatar: Icon(
                    _getTemplateIcon(template),
                    size: 16,
                  ),
                  label: Text(template.displayName),
                  backgroundColor: isSelected
                      ? Theme.of(context).colorScheme.primaryContainer
                      : null,
                  selectedColor: Theme.of(context).colorScheme.primaryContainer,
                );
              }).toList(),
            ),

            const SizedBox(height: 12),

            // Selected template description
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedTemplate.displayName,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    selectedTemplate.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildIdentifierPreview(context, selectedTemplate),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Get icon for template type
  IconData _getTemplateIcon(TemplateType template) {
    switch (template) {
      case TemplateType.individual:
        return LucideIcons.user;
      case TemplateType.company:
        return LucideIcons.building;
      case TemplateType.proprietorship:
        return LucideIcons.briefcase;
      case TemplateType.partnership:
        return LucideIcons.users;
      case TemplateType.trust:
        return LucideIcons.landmark;
    }
  }

  /// Build identifier preview for selected template
  Widget _buildIdentifierPreview(BuildContext context, TemplateType template) {
    final identifiers = _getTemplateIdentifiers(template);

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: identifiers.map((identifier) {
        return Chip(
          label: Text(
            identifier.toUpperCase(),
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          side: BorderSide(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            width: 1,
          ),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: EdgeInsets.zero,
          labelPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
        );
      }).toList(),
    );
  }

  /// Get identifiers for template
  List<String> _getTemplateIdentifiers(TemplateType template) {
    switch (template) {
      case TemplateType.individual:
        return ['PAN', 'Aadhaar', 'PIN', 'Address', 'UPI'];
      case TemplateType.company:
        return ['PAN', 'GSTIN', 'CIN', 'TAN', 'IFSC', 'UPI', 'Udyam'];
      case TemplateType.proprietorship:
        return ['PAN', 'GSTIN', 'Udyam', 'TAN', 'UPI'];
      case TemplateType.partnership:
        return ['PAN', 'GSTIN', 'TAN', 'IFSC', 'UPI', 'Partners'];
      case TemplateType.trust:
        return ['PAN', 'GSTIN', 'TAN', 'IFSC', 'UPI', 'Registration'];
    }
  }
}