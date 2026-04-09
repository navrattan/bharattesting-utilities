import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../l10n/l10n.dart';
import '../../shared/widgets/tool_scaffold.dart';
import '../../theme/app_theme.dart';
import 'faker_provider.dart';
import 'faker_state.dart';

class FakerScreen extends ConsumerWidget {
  const FakerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(fakerNotifierProvider);
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingXl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Area (Replacing ToolScaffold header part)
          Text(
            context.l10n.dataFakerTitle,
            style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const Text('Generate synthetic but valid Indian identity and business data'),
          const SizedBox(height: 32),

          // STEP 1: SELECT DATA TYPE
          _buildSectionHeader(context, "1", "Choose the types of data you want"),
          const SizedBox(height: 16),
          _DataTypeGrid(state: state),
          
          const SizedBox(height: 32),
          
          // STEP 2: SELECT FORMAT
          _buildSectionHeader(context, "2", "Choose a data format"),
          const SizedBox(height: 16),
          _FormatGrid(state: state),
          
          const SizedBox(height: 32),

          // STEP 3: RECORD COUNT
          _buildSectionHeader(context, "3", "How many records?"),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Wrap(
                  spacing: 8,
                  children: [1, 10, 100, 1000].map((count) {
                    final isSelected = state.recordCount == count;
                    return ChoiceChip(
                      label: Text(count.toString()),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          ref.read(fakerNotifierProvider.notifier).updateRecordCount(count);
                        }
                      },
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 1,
                child: TextFormField(
                  key: ValueKey('record_count_${state.recordCount}'),
                  initialValue: state.recordCount.toString(),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Custom',
                    hintText: '1-10000',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  onChanged: (val) {
                    final count = int.tryParse(val);
                    if (count != null) {
                      ref.read(fakerNotifierProvider.notifier).updateRecordCount(count.clamp(1, 10000));
                    }
                  },
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 48),
          
          // ACTIONS & PREVIEW
          Center(
            child: Column(
              children: [
                SizedBox(
                  width: 300,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: state.isGenerating ? null : () => ref.read(fakerNotifierProvider.notifier).generateRecords(),
                    icon: state.isGenerating 
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(LucideIcons.zap),
                    label: Text(
                      state.isGenerating ? 'GENERATING...' : 'GENERATE DATA',
                      style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),
                if (state.generatedRecords.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  TextButton.icon(
                    onPressed: () => _showPreview(context, state),
                    icon: const Icon(LucideIcons.eye),
                    label: const Text('View Preview'),
                  ),
                ]
              ],
            ),
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String number, String title) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: theme.colorScheme.primary.withOpacity(0.5)),
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  void _showPreview(BuildContext context, FakerState state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Data Preview', style: Theme.of(context).textTheme.titleLarge),
                  IconButton(
                    icon: const Icon(LucideIcons.copy),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: state.generatedRecords.toString()));
                      ScaffoldMessenger.of(context).showSnackBar(ApiResponseSnackBar(message: 'Copied to clipboard'));
                    },
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: state.generatedRecords.length,
                itemBuilder: (context, index) => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: SelectableText(state.generatedRecords[index].toString()),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DataTypeGrid extends ConsumerWidget {
  final FakerState state;
  const _DataTypeGrid({required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(fakerNotifierProvider.notifier);
    final screenWidth = MediaQuery.of(context).size.width;
    // Ultra compact: 8 on desktop, 6 on tablet, 4 on mobile
    final crossAxisCount = screenWidth > 1200 ? 8 : (screenWidth > 900 ? 6 : (screenWidth > 600 ? 5 : 4));
    
    final types = [
      ('Name', LucideIcons.user, 'name'),
      ('Phone', LucideIcons.phone, 'phone'),
      ('Email', LucideIcons.mail, 'email'),
      ('Address', LucideIcons.mapPin, 'address'),
      ('PAN', LucideIcons.creditCard, 'pan'),
      ('Aadhaar', LucideIcons.fingerprint, 'aadhaar'),
      ('GSTIN', LucideIcons.briefcase, 'gstin'),
      ('UPI ID', LucideIcons.wallet, 'upi_id'),
      ('PIN Code', LucideIcons.map, 'pin_code'),
      ('IFSC', LucideIcons.banknote, 'ifsc'),
      ('Vehicle', LucideIcons.car, 'vehicle'),
      ('Company', LucideIcons.building, 'company'),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
        childAspectRatio: 1.0, // Square tiles for maximum density
      ),
      itemCount: types.length,
      itemBuilder: (context, index) {
        final (label, icon, key) = types[index];
        final isSelected = state.selectedIdentifiers.contains(key);
        
        return _SelectionTile(
          label: label,
          icon: icon,
          isSelected: isSelected,
          onTap: () => notifier.toggleIdentifier(key),
        );
      },
    );
  }
}

class _FormatGrid extends ConsumerWidget {
  final FakerState state;
  const _FormatGrid({required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(fakerNotifierProvider.notifier);
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 1200 ? 8 : (screenWidth > 900 ? 6 : (screenWidth > 600 ? 5 : 4));
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
        childAspectRatio: 1.0,
      ),
      itemCount: ExportFormat.values.length,
      itemBuilder: (context, index) {
        final format = ExportFormat.values[index];
        final isSelected = state.selectedExportFormat == format;
        
        return _SelectionTile(
          label: format.displayName,
          icon: _getFormatIcon(format),
          isSelected: isSelected,
          onTap: () => notifier.updateExportFormat(format),
          isFormat: true,
        );
      },
    );
  }

  IconData _getFormatIcon(ExportFormat format) {
    switch (format) {
      case ExportFormat.json: return LucideIcons.braces;
      case ExportFormat.csv: return LucideIcons.fileSpreadsheet;
      case ExportFormat.sql: return LucideIcons.database;
      case ExportFormat.xml: return LucideIcons.code;
      case ExportFormat.html: return LucideIcons.layout;
      default: return LucideIcons.fileCode;
    }
  }
}

class _SelectionTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isFormat;

  const _SelectionTile({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    this.isFormat = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isFormat ? Colors.indigo : theme.colorScheme.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : theme.colorScheme.outline.withOpacity(0.2),
            width: 1.5,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ] : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : color,
              size: 20,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : theme.colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class ApiResponseSnackBar extends SnackBar {
  final String message;
  ApiResponseSnackBar({super.key, required this.message}) : super(
    content: Text(message),
    behavior: SnackBarBehavior.floating,
    width: 200,
  );
}
