import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class ToastUtils {
    ToastUtils({required this.toastText, required BuildContext context})
      : fToast = FToast() {
    fToast.init(context);
    initializeToast();
  }

  final String toastText;
  late FToast fToast;
  late Widget toast;

  void initializeToast() {
    toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.greenAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check),
          const SizedBox(width: 12.0),
          Text(toastText),
        ],
      ),
    );
  }

  void showToast() {
    if (toast == null) {
      initializeToast();
    }
    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }
}
