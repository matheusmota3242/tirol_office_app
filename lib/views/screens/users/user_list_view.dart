import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tirol_office_app/db/firestore.dart';
import 'package:tirol_office_app/models/enums/user_role_enum.dart';
import 'package:tirol_office_app/models/user_model.dart';
import 'package:tirol_office_app/service/user_service.dart';
import 'package:tirol_office_app/utils/page_utils.dart';
import 'package:tirol_office_app/views/screens/error_view.dart';
import 'package:tirol_office_app/views/widgets/menu_drawer.dart';
import 'package:tirol_office_app/views/widgets/toast.dart';

class UserListView extends StatefulWidget {
  @override
  _UserListViewState createState() => _UserListViewState();
}

class _UserListViewState extends State<UserListView> {
  User currentUser;
  var _users = FirestoreDB.users;
  static const CHANGE_USER_ROLE = 'Alterar papel do usuário';
  static const REMOVE = 'Remover';
  var choices = <String>[CHANGE_USER_ROLE, REMOVE];
  String selectedRole = '';
  UserService _userService = UserService();
  @override
  Widget build(BuildContext context) {
    _userService = Provider.of<UserService>(context);
    currentUser = _userService.getUser;
    final title = PageUtils.USERS_TITLE;

    return StreamBuilder(
      stream: _users.orderBy('name').snapshots(),
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
                user: currentUser,
                currentPage: title,
              ),
              body: setBody(context, snapshot),
            );
        }
      },
    );
  }

  Widget setBody(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
            return InkWell(
              onLongPress: () => showDeleteDialog(user),
              onDoubleTap: () => showSelectRoleDialog(user),
              child: ListTile(
                title: Text(user.name),
                leading:
                    Icon(Icons.person_outline, color: handleIcon(user.role)),
                subtitle: Text(user.email != null ? user.email : ''),
                // trailing: Visibility(
                //   visible: currentUser.role == 'Administrador' ? true : false,
                //   child: PopupMenuButton<String>(
                //     onSelected: (value) => onSelectedChoice(value, user),
                //     icon: Icon(Icons.more_vert),
                //     itemBuilder: (BuildContext context) {
                //       return choices.map((String choice) {
                //         return PopupMenuItem<String>(
                //           value: choice,
                //           child: Text(choice),
                //         );
                //       }).toList();
                //     },
                //   ),
                // ),
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
    FirestoreDB.users
        .doc(docId)
        .update({'role': role})
        .then(
          (value) => Toasts.showToast(content: successMsg),
        )
        .catchError(
          (error) => Toasts.showToast(content: errorMsg),
        );
  }

  Color handleIcon(String role) {
    switch (role) {
      case 'Administrador':
        return Colors.green[500];
        break;
      case 'Comum':
        return Colors.yellow[500];
        break;
      case 'Aguardando aprovação':
        return Colors.red[500];
        break;
      default:
    }
  }

  showSelectRoleDialog(User user) {
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
                      'Selecione o papel a ser atribuído ao usuário ${user.name}:'),
                  SizedBox(height: 20.0),
                  Container(
                    width: double.maxFinite,
                    height: 200,
                    child: ListView.builder(
                      itemCount: Role().getRoles().length,
                      itemBuilder: (context, index) {
                        var role = Role().getRoles()[index];
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
                            child: Text(
                              'Cancelar',
                              style: TextStyle(color: PageUtils.PRIMARY_COLOR),
                            )),
                        ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Theme.of(context).buttonColor),
                            ),
                            onPressed: () {
                              changeFirestoreUserRole(selectedRole, user.id);
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
  }

  showDeleteDialog(User user) {
    showDialog(
      context: context,
      builder: (_) =>
          StatefulBuilder(builder: (BuildContext localContext, innerSetState) {
        return AlertDialog(
          title: Text(
            'Remover',
            style: TextStyle(color: Colors.red[500]),
          ),
          content:
              Text('Você realmente deseja remover o usuário ${user.name}?'),
          actions: [
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(localContext);
                    },
                    child: Text('Cancelar'),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (currentUser.id != user.id) {
                        _userService.removeUser(user);
                      } else {
                        Toasts.showToast(
                            content: 'Não pode remover a si mesmo');
                      }
                      Navigator.pop(localContext);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Theme.of(context).buttonColor),
                    ),
                    child: Text('Sim'),
                  )
                ],
              ),
            )
          ],
        );
      }),
    );
  }

  onSelectedChoice(String choice, User user) {
    switch (choice) {
      case CHANGE_USER_ROLE:
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
                                child: Text(
                                  'Cancelar',
                                  style:
                                      TextStyle(color: PageUtils.PRIMARY_COLOR),
                                )),
                            ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Theme.of(context).buttonColor),
                                ),
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
      case REMOVE:
        showDeleteDialog(user);
        break;
      default:
    }
  }
}
