import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FlushBarUtils {
  static void fieldFocusChange(BuildContext context, FocusNode current, FocusNode nestFocus) {
    current.unfocus();
    FocusScope.of(context).requestFocus(nestFocus);
  }

  static void toastMessage(String message) {
    Fluttertoast.showToast(
      timeInSecForIosWeb: 2,
      msg: message,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      gravity: ToastGravity.TOP,
    );
  }

  static void toastErrorMessage(String message) {
    Fluttertoast.showToast(
      timeInSecForIosWeb: 2,
      msg: message,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      gravity: ToastGravity.TOP,
    );
  }

  static void flushBarErrorMessage(String message, BuildContext context) {
    showFlushbar<void>(
        context: context,
        flushbar: Flushbar(
            forwardAnimationCurve: Curves.decelerate,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: const EdgeInsets.all(10),
            message: message,
            backgroundColor: const Color.fromARGB(255, 86, 0, 0),
            duration: const Duration(seconds: 3),
            reverseAnimationCurve: Curves.easeInOut,
            positionOffset: 20,
            borderRadius: BorderRadius.circular(20),
            flushbarPosition: FlushbarPosition.TOP,
            icon: const Icon(Icons.error, size: 28, color: Color.fromARGB(255, 255, 255, 255)))
          ..show(context));
  }

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackBar(
      String message, BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.black,
      content: Text(message),
    ));
  }
}
