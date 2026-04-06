/// Indian Data Faker Screen
///
/// Main UI for generating and exporting Indian identifier data

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../shared/widgets/tool_scaffold.dart';
import '../../shared/widgets/btqa_footer.dart';
import '../../l10n/l10n.dart';
import 'faker_provider.dart';
import 'faker_state.dart';
import 'widgets/template_selector.dart';
import 'widgets/identifier_picker.dart';
import 'widgets/bulk_slider.dart';
import 'widgets/generated_preview.dart';
import 'widgets/export_options.dart';

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
            _buildGenerationSection(context, state, notifier),

            const SizedBox(height: 24),

            // Preview and export section
            if (state.generatedRecords.isNotEmpty) ...[
              _buildResultsSection(context, state, notifier),
              const SizedBox(height: 24),
            ],

            // Error display
            if (state.errorMessage != null)
              _buildErrorCard(context, state.errorMessage!, notifier),

            const SizedBox(height: 24),

            // Footer
            const BTQAFooter(),
          ],
        ),
      ),
    );
  }

  /// Build disclaimer card
  Widget _buildDisclaimerCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  LucideIcons.alertTriangle,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Important Disclaimer',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'All generated data is completely synthetic and for testing purposes only. '
              'Never use this data for fraud, identity theft, or any illegal activities. '
              'Generated identifiers follow official formats but are not real.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  /// Build generation options section
  Widget _buildGenerationSection(
    BuildContext context,
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
            availableIdentifiers: state.availableIdentifiers,
            selectedIdentifiers: state.selectedIdentifiers,
            includeAll: state.includeAllIdentifiers,
            onIncludeAllChanged: notifier.setIncludeAllIdentifiers,
            onIdentifierToggled: notifier.toggleIdentifier,
          ),

        const SizedBox(height: 16),

        // Bulk size slider
        BulkSlider(
          selectedSize: state.bulkSize,
          onSizeChanged: notifier.setBulkSize,
        ),

        const SizedBox(height: 16),

        // Advanced options
        _buildAdvancedOptions(context, state, notifier),

        const SizedBox(height: 24),

        // Generate button
        _buildGenerateButton(context, state, notifier),
      ],
    );
  }

  /// Build advanced options
  Widget _buildAdvancedOptions(
    BuildContext context,
    FakerState state,
    FakerNotifier notifier,
  ) {
    return ExpansionTile(
      leading: const Icon(LucideIcons.settings),
      title: const Text('Advanced Options'),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              // Seed options
              SwitchListTile(
                title: const Text('Use Random Seed'),
                subtitle: Text(state.useRandomSeed
                  ? 'Each generation will be unique'
                  : 'Use custom seed for reproducible results'),
                value: state.useRandomSeed,
                onChanged: notifier.setUseRandomSeed,
              ),

              if (!state.useRandomSeed)
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Custom Seed',
                      hintText: 'Enter a number (e.g. 12345)',
                      border: OutlineInputBorder(),
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
                onTap: () => _showStateSelector(context, notifier),
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
    final canGenerate = state.canGenerate;
    final isGenerating = state.isGenerating;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: canGenerate ? notifier.generateRecords : null,
        icon: isGenerating
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(LucideIcons.play),
        label: Text(
          isGenerating
            ? 'Generating ${state.bulkSize.displayName}...'
            : 'Generate ${state.bulkSize.displayName}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }

  /// Build results section
  Widget _buildResultsSection(
    BuildContext context,
    FakerState state,
    FakerNotifier notifier,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Generated Results',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            TextButton.icon(
              onPressed: notifier.clearRecords,
              icon: const Icon(LucideIcons.trash2),
              label: const Text('Clear'),
            ),
          ],
        ),
        const SizedBox(height: 8),

        Text(
          state.generationSummary,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),

        const SizedBox(height: 16),

        // Generated preview
        GeneratedPreview(
          records: state.generatedRecords,
          templateType: state.selectedTemplate,
          onCopySingle: notifier.copySingleRecord,
          onCopyAll: notifier.copyAllRecords,
        ),

        const SizedBox(height: 16),

        // Export options
        ExportOptions(
          selectedFormat: state.selectedExportFormat,
          includeMetadata: state.includeMetadata,
          prettifyOutput: state.prettifyOutput,
          isExporting: state.isExporting,
          exportSummary: state.exportSummary,
          canExport: state.canExport,
          onFormatChanged: notifier.setExportFormat,
          onMetadataChanged: notifier.setIncludeMetadata,
          onPrettifyChanged: notifier.setPrettifyOutput,
          onExport: notifier.exportRecords,
        ),
      ],
    );
  }

  /// Build error card
  Widget _buildErrorCard(
    BuildContext context,
    String errorMessage,
    FakerNotifier notifier,
  ) {
    return Card(
      color: Theme.of(context).colorScheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              LucideIcons.alertCircle,
              color: Theme.of(context).colorScheme.onErrorContainer,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                errorMessage,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
              ),
            ),
            IconButton(
              onPressed: notifier.clearError,
              icon: Icon(
                LucideIcons.x,
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Show state selector dialog
  Future<void> _showStateSelector(
    BuildContext context,
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