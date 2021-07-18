import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tirol_office_app/db/firestore.dart';
import 'package:tirol_office_app/models/user_model.dart';
import 'package:tirol_office_app/service/user_service.dart';
import 'package:tirol_office_app/utils/page_utils.dart';
import 'package:tirol_office_app/views/screens/error_view.dart';
import 'package:tirol_office_app/views/screens/loading_view.dart';
import 'package:tirol_office_app/views/screens/personal_info/personal_info_form_view.dart';
import 'package:tirol_office_app/views/screens/personal_info/personal_info_password_form.dart';
import 'package:tirol_office_app/views/widgets/menu_drawer.dart';

class PersonalInfoView extends StatelessWidget {
  static const String NAME_FIELD = 'Nome';
  static const String EMAIL_FIELD = 'E-mail';
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserService>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(PageUtils.PERSONAL_INFO_TITLE),
      ),
      drawer: MenuDrawer(
        currentPage: PageUtils.PERSONAL_INFO_TITLE,
        user: user,
      ),
      body: Container(
        padding: PageUtils.BODY_PADDING,
        child: FutureBuilder(
          future: FirestoreDB.db_users.doc(user.id).get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return ErrorView();
                break;
              case ConnectionState.waiting:
                return LoadingView();
                break;
              case ConnectionState.done:
                var json = snapshot.data.data();
                User loadedUser = User.fromJson(json);
                loadedUser.id = snapshot.data.id;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    personalInfoAttribute(NAME_FIELD, loadedUser.name),
                    sizedBox,
                    personalInfoAttribute(EMAIL_FIELD, loadedUser.email),
                    PageUtils.HORIZONTAL_SEPARATOR_GREY,
                    InkWell(
                      onTap: () =>
                          pushToPersonalInfoFormView(context, loadedUser),
                      child: Text(
                        'Editar informações pessoais',
                        style: PageUtils.textButtonStyle,
                      ),
                    ),
                    sizedBox,
                    InkWell(
                      onTap: () => pushToPersonalInfoPasswordFormView(context),
                      child: Text(
                        'Alterar senha',
                        style: PageUtils.textButtonStyle,
                      ),
                    ),
                  ],
                );
                break;
              default:
                return Container();
            }
          },
        ),
      ),
    );
  }

  void pushToPersonalInfoFormView(BuildContext context, User user) =>
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => PersonalInfoFormView(
                    user: user,
                  )));

  void pushToPersonalInfoPasswordFormView(BuildContext context) =>
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => PersonalInfoPasswordFormView()));

  Widget sizedBox = SizedBox(
    height: 12,
  );

  Widget personalInfoAttribute(String label, String value) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 8.0,
          ),
          Text(
            value,
            style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[800],
                fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
}
