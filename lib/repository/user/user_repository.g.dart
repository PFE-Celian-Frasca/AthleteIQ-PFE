// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$firebaseFirestoreHash() => r'2e7f8bd195d91c027c5155f34b719187867bc113';

/// See also [firebaseFirestore].
@ProviderFor(firebaseFirestore)
final firebaseFirestoreProvider = Provider<FirebaseFirestore>.internal(
  firebaseFirestore,
  name: r'firebaseFirestoreProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$firebaseFirestoreHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FirebaseFirestoreRef = ProviderRef<FirebaseFirestore>;
String _$userRepositoryHash() => r'e31ca2e76ac0456c799c355f4f47d726dcb95870';

/// See also [userRepository].
@ProviderFor(userRepository)
final userRepositoryProvider = Provider<UserRepository>.internal(
  userRepository,
  name: r'userRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserRepositoryRef = ProviderRef<UserRepository>;
String _$userStateChangesHash() => r'd6d4bf16308dfe7a8ad2cd0d1bc73b782021c5b8';

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

/// See also [userStateChanges].
@ProviderFor(userStateChanges)
const userStateChangesProvider = UserStateChangesFamily();

/// See also [userStateChanges].
class UserStateChangesFamily extends Family<AsyncValue<UserModel?>> {
  /// See also [userStateChanges].
  const UserStateChangesFamily();

  /// See also [userStateChanges].
  UserStateChangesProvider call(
    String userId,
  ) {
    return UserStateChangesProvider(
      userId,
    );
  }

  @override
  UserStateChangesProvider getProviderOverride(
    covariant UserStateChangesProvider provider,
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
  String? get name => r'userStateChangesProvider';
}

/// See also [userStateChanges].
class UserStateChangesProvider extends AutoDisposeStreamProvider<UserModel?> {
  /// See also [userStateChanges].
  UserStateChangesProvider(
    String userId,
  ) : this._internal(
          (ref) => userStateChanges(
            ref as UserStateChangesRef,
            userId,
          ),
          from: userStateChangesProvider,
          name: r'userStateChangesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userStateChangesHash,
          dependencies: UserStateChangesFamily._dependencies,
          allTransitiveDependencies:
              UserStateChangesFamily._allTransitiveDependencies,
          userId: userId,
        );

  UserStateChangesProvider._internal(
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
    Stream<UserModel?> Function(UserStateChangesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserStateChangesProvider._internal(
        (ref) => create(ref as UserStateChangesRef),
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
  AutoDisposeStreamProviderElement<UserModel?> createElement() {
    return _UserStateChangesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserStateChangesProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UserStateChangesRef on AutoDisposeStreamProviderRef<UserModel?> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _UserStateChangesProviderElement
    extends AutoDisposeStreamProviderElement<UserModel?>
    with UserStateChangesRef {
  _UserStateChangesProviderElement(super.provider);

  @override
  String get userId => (origin as UserStateChangesProvider).userId;
}

String _$currentUserHash() => r'57a5b75d0cb1a2f5e4ad1811d21cac6e5b950d34';

/// See also [currentUser].
@ProviderFor(currentUser)
const currentUserProvider = CurrentUserFamily();

/// See also [currentUser].
class CurrentUserFamily extends Family<AsyncValue<UserModel?>> {
  /// See also [currentUser].
  const CurrentUserFamily();

  /// See also [currentUser].
  CurrentUserProvider call(
    String userId,
  ) {
    return CurrentUserProvider(
      userId,
    );
  }

  @override
  CurrentUserProvider getProviderOverride(
    covariant CurrentUserProvider provider,
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
  String? get name => r'currentUserProvider';
}

/// See also [currentUser].
class CurrentUserProvider extends AutoDisposeFutureProvider<UserModel?> {
  /// See also [currentUser].
  CurrentUserProvider(
    String userId,
  ) : this._internal(
          (ref) => currentUser(
            ref as CurrentUserRef,
            userId,
          ),
          from: currentUserProvider,
          name: r'currentUserProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$currentUserHash,
          dependencies: CurrentUserFamily._dependencies,
          allTransitiveDependencies:
              CurrentUserFamily._allTransitiveDependencies,
          userId: userId,
        );

  CurrentUserProvider._internal(
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
    FutureOr<UserModel?> Function(CurrentUserRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CurrentUserProvider._internal(
        (ref) => create(ref as CurrentUserRef),
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
  AutoDisposeFutureProviderElement<UserModel?> createElement() {
    return _CurrentUserProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CurrentUserProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CurrentUserRef on AutoDisposeFutureProviderRef<UserModel?> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _CurrentUserProviderElement
    extends AutoDisposeFutureProviderElement<UserModel?> with CurrentUserRef {
  _CurrentUserProviderElement(super.provider);

  @override
  String get userId => (origin as CurrentUserProvider).userId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
