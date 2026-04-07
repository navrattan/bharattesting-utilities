// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'faker_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$availableStatesHash() => r'11e6b023e72bea232eedf957c98c4ad7836ab9ce';

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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AvailableStatesRef = AutoDisposeProviderRef<List<String>>;
String _$fakerNotifierHash() => r'27f3b1375ce32569dc5f4be585d6484cb6d30441';

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
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
