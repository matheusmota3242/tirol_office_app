import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tirol_office_app/db/firestore.dart';
import 'package:tirol_office_app/helpers/page_helper.dart';
import 'package:tirol_office_app/models/enums/user_role_enum.dart';
import 'package:tirol_office_app/models/user_model.dart';
import 'package:tirol_office_app/service/user_service.dart';
import 'package:tirol_office_app/views/screens/error_view.dart';
import 'package:tirol_office_app/views/widgets/appbar.dart';
import 'package:tirol_office_app/views/widgets/dialogs.dart';
import 'package:tirol_office_app/views/widgets/menu_drawer.dart';
import 'package:tirol_office_app/views/widgets/toast.dart';

class UserListView extends StatefulWidget {
  @override
  _UserListViewState createState() => _UserListViewState();
}

class _UserListViewState extends State<UserListView> {
  User currentUser;
  var _users = FirestoreDB().db_users;

  var choices = <String>['Alterar papel do usuário'];
  String selectedRole = '';

  @override
  Widget build(BuildContext context) {
    final title = PageHelper.users;
    return StreamBuilder(
      stream: _users.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
            break;
          default:
            return Scaffold(
              appBar: AppBar(
                title: Text(title),
              ),
              drawer: MenuDrawer(
                user: Provider.of<UserService>(context).getUser,
                currentPage: title,
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
            User user = User.fromJson(snapshot.data.docs[index].data());

            user.id = snapshot.data.docs[index].id;
            return ListTile(
              title: Text(user.name),
              leading: Icon(Icons.person_outline),
              subtitle: Text(user.role.toString()),
              trailing: PopupMenuButton<String>(
                onSelected: (value) => onSelectedChoice(value, context, user),
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

  onSelectedChoice(String choice, BuildContext context, User user) {
    switch (choice) {
      case 'Alterar papel do usuário':
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(builder: (_, setState) {
                selectedRole = user.role;
                return AlertDialog(
                    //title: Text('Alterar papel do usuário'),
                    content: Container(
                  height: 310.0,
                  child: Column(
                    children: <Widget>[
                      Text(
                          'Selecione o papel a ser atribuído ao usuário ${user.name}'),
                      SizedBox(height: 20.0),
                      Container(
                        width: double.maxFinite,
                        height: 200,
                        child: ListView.builder(
                          itemCount: Role().getRoles().length,
                          itemBuilder: (context, index) {
                            var role = Role().getRoles()[index];
                            print(user.role);
                            return RadioListTile(
                                title: Text(role),
                                value: selectedRole == role ? 1 : 0,
                                groupValue: 1,
                                onChanged: (value) {
                                  setState(() {
                                    user.role = role;
                                    selectedRole = user.role;
                                  });
                                });
                          },
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('Cancelar')),
                            ElevatedButton(
                                onPressed: () {
                                  changeFirestoreUserRole(
                                      selectedRole, user.id);
                                  Navigator.pop(context);
                                },
                                child: Text('Salvar'))
                          ],
                        ),
                      )
                    ],
                  ),
                ));
              });
            });
        break;
      default:
    }
  }
}
