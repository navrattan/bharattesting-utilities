import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/l10n.dart';
import '../../theme/app_theme.dart';
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

    return Column(
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
                // Tabbed layout for mobile
                return Column(
                  children: [
                    TabBar(
                      controller: _tabController,
                      tabs: const [
                        Tab(text: 'Input', icon: Icon(Icons.edit_note)),
                        Tab(text: 'Output', icon: Icon(Icons.code_off)),
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
    );
  }

  Widget _buildInputSection() {
    final state = ref.watch(jsonConverterProvider);
    final notifier = ref.read(jsonConverterProvider.notifier);

    return InputEditor(
      value: state.inputText,
      onChanged: notifier.updateInput,
      errorLine: state.errorLineNumber,
      errorMessage: state.errorMessage,
    );
  }

  Widget _buildOutputSection() {
    final state = ref.watch(jsonConverterProvider);

    return OutputViewer(
      content: state.outputText,
      isLoading: state.isProcessing,
      errors: state.errors,
      warnings: state.warnings,
    );
  }
}
