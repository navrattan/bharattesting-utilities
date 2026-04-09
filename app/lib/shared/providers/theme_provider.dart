import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'persistence_provider.dart';

part 'theme_provider.g.dart';

@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  @override
  ThemeMode build() {
    return ref.read(persistenceProvider).getThemeMode();
  }

  void toggleTheme() {
    final newMode = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    state = newMode;
    ref.read(persistenceProvider).setThemeMode(newMode);
  }

  void setTheme(ThemeMode mode) {
    state = mode;
    ref.read(persistenceProvider).setThemeMode(mode);
  }
}
