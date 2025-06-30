import 'package:athlete_iq/view/info/provider/navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final List<String> middleNav = ["Mes courses", "Mes favoris", "Mes amis"];

Widget buildMiddleNavInfo(WidgetRef ref) {
  final selectedIndex = ref.watch(navigationProvider);

  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 0.03.sw),
    child: SizedBox(
      height: 0.05.sh,
      child: Row(
        children: List.generate(
          middleNav.length,
          (index) => Expanded(
            child: GestureDetector(
              onTap: () {
                // Correctly modifying the provider based on user interaction
                ref.read(navigationProvider.notifier).setIndex(index);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    middleNav[index],
                    style: TextStyle(
                      color: selectedIndex == index ? Colors.blue : Colors.grey,
                      fontSize: 16.sp,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 2.h),
                    height: 2.h,
                    width: 30.w,
                    color: selectedIndex == index
                        ? Colors.blue
                        : Colors.transparent,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
