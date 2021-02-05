import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ErrorView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 200.0,
            child: SvgPicture.asset('assets/images/error.svg'),
          ),
          SizedBox(
            height: 40.0,
          ),
          Text(
            'Desculpe, ocorreu um erro',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
