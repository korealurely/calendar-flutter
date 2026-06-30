// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_pattern_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$shiftPatternRepositoryHash() =>
    r'644e2fb63ac79e3e3056274fb888027991f1e866';

/// See also [shiftPatternRepository].
@ProviderFor(shiftPatternRepository)
final shiftPatternRepositoryProvider =
    AutoDisposeProvider<ShiftPatternRepository>.internal(
  shiftPatternRepository,
  name: r'shiftPatternRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$shiftPatternRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ShiftPatternRepositoryRef
    = AutoDisposeProviderRef<ShiftPatternRepository>;
String _$shiftPatternViewModelHash() =>
    r'b80cbe06b86558325f6d15e7c3c5107893179169';

/// See also [ShiftPatternViewModel].
@ProviderFor(ShiftPatternViewModel)
final shiftPatternViewModelProvider = AutoDisposeAsyncNotifierProvider<
    ShiftPatternViewModel, List<ShiftPattern>>.internal(
  ShiftPatternViewModel.new,
  name: r'shiftPatternViewModelProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$shiftPatternViewModelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ShiftPatternViewModel = AutoDisposeAsyncNotifier<List<ShiftPattern>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
