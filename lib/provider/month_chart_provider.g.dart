// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'month_chart_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$monthlyShiftChartHash() => r'1e9ea427a0e8073f47a3a70fb017b11a4005597f';

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

/// See also [monthlyShiftChart].
@ProviderFor(monthlyShiftChart)
const monthlyShiftChartProvider = MonthlyShiftChartFamily();

/// See also [monthlyShiftChart].
class MonthlyShiftChartFamily extends Family<AsyncValue<List<ShiftStatItem>>> {
  /// See also [monthlyShiftChart].
  const MonthlyShiftChartFamily();

  /// See also [monthlyShiftChart].
  MonthlyShiftChartProvider call(
    DateTime currentDate,
  ) {
    return MonthlyShiftChartProvider(
      currentDate,
    );
  }

  @override
  MonthlyShiftChartProvider getProviderOverride(
    covariant MonthlyShiftChartProvider provider,
  ) {
    return call(
      provider.currentDate,
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
  String? get name => r'monthlyShiftChartProvider';
}

/// See also [monthlyShiftChart].
class MonthlyShiftChartProvider
    extends AutoDisposeFutureProvider<List<ShiftStatItem>> {
  /// See also [monthlyShiftChart].
  MonthlyShiftChartProvider(
    DateTime currentDate,
  ) : this._internal(
          (ref) => monthlyShiftChart(
            ref as MonthlyShiftChartRef,
            currentDate,
          ),
          from: monthlyShiftChartProvider,
          name: r'monthlyShiftChartProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$monthlyShiftChartHash,
          dependencies: MonthlyShiftChartFamily._dependencies,
          allTransitiveDependencies:
              MonthlyShiftChartFamily._allTransitiveDependencies,
          currentDate: currentDate,
        );

  MonthlyShiftChartProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.currentDate,
  }) : super.internal();

  final DateTime currentDate;

  @override
  Override overrideWith(
    FutureOr<List<ShiftStatItem>> Function(MonthlyShiftChartRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MonthlyShiftChartProvider._internal(
        (ref) => create(ref as MonthlyShiftChartRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        currentDate: currentDate,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<ShiftStatItem>> createElement() {
    return _MonthlyShiftChartProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MonthlyShiftChartProvider &&
        other.currentDate == currentDate;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, currentDate.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin MonthlyShiftChartRef
    on AutoDisposeFutureProviderRef<List<ShiftStatItem>> {
  /// The parameter `currentDate` of this provider.
  DateTime get currentDate;
}

class _MonthlyShiftChartProviderElement
    extends AutoDisposeFutureProviderElement<List<ShiftStatItem>>
    with MonthlyShiftChartRef {
  _MonthlyShiftChartProviderElement(super.provider);

  @override
  DateTime get currentDate => (origin as MonthlyShiftChartProvider).currentDate;
}

String _$monthlyWeightChartHash() =>
    r'bc244a9fca4010b33f4feeb55feb23a3992b143b';

/// See also [monthlyWeightChart].
@ProviderFor(monthlyWeightChart)
const monthlyWeightChartProvider = MonthlyWeightChartFamily();

/// See also [monthlyWeightChart].
class MonthlyWeightChartFamily
    extends Family<AsyncValue<List<WeightStatItem>>> {
  /// See also [monthlyWeightChart].
  const MonthlyWeightChartFamily();

  /// See also [monthlyWeightChart].
  MonthlyWeightChartProvider call(
    DateTime currentMonth,
  ) {
    return MonthlyWeightChartProvider(
      currentMonth,
    );
  }

  @override
  MonthlyWeightChartProvider getProviderOverride(
    covariant MonthlyWeightChartProvider provider,
  ) {
    return call(
      provider.currentMonth,
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
  String? get name => r'monthlyWeightChartProvider';
}

/// See also [monthlyWeightChart].
class MonthlyWeightChartProvider
    extends AutoDisposeFutureProvider<List<WeightStatItem>> {
  /// See also [monthlyWeightChart].
  MonthlyWeightChartProvider(
    DateTime currentMonth,
  ) : this._internal(
          (ref) => monthlyWeightChart(
            ref as MonthlyWeightChartRef,
            currentMonth,
          ),
          from: monthlyWeightChartProvider,
          name: r'monthlyWeightChartProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$monthlyWeightChartHash,
          dependencies: MonthlyWeightChartFamily._dependencies,
          allTransitiveDependencies:
              MonthlyWeightChartFamily._allTransitiveDependencies,
          currentMonth: currentMonth,
        );

  MonthlyWeightChartProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.currentMonth,
  }) : super.internal();

  final DateTime currentMonth;

  @override
  Override overrideWith(
    FutureOr<List<WeightStatItem>> Function(MonthlyWeightChartRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MonthlyWeightChartProvider._internal(
        (ref) => create(ref as MonthlyWeightChartRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        currentMonth: currentMonth,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<WeightStatItem>> createElement() {
    return _MonthlyWeightChartProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MonthlyWeightChartProvider &&
        other.currentMonth == currentMonth;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, currentMonth.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin MonthlyWeightChartRef
    on AutoDisposeFutureProviderRef<List<WeightStatItem>> {
  /// The parameter `currentMonth` of this provider.
  DateTime get currentMonth;
}

class _MonthlyWeightChartProviderElement
    extends AutoDisposeFutureProviderElement<List<WeightStatItem>>
    with MonthlyWeightChartRef {
  _MonthlyWeightChartProviderElement(super.provider);

  @override
  DateTime get currentMonth =>
      (origin as MonthlyWeightChartProvider).currentMonth;
}

String _$monthlyWorkTimeStatsHash() =>
    r'f10a53f1899ff9ffac6dce6531ed19f2921fc49d';

/// See also [monthlyWorkTimeStats].
@ProviderFor(monthlyWorkTimeStats)
const monthlyWorkTimeStatsProvider = MonthlyWorkTimeStatsFamily();

/// See also [monthlyWorkTimeStats].
class MonthlyWorkTimeStatsFamily
    extends Family<AsyncValue<List<WorkTimeStat>>> {
  /// See also [monthlyWorkTimeStats].
  const MonthlyWorkTimeStatsFamily();

  /// See also [monthlyWorkTimeStats].
  MonthlyWorkTimeStatsProvider call(
    DateTime currentMonth,
  ) {
    return MonthlyWorkTimeStatsProvider(
      currentMonth,
    );
  }

  @override
  MonthlyWorkTimeStatsProvider getProviderOverride(
    covariant MonthlyWorkTimeStatsProvider provider,
  ) {
    return call(
      provider.currentMonth,
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
  String? get name => r'monthlyWorkTimeStatsProvider';
}

/// See also [monthlyWorkTimeStats].
class MonthlyWorkTimeStatsProvider
    extends AutoDisposeFutureProvider<List<WorkTimeStat>> {
  /// See also [monthlyWorkTimeStats].
  MonthlyWorkTimeStatsProvider(
    DateTime currentMonth,
  ) : this._internal(
          (ref) => monthlyWorkTimeStats(
            ref as MonthlyWorkTimeStatsRef,
            currentMonth,
          ),
          from: monthlyWorkTimeStatsProvider,
          name: r'monthlyWorkTimeStatsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$monthlyWorkTimeStatsHash,
          dependencies: MonthlyWorkTimeStatsFamily._dependencies,
          allTransitiveDependencies:
              MonthlyWorkTimeStatsFamily._allTransitiveDependencies,
          currentMonth: currentMonth,
        );

  MonthlyWorkTimeStatsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.currentMonth,
  }) : super.internal();

  final DateTime currentMonth;

  @override
  Override overrideWith(
    FutureOr<List<WorkTimeStat>> Function(MonthlyWorkTimeStatsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MonthlyWorkTimeStatsProvider._internal(
        (ref) => create(ref as MonthlyWorkTimeStatsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        currentMonth: currentMonth,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<WorkTimeStat>> createElement() {
    return _MonthlyWorkTimeStatsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MonthlyWorkTimeStatsProvider &&
        other.currentMonth == currentMonth;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, currentMonth.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin MonthlyWorkTimeStatsRef
    on AutoDisposeFutureProviderRef<List<WorkTimeStat>> {
  /// The parameter `currentMonth` of this provider.
  DateTime get currentMonth;
}

class _MonthlyWorkTimeStatsProviderElement
    extends AutoDisposeFutureProviderElement<List<WorkTimeStat>>
    with MonthlyWorkTimeStatsRef {
  _MonthlyWorkTimeStatsProviderElement(super.provider);

  @override
  DateTime get currentMonth =>
      (origin as MonthlyWorkTimeStatsProvider).currentMonth;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
