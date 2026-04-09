import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../l10n/l10n.dart';
import '../../shared/widgets/btqa_footer.dart';
import '../../shared/widgets/tool_scaffold.dart';
import 'faker_provider.dart';
import 'faker_state.dart';
import 'widgets/bulk_slider.dart';
import 'widgets/export_options.dart';
import 'widgets/generated_preview.dart';
import 'widgets/identifier_picker.dart';
import 'widgets/template_selector.dart';

class FakerScreen extends ConsumerStatefulWidget {
  const FakerScreen({super.key});

  @override
  ConsumerState<FakerScreen> createState() => _FakerScreenState();
}

class _FakerScreenState extends ConsumerState<FakerScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(fakerNotifierProvider);
    final notifier = ref.read(fakerNotifierProvider.notifier);

    return ToolScaffold(
      title: context.l10n.dataFakerTitle,
      subtitle: context.l10n.dataFakerSubtitle ?? 'Generate valid Indian test data',
      actions: [
        IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: state.generatedRecords.isEmpty ? null : () => notifier.clearRecords(),
          tooltip: 'Clear Records',
        ),
      ],
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTemplateSection(state, notifier),
                  const SizedBox(height: 24),
                  _buildOptionsSection(state, notifier),
                  const SizedBox(height: 24),
                  _buildActionSection(state, notifier),
                  const SizedBox(height: 24),
                  if (state.generatedRecords.isNotEmpty)
                    GeneratedPreview(
                      records: state.generatedRecords,
                      templateType: state.selectedTemplate,
                      onCopySingle: (record) => Clipboard.setData(ClipboardData(text: record.toString())),
                      onCopyAll: () => Clipboard.setData(ClipboardData(text: state.generatedRecords.toString())),
                    ),
                  const SizedBox(height: 32),
                  const BTQAFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateSection(FakerState state, FakerNotifier notifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '1. Select Template',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        TemplateSelector(
          selectedTemplate: state.selectedTemplate,
          onTemplateChanged: (template) => notifier.setTemplate(template),
        ),
      ],
    );
  }

  Widget _buildOptionsSection(FakerState state, FakerNotifier notifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '2. Configuration',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                IdentifierPicker(
                  selectedIdentifiers: state.selectedIdentifiers,
                  onToggle: (id) => notifier.toggleIdentifier(id),
                ),
                const Divider(height: 32),
                BulkSlider(
                  selectedSize: state.bulkSize,
                  onSizeChanged: (val) => notifier.setBulkSize(val),
                ),
                const SizedBox(height: 16),
                _buildSeedInput(state, notifier),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSeedInput(FakerState state, FakerNotifier notifier) {
    return Row(
      children: [
        Expanded(
          child: CheckboxListTile(
            title: const Text('Use Random Seed'),
            value: state.useRandomSeed,
            onChanged: (val) => notifier.setUseRandomSeed(val ?? true),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
          ),
        ),
        if (!state.useRandomSeed)
          SizedBox(
            width: 120,
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Seed',
                isDense: true,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (val) => notifier.setCustomSeed(int.tryParse(val)),
            ),
          ),
      ],
    );
  }

  Widget _buildActionSection(FakerState state, FakerNotifier notifier) {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: state.isGenerating ? null : () => notifier.generateRecords(),
          icon: state.isGenerating
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(LucideIcons.sparkles),
          label: Text(
            state.isGenerating ? 'Generating...' : 'Generate Synthetic Data',
          ),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          ),
        ),
        if (state.generatedRecords.isNotEmpty) ...[
          const SizedBox(height: 16),
          ExportOptions(
            isExporting: state.isExporting,
            onExport: (format) => notifier.exportRecords(format),
          ),
        ],
      ],
    );
  }
}
