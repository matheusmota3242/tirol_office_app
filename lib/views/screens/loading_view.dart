import 'package:flutter/material.dart';
import 'package:tirol_office_app/utils/page_utils.dart';

class LoadingView extends StatelessWidget {
  final Color background;

  const LoadingView({Key key, this.background}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: this.background,
      child: Center(
          child: CircularProgressIndicator(
        color: this.background == PageUtils.primaryColor
            ? Colors.white
            : PageUtils.primaryColor,
        backgroundColor: Colors.transparent,
      )),
    );
  }
}
