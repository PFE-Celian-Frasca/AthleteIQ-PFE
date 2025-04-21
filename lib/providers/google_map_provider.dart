import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final googleMapControllerProvider =
    StateProvider.family<GoogleMapController?, String>((ref, uniqueId) {
  return null;
});
