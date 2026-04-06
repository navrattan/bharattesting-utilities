// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'faker_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$availableStatesHash() => r'4d4e3c2c53751234567890abcdef1234567890ab';

/// Provider for available Indian states
///
/// Copied from [availableStates].
@ProviderFor(availableStates)
final availableStatesProvider = AutoDisposeProvider<List<String>>.internal(
  availableStates,
  name: r'availableStatesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$availableStatesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AvailableStatesRef = AutoDisposeProviderRef<List<String>>;
String _$fakerNotifierHash() => r'9a8b7c6d54321098765432109876543210987654';

/// Provider for Indian Data Faker
///
/// Copied from [FakerNotifier].
@ProviderFor(FakerNotifier)
final fakerNotifierProvider =
    AutoDisposeNotifierProvider<FakerNotifier, FakerState>.internal(
  FakerNotifier.new,
  name: r'fakerNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$fakerNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$FakerNotifier = AutoDisposeNotifier<FakerState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member