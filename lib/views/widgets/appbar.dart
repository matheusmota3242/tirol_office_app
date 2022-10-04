import 'package:flutter/material.dart';

class AppBarWidget extends PreferredSize {
  final String title;

  AppBarWidget(this.title);

  @override
  Size get preferredSize => AppBar().preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(this.title),
      backgroundColor: Theme.of(context).buttonColor,
      shadowColor: Colors.transparent,
    );
  }
}
