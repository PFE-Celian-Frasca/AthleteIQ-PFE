import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

void navigateBackOrToMain(BuildContext context) {
  if (Navigator.of(context).canPop()) {
    GoRouter.of(context).pop();
  } else {
    GoRouter.of(context).go('/');
  }
}
