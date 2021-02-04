import 'package:flutter/material.dart';
import 'package:tirol_office_app/views/widgets/appbar.dart';

class LoadingScreen extends StatelessWidget {
  final String title;

  const LoadingScreen({Key key, this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(''),
    );
  }
}
