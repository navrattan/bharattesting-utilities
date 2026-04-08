// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'faker_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$availableStatesHash() => r'ce0f0f604abc431a1759200cbbe28d85cbe07ba7';

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
String _$fakerNotifierHash() => r'96b705bed24795d79314610c6563af70079e3c31';

/// See also [FakerNotifier].
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
