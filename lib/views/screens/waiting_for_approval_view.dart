import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WaitingForApprovalView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 200.0,
            child: SvgPicture.asset('assets/images/access_denied.svg'),
          ),
          SizedBox(
            height: 40.0,
          ),
          Text(
            'Solicite aprovação a um administrador',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
