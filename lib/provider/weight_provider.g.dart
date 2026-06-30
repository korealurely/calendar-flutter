// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weight_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$weightRepositoryHash() => r'906d8f652d6b53ace9602bd2d9fcf41600ed01b9';

/// See also [weightRepository].
@ProviderFor(weightRepository)
final weightRepositoryProvider = AutoDisposeProvider<WeightRepository>.internal(
  weightRepository,
  name: r'weightRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$weightRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef WeightRepositoryRef = AutoDisposeProviderRef<WeightRepository>;
String _$dayWeightsStreamHash() => r'375a75f4c6dd53d0b68a90655a2e7b854f78d2e7';

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

/// See also [dayWeightsStream].
@ProviderFor(dayWeightsStream)
const dayWeightsStreamProvider = DayWeightsStreamFamily();

/// See also [dayWeightsStream].
class DayWeightsStreamFamily extends Family<AsyncValue<List<CalendarWeight>>> {
  /// See also [dayWeightsStream].
  const DayWeightsStreamFamily();

  /// See also [dayWeightsStream].
  DayWeightsStreamProvider call(
    DateTime data,
  ) {
    return DayWeightsStreamProvider(
      data,
    );
  }

  @override
  DayWeightsStreamProvider getProviderOverride(
    covariant DayWeightsStreamProvider provider,
  ) {
    return call(
      provider.data,
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
  String? get name => r'dayWeightsStreamProvider';
}

/// See also [dayWeightsStream].
class DayWeightsStreamProvider
    extends AutoDisposeStreamProvider<List<CalendarWeight>> {
  /// See also [dayWeightsStream].
  DayWeightsStreamProvider(
    DateTime data,
  ) : this._internal(
          (ref) => dayWeightsStream(
            ref as DayWeightsStreamRef,
            data,
          ),
          from: dayWeightsStreamProvider,
          name: r'dayWeightsStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$dayWeightsStreamHash,
          dependencies: DayWeightsStreamFamily._dependencies,
          allTransitiveDependencies:
              DayWeightsStreamFamily._allTransitiveDependencies,
          data: data,
        );

  DayWeightsStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.data,
  }) : super.internal();

  final DateTime data;

  @override
  Override overrideWith(
    Stream<List<CalendarWeight>> Function(DayWeightsStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DayWeightsStreamProvider._internal(
        (ref) => create(ref as DayWeightsStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        data: data,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<CalendarWeight>> createElement() {
    return _DayWeightsStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DayWeightsStreamProvider && other.data == data;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, data.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin DayWeightsStreamRef
    on AutoDisposeStreamProviderRef<List<CalendarWeight>> {
  /// The parameter `data` of this provider.
  DateTime get data;
}

class _DayWeightsStreamProviderElement
    extends AutoDisposeStreamProviderElement<List<CalendarWeight>>
    with DayWeightsStreamRef {
  _DayWeightsStreamProviderElement(super.provider);

  @override
  DateTime get data => (origin as DayWeightsStreamProvider).data;
}

String _$weightViewModelHash() => r'75b512c7062a7fe5f03dea9d43f6a96edbd06544';

abstract class _$WeightViewModel
    extends BuildlessAutoDisposeAsyncNotifier<Map<int, List<CalendarWeight>>> {
  late final int year;
  late final int month;

  FutureOr<Map<int, List<CalendarWeight>>> build(
    int year,
    int month,
  );
}

/// See also [WeightViewModel].
@ProviderFor(WeightViewModel)
const weightViewModelProvider = WeightViewModelFamily();

/// See also [WeightViewModel].
class WeightViewModelFamily
    extends Family<AsyncValue<Map<int, List<CalendarWeight>>>> {
  /// See also [WeightViewModel].
  const WeightViewModelFamily();

  /// See also [WeightViewModel].
  WeightViewModelProvider call(
    int year,
    int month,
  ) {
    return WeightViewModelProvider(
      year,
      month,
    );
  }

  @override
  WeightViewModelProvider getProviderOverride(
    covariant WeightViewModelProvider provider,
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
  String? get name => r'weightViewModelProvider';
}

/// See also [WeightViewModel].
class WeightViewModelProvider extends AutoDisposeAsyncNotifierProviderImpl<
    WeightViewModel, Map<int, List<CalendarWeight>>> {
  /// See also [WeightViewModel].
  WeightViewModelProvider(
    int year,
    int month,
  ) : this._internal(
          () => WeightViewModel()
            ..year = year
            ..month = month,
          from: weightViewModelProvider,
          name: r'weightViewModelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$weightViewModelHash,
          dependencies: WeightViewModelFamily._dependencies,
          allTransitiveDependencies:
              WeightViewModelFamily._allTransitiveDependencies,
          year: year,
          month: month,
        );

  WeightViewModelProvider._internal(
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
  FutureOr<Map<int, List<CalendarWeight>>> runNotifierBuild(
    covariant WeightViewModel notifier,
  ) {
    return notifier.build(
      year,
      month,
    );
  }

  @override
  Override overrideWith(WeightViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: WeightViewModelProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<WeightViewModel,
      Map<int, List<CalendarWeight>>> createElement() {
    return _WeightViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WeightViewModelProvider &&
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

mixin WeightViewModelRef
    on AutoDisposeAsyncNotifierProviderRef<Map<int, List<CalendarWeight>>> {
  /// The parameter `year` of this provider.
  int get year;

  /// The parameter `month` of this provider.
  int get month;
}

class _WeightViewModelProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<WeightViewModel,
        Map<int, List<CalendarWeight>>> with WeightViewModelRef {
  _WeightViewModelProviderElement(super.provider);

  @override
  int get year => (origin as WeightViewModelProvider).year;
  @override
  int get month => (origin as WeightViewModelProvider).month;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
