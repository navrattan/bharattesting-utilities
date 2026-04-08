/// Indian Data Faker Screen
///
/// Main UI for generating and exporting Indian identifier data

import 'package:flutter/material.dart';
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

/// Main Data Faker screen
class FakerScreen extends ConsumerWidget {
  const FakerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(fakerNotifierProvider);
    final notifier = ref.read(fakerNotifierProvider.notifier);

    return ToolScaffold(
      title: context.l10n.dataFakerTitle,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header card with disclaimer
            _buildDisclaimerCard(context),

            const SizedBox(height: 24),

            // Generation options
            _buildGenerationSection(context, ref, state, notifier),

            const SizedBox(height: 24),

            // Preview and export section
            if (state.generatedRecords.isNotEmpty) ...[
              _buildResultsSection(context, state, notifier),
            ] else if (state.isGenerating) ...[
              _buildLoadingState(context),
            ] else ...[
              _buildEmptyState(context),
            ],

            const SizedBox(height: 48),
            const BTQAFooter(),
          ],
        ),
      ),
    );
  }

  /// Build disclaimer card about synthetic data
  Widget _buildDisclaimerCard(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              LucideIcons.info,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                'All generated data is completely synthetic and fictional. '
                'No real PII is stored or transmitted. For testing purposes only.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build generation options section
  Widget _buildGenerationSection(
    BuildContext context,
    WidgetRef ref,
    FakerState state,
    FakerNotifier notifier,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Generation Options',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),

        // Template selector
        TemplateSelector(
          selectedTemplate: state.selectedTemplate,
          onTemplateChanged: notifier.setTemplate,
        ),

        const SizedBox(height: 16),

        // Identifier picker (for advanced users)
        if (state.supportsCustomSelection)
          IdentifierPicker(
            selectedIdentifiers: state.selectedIdentifiers,
            onToggle: notifier.toggleIdentifier,
          ),

        const SizedBox(height: 16),

        // Bulk generation controls
        BulkSlider(
          selectedSize: state.bulkSize,
          onSizeChanged: notifier.setBulkSize,
        ),

        const SizedBox(height: 16),

        // Advanced options
        _buildAdvancedOptions(context, ref, state, notifier),

        const SizedBox(height: 24),

        // Generate button
        _buildGenerateButton(context, state, notifier),
      ],
    );
  }

  /// Build advanced options
  Widget _buildAdvancedOptions(
    BuildContext context,
    WidgetRef ref,
    FakerState state,
    FakerNotifier notifier,
  ) {
    return ExpansionTile(
      leading: const Icon(LucideIcons.settings),
      title: const Text('Advanced Settings'),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              // Seed control
              SwitchListTile(
                title: const Text('Use Random Seed'),
                subtitle: const Text('New data on every generation'),
                value: state.useRandomSeed,
                onChanged: notifier.setUseRandomSeed,
              ),

              if (!state.useRandomSeed)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextFormField(
                    initialValue: state.customSeed?.toString(),
                    decoration: const InputDecoration(
                      labelText: 'Custom Seed',
                      hintText: 'Enter any number',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      final seed = int.tryParse(value);
                      notifier.setCustomSeed(seed);
                    },
                  ),
                ),

              // State preference
              ListTile(
                leading: const Icon(LucideIcons.mapPin),
                title: const Text('Preferred State'),
                subtitle: Text(state.preferredState ?? 'Random'),
                trailing: const Icon(LucideIcons.chevronRight),
                onTap: () => _showStateSelector(context, ref, notifier),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build generate button
  Widget _buildGenerateButton(
    BuildContext context,
    FakerState state,
    FakerNotifier notifier,
  ) {
    return ElevatedButton.icon(
      onPressed: state.isGenerating ? null : notifier.generateRecords,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      icon: state.isGenerating
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : const Icon(LucideIcons.play),
      label: Text(
        state.isGenerating ? 'Generating...' : 'Generate Synthetic Data',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  /// Build results and export section
  Widget _buildResultsSection(
    BuildContext context,
    FakerState state,
    FakerNotifier notifier,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 48),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Generated Results',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              '${state.generatedRecords.length} records',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Preview of records
        GeneratedPreview(
          records: state.generatedRecords,
          templateType: state.selectedTemplate,
          onCopySingle: notifier.copySingleToClipboard,
          onCopyAll: notifier.copyToClipboard,
        ),

        const SizedBox(height: 24),

        // Export options
        ExportOptions(
          isExporting: state.isExporting,
          onExport: notifier.exportRecords,
        ),
      ],
    );
  }

  /// Build empty state
  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        children: [
          Icon(
            LucideIcons.database,
            size: 64,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No data generated yet',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Adjust options above and click generate',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Build loading state
  Widget _buildLoadingState(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 24),
          Text('Generating synthetic identity data...'),
          Text(
            'This runs entirely offline on your device',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  /// Show state selector dialog
  Future<void> _showStateSelector(
    BuildContext context,
    WidgetRef ref,
    FakerNotifier notifier,
  ) async {
    final states = ['Random', ...ref.read(availableStatesProvider)];

    final selected = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Select Preferred State'),
        children: states.map((state) {
          return SimpleDialogOption(
            onPressed: () => Navigator.pop(context, state),
            child: Text(state),
          );
        }).toList(),
      ),
    );

    if (selected != null) {
      notifier.setPreferredState(selected == 'Random' ? null : selected);
    }
  }
}
