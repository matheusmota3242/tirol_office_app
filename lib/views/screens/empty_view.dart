import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class EmptyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 200.0,
        child: SvgPicture.asset('assets/images/tirol_office_empty.svg'),
      ),
    );
  }
}
