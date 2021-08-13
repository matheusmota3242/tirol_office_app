import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Toasts {
  static void showToast({@required String content}) {
    Fluttertoast.showToast(
      msg: content,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.grey[900],
    );
  }
}
