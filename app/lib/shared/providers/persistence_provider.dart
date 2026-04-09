import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/persistence_service.dart';

part 'persistence_provider.g.dart';

@Riverpod(keepAlive: true)
PersistenceService persistence(PersistenceProviderRef ref) {
  throw UnimplementedError('persistenceProvider must be overridden in ProviderScope');
}
