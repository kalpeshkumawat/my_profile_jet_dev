import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class Utilities {


  // ! Get String value from the TextFormField

  static String getString(TextEditingController controller) {
    if (controller.text.isEmpty) {
      return "";
    } else {
      return controller.text.toString().trim();
    }
  }

  // ! Hide Keyboard

  static void hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }


  // ! Show Toast message

  static void showToastMsg(BuildContext context, String message) {
    showToast(message,
        context: context,
        animation: StyledToastAnimation.fadeScale,
        reverseAnimation: StyledToastAnimation.slideToBottomFade,
        position: StyledToastPosition.bottom,
        animDuration: const Duration(seconds: 1),
        duration: const Duration(seconds: 3),
        borderRadius: BorderRadius.circular(20.0),
        curve: Curves.elasticOut,
        textStyle: const TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color: Colors.white),
        backgroundColor: Colors.black45,
        reverseCurve: Curves.linear);
  }
}
