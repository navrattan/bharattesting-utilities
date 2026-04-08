/// Identifier picker widget for custom data selection
///
/// Allows users to toggle specific Indian identifiers for generation

import 'package:flutter/material.dart';

import '../faker_state.dart';

/// Widget for selecting specific identifier types
class IdentifierPicker extends StatelessWidget {
  const IdentifierPicker({
    required this.selectedIdentifiers,
    required this.onToggle,
    super.key,
  });

  final Set<String> selectedIdentifiers;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // List of all available identifier types
    final availableTypes = [
      {'id': 'pan', 'name': 'PAN', 'desc': 'Permanent Account Number'},
      {'id': 'gstin', 'name': 'GSTIN', 'desc': 'GST Identification Number'},
      {'id': 'aadhaar', 'name': 'Aadhaar', 'desc': '12-digit UID'},
      {'id': 'cin', 'name': 'CIN', 'desc': 'Corporate Identity Number'},
      {'id': 'tan', 'name': 'TAN', 'desc': 'Tax Deduction Account Number'},
      {'id': 'ifsc', 'name': 'IFSC', 'desc': 'Bank Branch Code'},
      {'id': 'upi', 'name': 'UPI ID', 'desc': 'Virtual Payment Address'},
      {'id': 'udyam', 'name': 'Udyam', 'desc': 'MSME Registration'},
      {'id': 'pin', 'name': 'PIN Code', 'desc': 'Postal Index Number'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Included Identifiers',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: availableTypes.map((type) {
            final id = type['id']!;
            final isSelected = selectedIdentifiers.contains(id);

            return FilterChip(
              label: Text(type['name']!),
              selected: isSelected,
              onSelected: (_) => onToggle(id),
              tooltip: type['desc'],
              selectedColor: theme.colorScheme.primaryContainer,
              checkmarkColor: theme.colorScheme.primary,
              labelStyle: TextStyle(
                color: isSelected ? theme.colorScheme.onPrimaryContainer : null,
                fontWeight: isSelected ? FontWeight.bold : null,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
