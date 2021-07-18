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
        color: this.background == PageUtils.PRIMARY_COLOR
            ? Colors.white
            : PageUtils.PRIMARY_COLOR,
        backgroundColor: Colors.transparent,
      )),
    );
  }
}
