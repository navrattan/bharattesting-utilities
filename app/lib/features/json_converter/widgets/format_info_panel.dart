import 'package:flutter/material.dart';
import 'package:bharattesting_core/core.dart' as core;

class FormatInfoPanel extends StatelessWidget {
  final String detectedFormat;
  final String confidence;
  final List<core.RepairRule> appliedRepairs;
  final bool hasWarnings;
  final int warningCount;

  const FormatInfoPanel({
    super.key,
    required this.detectedFormat,
    required this.confidence,
    required this.appliedRepairs,
    this.hasWarnings = false,
    this.warningCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: _buildInfoRow(context, 'Detected Format', detectedFormat)),
            if (hasWarnings)
              Container(
                margin: const EdgeInsets.only(left: 8),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.orange),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.warning_amber_rounded, size: 12, color: Colors.orange),
                    const SizedBox(width: 4),
                    Text(
                      '$warningCount warnings',
                      style: const TextStyle(fontSize: 10, color: Colors.orange, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
          ],
        ),
        _buildInfoRow(context, 'Confidence', confidence),
        if (appliedRepairs.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            'Applied Repairs',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          ...appliedRepairs.map((repair) => _buildRepairItem(context, repair)),
        ],
      ],
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildRepairItem(BuildContext context, core.RepairRule repair) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            _getRepairIcon(repair),
            size: 16,
            color: Colors.green,
          ),
          const SizedBox(width: 8),
          Text(
            _getRepairName(repair),
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  String _getRepairName(core.RepairRule repair) {
    switch (repair) {
      case core.RepairRule.trailingCommas:
        return 'Removed trailing commas';
      case core.RepairRule.singleQuotes:
        return 'Converted single quotes';
      case core.RepairRule.unquotedKeys:
        return 'Quoted unquoted keys';
      case core.RepairRule.jsComments:
        return 'Removed JavaScript comments';
      case core.RepairRule.pythonLiterals:
        return 'Fixed Python literals';
      case core.RepairRule.trailingText:
        return 'Removed trailing text';
    }
  }

  IconData _getRepairIcon(core.RepairRule repair) {
    switch (repair) {
      case core.RepairRule.trailingCommas:
        return Icons.format_list_bulleted;
      case core.RepairRule.singleQuotes:
        return Icons.swap_horiz;
      case core.RepairRule.unquotedKeys:
        return Icons.vpn_key;
      case core.RepairRule.jsComments:
        return Icons.comment_bank;
      case core.RepairRule.pythonLiterals:
        return Icons.code;
      case core.RepairRule.trailingText:
        return Icons.text_snippet;
    }
  }
}
