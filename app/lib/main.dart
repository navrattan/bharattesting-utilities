import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'shared/providers/persistence_provider.dart';
import 'shared/services/persistence_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final prefs = await SharedPreferences.getInstance();
  final persistenceService = PersistenceService(prefs);

  runApp(
    ProviderScope(
      overrides: [
        persistenceProvider.overrideWithValue(persistenceService),
      ],
      child: const BharatTestingApp(),
    ),
  );
}
