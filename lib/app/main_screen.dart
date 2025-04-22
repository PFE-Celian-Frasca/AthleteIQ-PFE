import 'package:athlete_iq/app/provider/nav_bar_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rive/rive.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:athlete_iq/resources/components/animatedBar.dart';
import 'package:athlete_iq/utils/rive_utils.dart';
import '../models/rive_asset.dart';

class MainScreen extends HookConsumerWidget {
  const MainScreen({required this.child, super.key});
  final Widget child;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = useState<int>(
        1); // Assuming initial index is based on design or active route
    final showNavBar = ref.watch(showNavBarProvider);
    final List<String> tabRoutes = [
      '/groups',
      '/',
      '/info',
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body:
          child, // Child widget to display content based on the selected index
      bottomNavigationBar: _buildBottomNavigationBar(
          showNavBar, context, selectedIndex.value, (index) {
        selectedIndex.value = index;
        context.go(tabRoutes[index]); // Navigate using GoRouter
      }, ref),
    );
  }

  Widget _buildBottomNavigationBar(bool showNavBar, BuildContext context,
      int currentIndex, ValueChanged<int> onItemSelected, WidgetRef ref) {
    return SafeArea(
      bottom: false,
      child: AnimatedOpacity(
          opacity: showNavBar ? 1.0 : 0,
          duration: const Duration(seconds: 1),
          child: showNavBar
              ? Container(
                  padding: EdgeInsets.only(
                      bottom: 5.h, top: 5.h, left: 20.w, right: 20.w),
                  margin:
                      EdgeInsets.symmetric(horizontal: 18.w, vertical: 24.h),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.9),
                    borderRadius: BorderRadius.all(Radius.circular(20.r)),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context)
                            .colorScheme
                            .onBackground
                            .withOpacity(0.2),
                        spreadRadius: 4,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      bottomNavs.length,
                      (index) => _buildNavItem(context, index,
                          currentIndex == index, onItemSelected, ref),
                    ),
                  ),
                )
              : const SizedBox()),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, bool isActive,
      ValueChanged<int> onItemSelected, WidgetRef ref) {
    final navItem = bottomNavs[index];
    final unreadCount =
        index == 0 ? 0 : 0; // Ici, supposons que l'index 0 est pour le chat

    return GestureDetector(
      onTap: () => onItemSelected(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBar(isActive: isActive),
          SizedBox(
            height: 40.h,
            width: 40.w,
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                Opacity(
                  opacity: isActive ? 1 : 0.5,
                  child: RiveAnimation.asset(
                    navItem.src,
                    artboard: navItem.artboard,
                    onInit: (artboard) {
                      StateMachineController? controller =
                          RiveUtils.getRiveController(
                        artboard,
                        stateMachineName: navItem.stateMachineName,
                      );
                      final SMIInput? input = controller.findInput('active');
                      if (input is SMIBool) {
                        navItem.input = input;
                      }
                    },
                  ),
                ),
                if (unreadCount > 0)
                  Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$unreadCount',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
