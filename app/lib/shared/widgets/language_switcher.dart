import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/locale_provider.dart';
import '../../theme/app_theme.dart';

class LanguageSwitcher extends ConsumerWidget {
  final bool isBranded;

  const LanguageSwitcher({
    this.isBranded = false,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeNotifierProvider);
    final theme = Theme.of(context);

    return PopupMenuButton<String>(
      onSelected: (String code) {
        ref.read(localeNotifierProvider.notifier).setLanguageCode(code);
      },
      icon: Icon(
        Icons.language,
        color: isBranded ? Colors.white : theme.colorScheme.onSurface,
      ),
      tooltip: 'Switch Language',
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'en',
          child: Text('English'),
        ),
        const PopupMenuItem<String>(
          value: 'hi',
          child: Text('हिन्दी (Hindi)'),
        ),
        const PopupMenuItem<String>(
          value: 'bn',
          child: Text('বাংলা (Bengali)'),
        ),
        const PopupMenuItem<String>(
          value: 'mr',
          child: Text('मराठी (Marathi)'),
        ),
        const PopupMenuItem<String>(
          value: 'te',
          child: Text('తెలుగు (Telugu)'),
        ),
        const PopupMenuItem<String>(
          value: 'pa',
          child: Text('ਪੰਜਾਬੀ (Punjabi)'),
        ),
      ],
    );
  }
}
