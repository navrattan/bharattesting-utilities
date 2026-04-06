import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:flutter_highlight/themes/github_dark.dart';

class InputEditor extends StatefulWidget {
  final String value;
  final ValueChanged<String> onChanged;
  final bool hasError;
  final int? errorLine;
  final int? errorColumn;
  final String? errorMessage;

  const InputEditor({
    super.key,
    required this.value,
    required this.onChanged,
    this.hasError = false,
    this.errorLine,
    this.errorColumn,
    this.errorMessage,
  });

  @override
  State<InputEditor> createState() => _InputEditorState();
}

class _InputEditorState extends State<InputEditor> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  bool _showHighlight = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
    _focusNode = FocusNode();

    _controller.addListener(() {
      if (_controller.text != widget.value) {
        widget.onChanged(_controller.text);
      }
    });

    _focusNode.addListener(() {
      setState(() {
        _showHighlight = !_focusNode.hasFocus && widget.value.isNotEmpty;
      });
    });
  }

  @override
  void didUpdateWidget(InputEditor oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.value != oldWidget.value && widget.value != _controller.text) {
      final selection = _controller.selection;
      _controller.text = widget.value;

      // Preserve cursor position if possible
      if (selection.isValid && selection.end <= widget.value.length) {
        _controller.selection = selection;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: widget.hasError
                    ? theme.colorScheme.error
                    : theme.dividerColor,
                width: widget.hasError ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Stack(
              children: [
                // Syntax highlighted background (when not focused)
                if (_showHighlight && widget.value.isNotEmpty)
                  Positioned.fill(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(12),
                      child: HighlightView(
                        widget.value,
                        language: _detectLanguage(widget.value),
                        theme: isDark ? githubDarkTheme : githubTheme,
                        textStyle: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 14,
                          height: 1.4,
                          color: Colors.transparent, // Hide text, keep highlighting
                        ),
                      ),
                    ),
                  ),

                // Text input field
                Positioned.fill(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    maxLines: null,
                    expands: true,
                    decoration: InputDecoration(
                      hintText: _getHintText(),
                      hintStyle: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 14,
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(12),
                    ),
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 14,
                      height: 1.4,
                      color: _showHighlight ? Colors.transparent : null,
                    ),
                    textAlignVertical: TextAlignVertical.top,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Error message
        if (widget.hasError && widget.errorMessage != null)
          Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 16,
                  color: theme.colorScheme.onErrorContainer,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.errorMessage!,
                        style: TextStyle(
                          color: theme.colorScheme.onErrorContainer,
                          fontSize: 13,
                        ),
                      ),
                      if (widget.errorLine != null)
                        Text(
                          'Line ${widget.errorLine}, Column ${widget.errorColumn ?? 1}',
                          style: TextStyle(
                            color: theme.colorScheme.onErrorContainer.withOpacity(0.8),
                            fontSize: 12,
                            fontFamily: 'monospace',
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  String _getHintText() {
    return '''Paste or type your data here...

Supports:
• JSON (with auto-repair)
• CSV with headers
• YAML documents
• XML markup
• URL-encoded data
• INI configuration files

Example broken JSON:
{
  name: "test",    // Comment
  values: [1, 2, 3,],
  active: True
}''';
  }

  String _detectLanguage(String text) {
    final trimmed = text.trim();

    if (trimmed.startsWith('{') || trimmed.startsWith('[')) {
      return 'json';
    }

    if (trimmed.startsWith('<?xml') || trimmed.startsWith('<')) {
      return 'xml';
    }

    if (trimmed.contains(',') && trimmed.contains('\n')) {
      // Likely CSV
      return 'csv';
    }

    if (trimmed.contains('---') || RegExp(r'^\w+:\s*\w+').hasMatch(trimmed)) {
      return 'yaml';
    }

    if (trimmed.contains('=') && trimmed.contains('&')) {
      return 'properties'; // URL-encoded
    }

    if (RegExp(r'^\[.+\]').hasMatch(trimmed)) {
      return 'ini';
    }

    return 'json'; // Default fallback
  }
}