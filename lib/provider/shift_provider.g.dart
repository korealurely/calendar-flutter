// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$isarInstanceHash() => r'8fb42cedc42d7fe21e93390541004987cc7d5ad6';

/// 1. 异步开辟数据库大门的全局单例（保持不变，全 App 只此一个物理闸门）
///
/// Copied from [isarInstance].
@ProviderFor(isarInstance)
final isarInstanceProvider = AutoDisposeFutureProvider<Isar>.internal(
  isarInstance,
  name: r'isarInstanceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$isarInstanceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef IsarInstanceRef = AutoDisposeFutureProviderRef<Isar>;
String _$shiftRepositoryHash() => r'c189aa0bca2964c37b3f2c57cf457c0827f2b7c8';

/// 2. 把 Repository 做成单例（保持不变，物理搬砖打工人）
///
/// Copied from [shiftRepository].
@ProviderFor(shiftRepository)
final shiftRepositoryProvider = AutoDisposeProvider<ShiftRepository>.internal(
  shiftRepository,
  name: r'shiftRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$shiftRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ShiftRepositoryRef = AutoDisposeProviderRef<ShiftRepository>;
String _$shiftViewModelHash() => r'2457f66f97fa1fd0d83b1b9ec1a2b94587a73281';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$ShiftViewModel
    extends BuildlessAutoDisposeAsyncNotifier<Map<int, CalendarShift>> {
  late final int year;
  late final int month;

  FutureOr<Map<int, CalendarShift>> build(
    int year,
    int month,
  );
}

/// 3. 🔥 终极进化：带天眼监控、带年月参数的智能化月份指挥官
/// 每一个 (year, month) 组合都会在内存里生成一个独立的大脑
///
/// Copied from [ShiftViewModel].
@ProviderFor(ShiftViewModel)
const shiftViewModelProvider = ShiftViewModelFamily();

/// 3. 🔥 终极进化：带天眼监控、带年月参数的智能化月份指挥官
/// 每一个 (year, month) 组合都会在内存里生成一个独立的大脑
///
/// Copied from [ShiftViewModel].
class ShiftViewModelFamily extends Family<AsyncValue<Map<int, CalendarShift>>> {
  /// 3. 🔥 终极进化：带天眼监控、带年月参数的智能化月份指挥官
  /// 每一个 (year, month) 组合都会在内存里生成一个独立的大脑
  ///
  /// Copied from [ShiftViewModel].
  const ShiftViewModelFamily();

  /// 3. 🔥 终极进化：带天眼监控、带年月参数的智能化月份指挥官
  /// 每一个 (year, month) 组合都会在内存里生成一个独立的大脑
  ///
  /// Copied from [ShiftViewModel].
  ShiftViewModelProvider call(
    int year,
    int month,
  ) {
    return ShiftViewModelProvider(
      year,
      month,
    );
  }

  @override
  ShiftViewModelProvider getProviderOverride(
    covariant ShiftViewModelProvider provider,
  ) {
    return call(
      provider.year,
      provider.month,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'shiftViewModelProvider';
}

/// 3. 🔥 终极进化：带天眼监控、带年月参数的智能化月份指挥官
/// 每一个 (year, month) 组合都会在内存里生成一个独立的大脑
///
/// Copied from [ShiftViewModel].
class ShiftViewModelProvider extends AutoDisposeAsyncNotifierProviderImpl<
    ShiftViewModel, Map<int, CalendarShift>> {
  /// 3. 🔥 终极进化：带天眼监控、带年月参数的智能化月份指挥官
  /// 每一个 (year, month) 组合都会在内存里生成一个独立的大脑
  ///
  /// Copied from [ShiftViewModel].
  ShiftViewModelProvider(
    int year,
    int month,
  ) : this._internal(
          () => ShiftViewModel()
            ..year = year
            ..month = month,
          from: shiftViewModelProvider,
          name: r'shiftViewModelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$shiftViewModelHash,
          dependencies: ShiftViewModelFamily._dependencies,
          allTransitiveDependencies:
              ShiftViewModelFamily._allTransitiveDependencies,
          year: year,
          month: month,
        );

  ShiftViewModelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.year,
    required this.month,
  }) : super.internal();

  final int year;
  final int month;

  @override
  FutureOr<Map<int, CalendarShift>> runNotifierBuild(
    covariant ShiftViewModel notifier,
  ) {
    return notifier.build(
      year,
      month,
    );
  }

  @override
  Override overrideWith(ShiftViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: ShiftViewModelProvider._internal(
        () => create()
          ..year = year
          ..month = month,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        year: year,
        month: month,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<ShiftViewModel,
      Map<int, CalendarShift>> createElement() {
    return _ShiftViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ShiftViewModelProvider &&
        other.year == year &&
        other.month == month;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, year.hashCode);
    hash = _SystemHash.combine(hash, month.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ShiftViewModelRef
    on AutoDisposeAsyncNotifierProviderRef<Map<int, CalendarShift>> {
  /// The parameter `year` of this provider.
  int get year;

  /// The parameter `month` of this provider.
  int get month;
}

class _ShiftViewModelProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<ShiftViewModel,
        Map<int, CalendarShift>> with ShiftViewModelRef {
  _ShiftViewModelProviderElement(super.provider);

  @override
  int get year => (origin as ShiftViewModelProvider).year;
  @override
  int get month => (origin as ShiftViewModelProvider).month;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
