import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tirol_office_app/db/firestore.dart';
import 'package:tirol_office_app/models/user_model.dart';
import 'package:tirol_office_app/views/screens/error_view.dart';
import 'package:tirol_office_app/views/widgets/appbar.dart';
import 'package:tirol_office_app/views/widgets/menu_drawer.dart';

class UserListView extends StatelessWidget {
  final String title;
  final User currentUser;
  final _users = FirestoreDB().db_users;

  UserListView({Key key, this.currentUser, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _users.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
            break;
          default:
            return Scaffold(
              appBar: AppBarWidget(title),
              drawer: MenuDrawer(
                user: currentUser,
              ),
              body: setBody(context, snapshot),
            );
        }
      },
    );
  }

  Widget setBody(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    print(snapshot.connectionState);
    if (snapshot.hasError) {
      return ErrorView();
    }

    if (snapshot.connectionState == ConnectionState.active) {
      if (snapshot.hasData && snapshot.data.docs.length > 0) {
        return ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            String name = snapshot.data.docs[index]['name'];
            var role = snapshot.data.docs[index]['role'];
            return ListTile(
              title: Text(name),
              subtitle: Text(role.toString()),
            );
          },
        );
      }
    }
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
