// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'experience_recommendations_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$experienceRecommendationsHash() =>
    r'9b61d118b66948fefa5e982b05f753da31391f41';

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

abstract class _$ExperienceRecommendations
    extends BuildlessAutoDisposeAsyncNotifier<List<SearchableActivity>> {
  late final String experienceId;
  late final String sectionType;

  FutureOr<List<SearchableActivity>> build(
    String experienceId,
    String sectionType,
  );
}

/// Provider unifié pour les recommandations d'expériences
///
/// Gère les recommandations pour Activities (Events à venir)
/// Utilise ExperienceItem en clé pour être vraiment unifié
///
/// Copied from [ExperienceRecommendations].
@ProviderFor(ExperienceRecommendations)
const experienceRecommendationsProvider = ExperienceRecommendationsFamily();

/// Provider unifié pour les recommandations d'expériences
///
/// Gère les recommandations pour Activities (Events à venir)
/// Utilise ExperienceItem en clé pour être vraiment unifié
///
/// Copied from [ExperienceRecommendations].
class ExperienceRecommendationsFamily
    extends Family<AsyncValue<List<SearchableActivity>>> {
  /// Provider unifié pour les recommandations d'expériences
  ///
  /// Gère les recommandations pour Activities (Events à venir)
  /// Utilise ExperienceItem en clé pour être vraiment unifié
  ///
  /// Copied from [ExperienceRecommendations].
  const ExperienceRecommendationsFamily();

  /// Provider unifié pour les recommandations d'expériences
  ///
  /// Gère les recommandations pour Activities (Events à venir)
  /// Utilise ExperienceItem en clé pour être vraiment unifié
  ///
  /// Copied from [ExperienceRecommendations].
  ExperienceRecommendationsProvider call(
    String experienceId,
    String sectionType,
  ) {
    return ExperienceRecommendationsProvider(
      experienceId,
      sectionType,
    );
  }

  @override
  ExperienceRecommendationsProvider getProviderOverride(
    covariant ExperienceRecommendationsProvider provider,
  ) {
    return call(
      provider.experienceId,
      provider.sectionType,
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
  String? get name => r'experienceRecommendationsProvider';
}

/// Provider unifié pour les recommandations d'expériences
///
/// Gère les recommandations pour Activities (Events à venir)
/// Utilise ExperienceItem en clé pour être vraiment unifié
///
/// Copied from [ExperienceRecommendations].
class ExperienceRecommendationsProvider
    extends AutoDisposeAsyncNotifierProviderImpl<ExperienceRecommendations,
        List<SearchableActivity>> {
  /// Provider unifié pour les recommandations d'expériences
  ///
  /// Gère les recommandations pour Activities (Events à venir)
  /// Utilise ExperienceItem en clé pour être vraiment unifié
  ///
  /// Copied from [ExperienceRecommendations].
  ExperienceRecommendationsProvider(
    String experienceId,
    String sectionType,
  ) : this._internal(
          () => ExperienceRecommendations()
            ..experienceId = experienceId
            ..sectionType = sectionType,
          from: experienceRecommendationsProvider,
          name: r'experienceRecommendationsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$experienceRecommendationsHash,
          dependencies: ExperienceRecommendationsFamily._dependencies,
          allTransitiveDependencies:
              ExperienceRecommendationsFamily._allTransitiveDependencies,
          experienceId: experienceId,
          sectionType: sectionType,
        );

  ExperienceRecommendationsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.experienceId,
    required this.sectionType,
  }) : super.internal();

  final String experienceId;
  final String sectionType;

  @override
  FutureOr<List<SearchableActivity>> runNotifierBuild(
    covariant ExperienceRecommendations notifier,
  ) {
    return notifier.build(
      experienceId,
      sectionType,
    );
  }

  @override
  Override overrideWith(ExperienceRecommendations Function() create) {
    return ProviderOverride(
      origin: this,
      override: ExperienceRecommendationsProvider._internal(
        () => create()
          ..experienceId = experienceId
          ..sectionType = sectionType,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        experienceId: experienceId,
        sectionType: sectionType,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<ExperienceRecommendations,
      List<SearchableActivity>> createElement() {
    return _ExperienceRecommendationsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ExperienceRecommendationsProvider &&
        other.experienceId == experienceId &&
        other.sectionType == sectionType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, experienceId.hashCode);
    hash = _SystemHash.combine(hash, sectionType.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ExperienceRecommendationsRef
    on AutoDisposeAsyncNotifierProviderRef<List<SearchableActivity>> {
  /// The parameter `experienceId` of this provider.
  String get experienceId;

  /// The parameter `sectionType` of this provider.
  String get sectionType;
}

class _ExperienceRecommendationsProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<ExperienceRecommendations,
        List<SearchableActivity>> with ExperienceRecommendationsRef {
  _ExperienceRecommendationsProviderElement(super.provider);

  @override
  String get experienceId =>
      (origin as ExperienceRecommendationsProvider).experienceId;
  @override
  String get sectionType =>
      (origin as ExperienceRecommendationsProvider).sectionType;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
