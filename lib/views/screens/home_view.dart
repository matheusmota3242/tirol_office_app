import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';

import 'package:tirol_office_app/auth/auth_service.dart';
import 'package:tirol_office_app/db/firestore.dart';
import 'package:tirol_office_app/models/enums/user_role_enum.dart';
import 'package:tirol_office_app/models/user_model.dart';
import 'package:tirol_office_app/views/widgets/appbar.dart';
import 'package:tirol_office_app/views/widgets/menu_drawer.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String title = 'Home';
    final _authService = Provider.of<AuthService>(context);
    final _users = FirestoreDB().db_users;
    User _user = User();
    return FutureBuilder(
        future: _users.doc(_authService.user.uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
              break;
            default:
              if (snapshot.hasError) {
                return Text('Ocorreu um erro');
              }

              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData && snapshot.data.data() != null) {
                  Map<String, dynamic> data = snapshot.data.data();
                  print(data);
                  _user.name = data['name'];
                  _user.email = data['email'];
                  if (data['role'] ==
                      Role().getRoleByEnum(UserRole.WAITING_FOR_APPROVAL)) {
                    return Container(
                      height: double.infinity,
                      width: double.infinity,
                      child: Text('Solicite aprovação de um administrador'),
                    );
                  } else {
                    return Scaffold(
                      appBar: AppBarWidget(title),
                      drawer: MenuDrawer(
                        user: _user,
                      ),
                      body: Container(
                        padding: EdgeInsets.all(12.0),
                        child: ListView(
                          children: [
                            Container(
                              height: 132.0,
                              child: Card(
                                child: Container(
                                  padding: EdgeInsets.all(12.0),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                          child: Text(
                                            'Banheiro 1',
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey[800]),
                                          ),
                                          top: 0,
                                          left: 0),
                                      Positioned(
                                        child: Text(
                                          'Em andamento',
                                          style: TextStyle(
                                              color: Colors.yellow[600],
                                              fontStyle: FontStyle.italic,
                                              fontSize: 14.0),
                                        ),
                                        top: 0,
                                        right: 0,
                                      ),
                                      Positioned(
                                        child: Row(
                                          children: [
                                            Text(
                                              'Horário:',
                                              style: TextStyle(
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey[800]),
                                            ),
                                            SizedBox(
                                              width: 6.0,
                                            ),
                                            Text(
                                              '15:00 - 15:40',
                                              style: TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.grey[800]),
                                            ),
                                          ],
                                        ),
                                        top: 40.0,
                                      ),
                                      Positioned(
                                        child: Row(
                                          children: [
                                            Text(
                                              'Responsável:',
                                              style: TextStyle(
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey[800]),
                                            ),
                                            SizedBox(
                                              width: 6.0,
                                            ),
                                            Text(
                                              'Regiane Silva',
                                              style: TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.grey[800]),
                                            ),
                                          ],
                                        ),
                                        top: 80.0,
                                      ),
                                      Positioned(
                                          child: IconButton(
                                            icon: Icon(Icons.search),
                                            onPressed: () {},
                                          ),
                                          right: 0,
                                          top: 22.0)
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }
                } else {
                  return Center(
                    child: Text('Ocorreu um erro'),
                  );
                }
              }
              return Center(
                child: CircularProgressIndicator(),
              );
          }
        });
  }
}
