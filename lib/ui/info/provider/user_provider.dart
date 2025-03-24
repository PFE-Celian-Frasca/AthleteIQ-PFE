import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:athlete_iq/data/network/userRepository.dart';
import '../../../model/User.dart';

final firestoreUserProvider = StreamProvider<User>((ref) {
  final stream = ref.read(userRepositoryProvider).userStream;
  return stream.map((snapshot) => User.fromFirestore(snapshot));
});