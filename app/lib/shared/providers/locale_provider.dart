import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'persistence_provider.dart';

part 'locale_provider.g.dart';

@riverpod
class LocaleNotifier extends _$LocaleNotifier {
  @override
  Locale build() {
    final code = ref.read(persistenceProvider).getLocaleCode();
    if (code == 'en') return const Locale('en', 'US');
    return Locale(code, 'IN');
  }

  void setLocale(Locale locale) {
    state = locale;
    ref.read(persistenceProvider).setLocaleCode(locale.languageCode);
  }

  void setLanguageCode(String languageCode) {
    if (languageCode == 'en') {
      state = const Locale('en', 'US');
    } else {
      state = Locale(languageCode, 'IN');
    }
    ref.read(persistenceProvider).setLocaleCode(languageCode);
  }
}
