/// Identifier picker widget for custom selection
///
/// Allows advanced users to select specific identifiers to generate

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Widget for picking specific identifiers
class IdentifierPicker extends StatelessWidget {
  const IdentifierPicker({
    required this.availableIdentifiers,
    required this.selectedIdentifiers,
    required this.includeAll,
    required this.onIncludeAllChanged,
    required this.onIdentifierToggled,
    super.key,
  });

  final List<String> availableIdentifiers;
  final Set<String> selectedIdentifiers;
  final bool includeAll;
  final ValueChanged<bool> onIncludeAllChanged;
  final ValueChanged<String> onIdentifierToggled;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: const Icon(LucideIcons.checkSquare),
      title: const Text('Identifier Selection'),
      subtitle: Text(_getSubtitle()),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              // Include all toggle
              SwitchListTile(
                title: const Text('Include All Identifiers'),
                subtitle: Text(includeAll
                    ? 'All available identifiers will be generated'
                    : 'Select specific identifiers to generate'),
                value: includeAll,
                onChanged: onIncludeAllChanged,
              ),

              // Individual identifier selection
              if (!includeAll) ...[
                const Divider(),
                ...availableIdentifiers.map((identifier) {
                  final isSelected = selectedIdentifiers.contains(identifier);

                  return CheckboxListTile(
                    title: Text(_formatIdentifierName(identifier)),
                    subtitle: Text(_getIdentifierDescription(identifier)),
                    value: isSelected,
                    onChanged: (selected) {
                      if (selected != null) {
                        onIdentifierToggled(identifier);
                      }
                    },
                    secondary: Icon(
                      _getIdentifierIcon(identifier),
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  );
                }).toList(),

                if (selectedIdentifiers.isEmpty && !includeAll)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          LucideIcons.alertTriangle,
                          color: Theme.of(context).colorScheme.error,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Please select at least one identifier to generate',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  /// Get subtitle text for the expansion tile
  String _getSubtitle() {
    if (includeAll) {
      return 'All ${availableIdentifiers.length} identifiers';
    }

    if (selectedIdentifiers.isEmpty) {
      return 'No identifiers selected';
    }

    return '${selectedIdentifiers.length} of ${availableIdentifiers.length} selected';
  }

  /// Format identifier name for display
  String _formatIdentifierName(String identifier) {
    switch (identifier) {
      case 'pan':
        return 'PAN (Permanent Account Number)';
      case 'gstin':
        return 'GSTIN (GST Identification Number)';
      case 'aadhaar':
        return 'Aadhaar (Unique ID)';
      case 'cin':
        return 'CIN (Corporate Identification Number)';
      case 'tan':
        return 'TAN (Tax Deduction Account Number)';
      case 'ifsc':
        return 'IFSC (Bank Code)';
      case 'upi_id':
        return 'UPI ID (Payment Address)';
      case 'udyam':
        return 'Udyam (MSME Registration)';
      case 'pin_code':
        return 'PIN Code (Postal Code)';
      case 'address':
        return 'Address (Complete Address)';
      case 'partners':
        return 'Partners (Partnership Details)';
      case 'registration':
        return 'Registration (Trust Details)';
      default:
        return identifier.toUpperCase();
    }
  }

  /// Get description for identifier
  String _getIdentifierDescription(String identifier) {
    switch (identifier) {
      case 'pan':
        return '10-character alphanumeric tax identifier';
      case 'gstin':
        return '15-digit GST registration number';
      case 'aadhaar':
        return '12-digit unique identification number';
      case 'cin':
        return '21-character company identification';
      case 'tan':
        return '10-character tax deduction number';
      case 'ifsc':
        return '11-character bank branch code';
      case 'upi_id':
        return 'Virtual payment address';
      case 'udyam':
        return 'MSME registration number';
      case 'pin_code':
        return '6-digit postal index number';
      case 'address':
        return 'Complete postal address';
      case 'partners':
        return 'Partnership firm member details';
      case 'registration':
        return 'Trust/society registration info';
      default:
        return 'Generated identifier';
    }
  }

  /// Get icon for identifier type
  IconData _getIdentifierIcon(String identifier) {
    switch (identifier) {
      case 'pan':
      case 'gstin':
      case 'cin':
      case 'tan':
      case 'udyam':
        return LucideIcons.fileText;
      case 'aadhaar':
        return LucideIcons.user;
      case 'ifsc':
        return LucideIcons.building2;
      case 'upi_id':
        return LucideIcons.creditCard;
      case 'pin_code':
      case 'address':
        return LucideIcons.mapPin;
      case 'partners':
        return LucideIcons.users;
      case 'registration':
        return LucideIcons.stamp;
      default:
        return LucideIcons.hash;
    }
  }
}