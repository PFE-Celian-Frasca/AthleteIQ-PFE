import 'package:athlete_iq/models/parcour/parcours_model.dart';
import 'package:athlete_iq/models/parcour/parcours_with_gps_data.dart';
import 'package:athlete_iq/providers/google_map_provider.dart';
import 'package:athlete_iq/utils/stringCapitalize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../utils/map_utils.dart';

Widget parcourTile(
    ParcoursWithGPSData parcourAndData, BuildContext context, WidgetRef ref) {
  Color getColorForType(ParcoursType type) {
    switch (type) {
      case ParcoursType.Public:
        return Colors.green;
      case ParcoursType.Shared:
        return Colors.orange;
      case ParcoursType.Private:
        return Theme.of(context).colorScheme.error;
      default:
        return Theme.of(context).colorScheme.tertiary;
    }
  }

  String visibilityText(ParcoursType type) {
    switch (type) {
      case ParcoursType.Public:
        return "Publique";
      case ParcoursType.Shared:
        return "Partagé";
      case ParcoursType.Private:
        return "Privée";
      default:
        return "Inconnue";
    }
  }

  void onMapCreated(GoogleMapController controller, WidgetRef ref) {
    ref
        .read(googleMapControllerProvider(parcourAndData.parcours.id!).notifier)
        .state = controller;
    controller.animateCamera(CameraUpdate.newLatLngBounds(
        MapUtils.boundsFromLatLngList(parcourAndData.gpsData
            .map((e) => LatLng(e.latitude, e.longitude))
            .toList()),
        25.w));
  }

  return GestureDetector(
    onTap: () {
      GoRouter.of(context)
          .push('/parcours/details/${parcourAndData.parcours.id}');
    },
    child: Container(
      margin: EdgeInsets.only(bottom: 15.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.tertiary.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(8.h),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).colorScheme.onBackground,
                      width: 1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                height: 80.h,
                width: 80.w,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: GoogleMap(
                    polylines: {
                      Polyline(
                        polylineId: PolylineId(parcourAndData.parcours.title),
                        points: parcourAndData.gpsData
                            .map((e) => LatLng(e.latitude, e.longitude))
                            .toList(),
                        width: 4,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    },
                    compassEnabled: false,
                    mapToolbarEnabled: false,
                    zoomControlsEnabled: false,
                    zoomGesturesEnabled: false,
                    myLocationButtonEnabled: false,
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(parcourAndData.gpsData.first.latitude,
                          parcourAndData.gpsData.first.longitude),
                      zoom: 11,
                    ),
                    onMapCreated: (controller) => onMapCreated(controller, ref),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      parcourAndData.parcours.title.capitalize(),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "Visibilité: ${visibilityText(parcourAndData.parcours.type)}",
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: getColorForType(parcourAndData.parcours.type)),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${parcourAndData.parcours.totalDistance.toStringAsFixed(2)} Km",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.tertiary),
                        ),
                        Text(
                          "${parcourAndData.parcours.timer.hours.toString().padLeft(2, '0')}:${parcourAndData.parcours.timer.minutes.toString().padLeft(2, '0')}:${parcourAndData.parcours.timer.seconds.toString().padLeft(2, '0')}",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.tertiary),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      DateFormat('dd/MM/yyyy')
                          .format(parcourAndData.parcours.createdAt),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.tertiary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
