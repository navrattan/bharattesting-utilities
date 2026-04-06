import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:flutter_highlight/themes/github_dark.dart';

class OutputViewer extends StatefulWidget {
  final String content;
  final List<String> errors;
  final List<String> warnings;
  final bool isLoading;

  const OutputViewer({
    super.key,
    required this.content,
    this.errors = const <String>[],
    this.warnings = const <String>[],
    this.isLoading = false,
  });

  @override
  State<OutputViewer> createState() => _OutputViewerState();
}

class _OutputViewerState extends State<OutputViewer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    if (widget.content.isNotEmpty) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(OutputViewer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.content.isNotEmpty && oldWidget.content != widget.content) {
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: theme.dividerColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Header with copy button
          if (widget.content.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(7),
                  topRight: Radius.circular(7),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.code,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'JSON Output',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => _copyToClipboard(context),
                    icon: const Icon(Icons.copy, size: 16),
                    tooltip: 'Copy to clipboard',
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ),

          // Content area
          Expanded(
            child: _buildContent(context, theme),
          ),

          // Warnings panel
          if (widget.warnings.isNotEmpty) _buildWarningsPanel(theme),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, ThemeData theme) {
    if (widget.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Processing...'),
          ],
        ),
      );
    }

    if (widget.errors.isNotEmpty) {
      return _buildErrorDisplay(theme);
    }

    if (widget.content.isEmpty) {
      return _buildPlaceholder(theme);
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Scrollbar(
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.all(12),
          child: HighlightView(
            widget.content,
            language: 'json',
            theme: theme.brightness == Brightness.dark
                ? githubDarkTheme
                : githubTheme,
            textStyle: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.code_outlined,
            size: 48,
            color: theme.colorScheme.onSurface.withOpacity(0.4),
          ),
          const SizedBox(height: 16),
          Text(
            'JSON output will appear here',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Enter some data on the left to get started',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorDisplay(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: theme.colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Unable to convert',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
          const SizedBox(height: 12),
          ...widget.errors.map(
            (error) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  error,
                  style: TextStyle(
                    color: theme.colorScheme.onErrorContainer,
                    fontSize: 13,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Try enabling auto-repair or check the input format',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningsPanel(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_amber_outlined,
                size: 16,
                color: theme.colorScheme.onSecondaryContainer,
              ),
              const SizedBox(width: 8),
              Text(
                'Warnings',
                style: TextStyle(
                  color: theme.colorScheme.onSecondaryContainer,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...widget.warnings.map(
            (warning) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                '• $warning',
                style: TextStyle(
                  color: theme.colorScheme.onSecondaryContainer,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _copyToClipboard(BuildContext context) async {
    if (widget.content.isNotEmpty) {
      await Clipboard.setData(ClipboardData(text: widget.content));

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Copied to clipboard'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }
}