import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tirol_office_app/auth/auth_service.dart';

class MenuDrawer extends StatelessWidget {
  final String userEmail;

  const MenuDrawer({Key key, this.userEmail}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Center(
        child: Text(userEmail),
      ),
    );
  }
}
