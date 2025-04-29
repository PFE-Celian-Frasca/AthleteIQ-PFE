// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parcours_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$firebaseStorageHash() => r'ddec157566e3f96dac39d44de2cd99f9d71f9b54';

/// See also [firebaseStorage].
@ProviderFor(firebaseStorage)
final firebaseStorageProvider = Provider<FirebaseStorage>.internal(
  firebaseStorage,
  name: r'firebaseStorageProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$firebaseStorageHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FirebaseStorageRef = ProviderRef<FirebaseStorage>;
String _$parcoursRepositoryHash() =>
    r'ac335a3dc3221875f7cdc5a1a2fdb86ee9d187d9';

/// See also [parcoursRepository].
@ProviderFor(parcoursRepository)
final parcoursRepositoryProvider = Provider<ParcoursRepository>.internal(
  parcoursRepository,
  name: r'parcoursRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$parcoursRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ParcoursRepositoryRef = ProviderRef<ParcoursRepository>;
String _$userParcoursStreamHash() =>
    r'17d37cc06b74d46cc7f99dbb1d73eba625fbf7a7';

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

/// See also [userParcoursStream].
@ProviderFor(userParcoursStream)
const userParcoursStreamProvider = UserParcoursStreamFamily();

/// See also [userParcoursStream].
class UserParcoursStreamFamily
    extends Family<AsyncValue<List<List<ParcoursWithGPSData>>>> {
  /// See also [userParcoursStream].
  const UserParcoursStreamFamily();

  /// See also [userParcoursStream].
  UserParcoursStreamProvider call(
    String userId,
  ) {
    return UserParcoursStreamProvider(
      userId,
    );
  }

  @override
  UserParcoursStreamProvider getProviderOverride(
    covariant UserParcoursStreamProvider provider,
  ) {
    return call(
      provider.userId,
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
  String? get name => r'userParcoursStreamProvider';
}

/// See also [userParcoursStream].
class UserParcoursStreamProvider
    extends AutoDisposeStreamProvider<List<List<ParcoursWithGPSData>>> {
  /// See also [userParcoursStream].
  UserParcoursStreamProvider(
    String userId,
  ) : this._internal(
          (ref) => userParcoursStream(
            ref as UserParcoursStreamRef,
            userId,
          ),
          from: userParcoursStreamProvider,
          name: r'userParcoursStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userParcoursStreamHash,
          dependencies: UserParcoursStreamFamily._dependencies,
          allTransitiveDependencies:
              UserParcoursStreamFamily._allTransitiveDependencies,
          userId: userId,
        );

  UserParcoursStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  Override overrideWith(
    Stream<List<List<ParcoursWithGPSData>>> Function(
            UserParcoursStreamRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserParcoursStreamProvider._internal(
        (ref) => create(ref as UserParcoursStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<List<ParcoursWithGPSData>>>
      createElement() {
    return _UserParcoursStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserParcoursStreamProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin UserParcoursStreamRef
    on AutoDisposeStreamProviderRef<List<List<ParcoursWithGPSData>>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _UserParcoursStreamProviderElement
    extends AutoDisposeStreamProviderElement<List<List<ParcoursWithGPSData>>>
    with UserParcoursStreamRef {
  _UserParcoursStreamProviderElement(super.provider);

  @override
  String get userId => (origin as UserParcoursStreamProvider).userId;
}

String _$singleParcoursWithGPSDataHash() =>
    r'405260c0ba600634c606c10189ff67b28def8243';

/// See also [singleParcoursWithGPSData].
@ProviderFor(singleParcoursWithGPSData)
const singleParcoursWithGPSDataProvider = SingleParcoursWithGPSDataFamily();

/// See also [singleParcoursWithGPSData].
class SingleParcoursWithGPSDataFamily
    extends Family<AsyncValue<ParcoursWithGPSData>> {
  /// See also [singleParcoursWithGPSData].
  const SingleParcoursWithGPSDataFamily();

  /// See also [singleParcoursWithGPSData].
  SingleParcoursWithGPSDataProvider call(
    String parcoursId,
  ) {
    return SingleParcoursWithGPSDataProvider(
      parcoursId,
    );
  }

  @override
  SingleParcoursWithGPSDataProvider getProviderOverride(
    covariant SingleParcoursWithGPSDataProvider provider,
  ) {
    return call(
      provider.parcoursId,
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
  String? get name => r'singleParcoursWithGPSDataProvider';
}

/// See also [singleParcoursWithGPSData].
class SingleParcoursWithGPSDataProvider
    extends AutoDisposeStreamProvider<ParcoursWithGPSData> {
  /// See also [singleParcoursWithGPSData].
  SingleParcoursWithGPSDataProvider(
    String parcoursId,
  ) : this._internal(
          (ref) => singleParcoursWithGPSData(
            ref as SingleParcoursWithGPSDataRef,
            parcoursId,
          ),
          from: singleParcoursWithGPSDataProvider,
          name: r'singleParcoursWithGPSDataProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$singleParcoursWithGPSDataHash,
          dependencies: SingleParcoursWithGPSDataFamily._dependencies,
          allTransitiveDependencies:
              SingleParcoursWithGPSDataFamily._allTransitiveDependencies,
          parcoursId: parcoursId,
        );

  SingleParcoursWithGPSDataProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.parcoursId,
  }) : super.internal();

  final String parcoursId;

  @override
  Override overrideWith(
    Stream<ParcoursWithGPSData> Function(SingleParcoursWithGPSDataRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SingleParcoursWithGPSDataProvider._internal(
        (ref) => create(ref as SingleParcoursWithGPSDataRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        parcoursId: parcoursId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<ParcoursWithGPSData> createElement() {
    return _SingleParcoursWithGPSDataProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SingleParcoursWithGPSDataProvider &&
        other.parcoursId == parcoursId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, parcoursId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SingleParcoursWithGPSDataRef
    on AutoDisposeStreamProviderRef<ParcoursWithGPSData> {
  /// The parameter `parcoursId` of this provider.
  String get parcoursId;
}

class _SingleParcoursWithGPSDataProviderElement
    extends AutoDisposeStreamProviderElement<ParcoursWithGPSData>
    with SingleParcoursWithGPSDataRef {
  _SingleParcoursWithGPSDataProviderElement(super.provider);

  @override
  String get parcoursId =>
      (origin as SingleParcoursWithGPSDataProvider).parcoursId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
