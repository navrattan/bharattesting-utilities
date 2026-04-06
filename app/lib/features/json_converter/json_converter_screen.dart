import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/widgets/tool_scaffold.dart';
import '../../l10n/l10n.dart';
import 'providers/json_converter_provider.dart';
import 'widgets/input_editor.dart';
import 'widgets/output_viewer.dart';
import 'widgets/format_info_panel.dart';
import 'widgets/action_buttons.dart';
import 'widgets/examples_panel.dart';

class JsonConverterScreen extends ConsumerStatefulWidget {
  const JsonConverterScreen({super.key});

  @override
  ConsumerState<JsonConverterScreen> createState() => _JsonConverterScreenState();
}

class _JsonConverterScreenState extends ConsumerState<JsonConverterScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(jsonConverterProvider);
    final notifier = ref.read(jsonConverterProvider.notifier);

    return ToolScaffold(
      key: _scaffoldKey,
      title: context.l10n.jsonConverterTitle,
      subtitle: context.l10n.jsonConverterSubtitle,
      actions: [
        IconButton(
          icon: const Icon(Icons.help_outline),
          onPressed: () => _showHelpDialog(context),
          tooltip: 'Help',
        ),
      ],
      body: Column(
        children: [
          // Format info and action buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: FormatInfoPanel(
                    detectedFormat: state.formatDisplayName,
                    confidence: state.confidenceDisplayText,
                    appliedRepairs: state.appliedRepairs,
                    hasWarnings: state.hasWarnings,
                    warningCount: state.warnings.length,
                  ),
                ),
                const SizedBox(width: 16),
                ActionButtons(
                  canCopy: state.hasOutput,
                  canClear: state.hasInput,
                  autoRepairEnabled: state.autoRepairEnabled,
                  prettifyEnabled: state.prettifyOutput,
                  onCopy: notifier.copyToClipboard,
                  onPaste: notifier.pasteFromClipboard,
                  onClear: notifier.clearInput,
                  onToggleAutoRepair: notifier.toggleAutoRepair,
                  onTogglePrettify: notifier.togglePrettify,
                  onProcess: notifier.processInput,
                ),
              ],
            ),
          ),

          // Main content area
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 900;

                if (isWide) {
                  // Side-by-side layout for desktop
                  return Row(
                    children: [
                      Expanded(
                        child: _buildInputSection(),
                      ),
                      const VerticalDivider(width: 1),
                      Expanded(
                        child: _buildOutputSection(),
                      ),
                    ],
                  );
                } else {
                  // Tabbed layout for mobile/tablet
                  return Column(
                    children: [
                      TabBar(
                        controller: _tabController,
                        tabs: [
                          Tab(
                            icon: const Icon(Icons.edit_outlined),
                            text: 'Input',
                          ),
                          Tab(
                            icon: const Icon(Icons.code_outlined),
                            text: 'Output',
                          ),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            _buildInputSection(),
                            _buildOutputSection(),
                          ],
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
      drawer: _buildExamplesDrawer(),
    );
  }

  Widget _buildInputSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.edit_outlined, size: 20),
              const SizedBox(width: 8),
              Text(
                'Input',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                icon: const Icon(Icons.library_books_outlined, size: 16),
                label: const Text('Examples'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: InputEditor(
              value: ref.watch(jsonConverterProvider.select((s) => s.inputText)),
              onChanged: ref.read(jsonConverterProvider.notifier).updateInputText,
              hasError: ref.watch(jsonConverterProvider.select((s) => s.hasErrors)),
              errorLine: ref.watch(jsonConverterProvider.select((s) => s.errorLineNumber)),
              errorColumn: ref.watch(jsonConverterProvider.select((s) => s.errorColumnNumber)),
              errorMessage: ref.watch(jsonConverterProvider.select((s) => s.errorMessage)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOutputSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.code_outlined, size: 20),
              const SizedBox(width: 8),
              Text(
                'Output (JSON)',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              if (ref.watch(jsonConverterProvider.select((s) => s.isProcessing)))
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: OutputViewer(
              content: ref.watch(jsonConverterProvider.select((s) => s.outputText)),
              errors: ref.watch(jsonConverterProvider.select((s) => s.errors)),
              warnings: ref.watch(jsonConverterProvider.select((s) => s.warnings)),
              isLoading: ref.watch(jsonConverterProvider.select((s) => s.isProcessing)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExamplesDrawer() {
    return Drawer(
      child: ExamplesPanel(
        onExampleSelected: (example) {
          ref.read(jsonConverterProvider.notifier).setInputFromExample(example);
          Navigator.of(context).pop(); // Close drawer
        },
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('String to JSON Converter'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Features:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• Auto-detects input format (JSON, CSV, YAML, XML, URL-encoded, INI)'),
              Text('• Intelligent JSON auto-repair with 6 repair rules'),
              Text('• Error highlighting with line/column position'),
              Text('• Format conversion with confidence scoring'),
              Text('• Copy/paste and download functionality'),
              Text('• Real-time processing with debouncing'),
              SizedBox(height: 16),
              Text(
                'Auto-Repair Rules:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• Remove trailing commas'),
              Text('• Convert single quotes to double quotes'),
              Text('• Add quotes around unquoted keys'),
              Text('• Remove JavaScript-style comments'),
              Text('• Convert Python literals (True/False/None)'),
              Text('• Remove trailing text after valid JSON'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}