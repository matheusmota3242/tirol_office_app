import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tirol_office_app/db/firestore.dart';
import 'package:tirol_office_app/models/enums/user_role_enum.dart';
import 'package:tirol_office_app/models/user_model.dart';
import 'package:tirol_office_app/views/screens/error_view.dart';
import 'package:tirol_office_app/views/widgets/appbar.dart';
import 'package:tirol_office_app/views/widgets/dialogs.dart';
import 'package:tirol_office_app/views/widgets/menu_drawer.dart';
import 'package:tirol_office_app/views/widgets/toast.dart';

class UserListView extends StatelessWidget {
  final String title;
  final User currentUser;
  final _users = FirestoreDB().db_users;

  UserListView({Key key, this.currentUser, this.title}) : super(key: key);

  var choices = <String>['Alterar papel do usuário'];

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
              appBar: AppBar(
                title: Text(title),
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
            String role = snapshot.data.docs[index]['role'];
            String docId = snapshot.data.docs[index].id;
            print(docId);
            return ListTile(
              title: Text(name),
              subtitle: Text(role.toString()),
              trailing: PopupMenuButton<String>(
                onSelected: (value) =>
                    onSelectedChoice(value, context, docId, name),
                icon: Icon(Icons.more_vert),
                itemBuilder: (BuildContext context) {
                  return choices.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              ),
            );
          },
        );
      }
    }
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  changeFirestoreUserRole(String role, String docId) {
    String successMsg = 'Papel alterado com sucesso';
    String errorMsg = 'Ocorreu um erro. Tente novamente mais tarde';
    _users
        .doc(docId)
        .update({'role': role})
        .then(
          (value) => Toasts.showToast(content: successMsg),
        )
        .catchError(
          (error) => Toasts.showToast(content: errorMsg),
        );
  }

  onSelectedChoice(
      String choice, BuildContext context, String docId, String name) {
    switch (choice) {
      case 'Alterar papel do usuário':
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  //title: Text('Alterar papel do usuário'),
                  content: Container(
                height: 260.0,
                child: Column(
                  children: <Widget>[
                    Text('Selecione o papel a ser atribuído ao usuário $name'),
                    SizedBox(height: 20.0),
                    Container(
                      width: double.maxFinite,
                      height: 200,
                      child: ListView.builder(
                        itemCount: Role().getRoles().length,
                        itemBuilder: (context, index) {
                          var role = Role().getRoles()[index];
                          return TextButton(
                              child: Text(role),
                              onPressed: () {
                                changeFirestoreUserRole(role, docId);
                                Navigator.pop(context);
                              });
                        },
                      ),
                    )
                  ],
                ),
              ));
            });
        break;
      default:
    }
  }
}
