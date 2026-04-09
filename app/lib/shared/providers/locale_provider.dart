import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'locale_provider.g.dart';

@riverpod
class LocaleNotifier extends _$LocaleNotifier {
  @override
  Locale build() {
    // Default locale
    return const Locale('en', 'US');
  }

  void setLocale(Locale locale) {
    state = locale;
  }

  void setLanguageCode(String languageCode) {
    if (languageCode == 'en') {
      state = const Locale('en', 'US');
    } else {
      state = Locale(languageCode, 'IN');
    }
  }
}
