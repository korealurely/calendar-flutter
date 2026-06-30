// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_config_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$shiftConfigRepositoryHash() =>
    r'ff1dfe7eafa3420abfc48fa9845f0ffec07cfc97';

/// See also [shiftConfigRepository].
@ProviderFor(shiftConfigRepository)
final shiftConfigRepositoryProvider =
    AutoDisposeProvider<ShiftConfigRepository>.internal(
  shiftConfigRepository,
  name: r'shiftConfigRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$shiftConfigRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ShiftConfigRepositoryRef
    = AutoDisposeProviderRef<ShiftConfigRepository>;
String _$shiftConfigViewModelHash() =>
    r'33c7aef09f4c4d54d4c5b5c5ac59c58ab6e10281';

/// See also [ShiftConfigViewModel].
@ProviderFor(ShiftConfigViewModel)
final shiftConfigViewModelProvider = AutoDisposeAsyncNotifierProvider<
    ShiftConfigViewModel, List<ShiftConfig>>.internal(
  ShiftConfigViewModel.new,
  name: r'shiftConfigViewModelProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$shiftConfigViewModelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ShiftConfigViewModel = AutoDisposeAsyncNotifier<List<ShiftConfig>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
