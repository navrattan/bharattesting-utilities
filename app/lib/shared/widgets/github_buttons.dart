/// GitHub action buttons for app bar
library github_buttons;

import 'package:flutter/material.dart';

/// GitHub buttons for Star, Report Bug, and Contribute
///
/// Shows in app bar with:
/// - Star button (with star icon)
/// - Report Bug button
/// - Contribute button
/// - Responsive layout (compact on mobile)
class GitHubButtons extends StatelessWidget {
  const GitHubButtons({
    this.compact = false,
    super.key,
  });

  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return PopupMenuButton<String>(
        icon: const Icon(Icons.more_vert),
        tooltip: 'More options',
        onSelected: _handleSelection,
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'star',
            child: ListTile(
              leading: Icon(Icons.star_outline),
              title: Text('Star on GitHub'),
              contentPadding: EdgeInsets.zero,
            ),
          ),
          const PopupMenuItem(
            value: 'bug',
            child: ListTile(
              leading: Icon(Icons.bug_report_outlined),
              title: Text('Report Bug'),
              contentPadding: EdgeInsets.zero,
            ),
          ),
          const PopupMenuItem(
            value: 'contribute',
            child: ListTile(
              leading: Icon(Icons.code_outlined),
              title: Text('Contribute'),
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton.icon(
          onPressed: () => _handleSelection('star'),
          icon: const Icon(Icons.star_outline, size: 20),
          label: const Text('Star'),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
        const SizedBox(width: 8),
        TextButton(
          onPressed: () => _handleSelection('bug'),
          child: const Text('Report Bug'),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
        const SizedBox(width: 8),
        TextButton(
          onPressed: () => _handleSelection('contribute'),
          child: const Text('Contribute'),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  void _handleSelection(String value) {
    switch (value) {
      case 'star':
        // TODO: Launch GitHub star URL
        debugPrint('Navigate to GitHub star');
        break;
      case 'bug':
        // TODO: Launch GitHub issues URL
        debugPrint('Navigate to GitHub bug report');
        break;
      case 'contribute':
        // TODO: Launch GitHub contribute URL
        debugPrint('Navigate to GitHub contribute');
        break;
    }
  }
}