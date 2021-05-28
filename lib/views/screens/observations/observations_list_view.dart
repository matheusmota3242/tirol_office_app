import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tirol_office_app/helpers/page_helper.dart';
import 'package:tirol_office_app/models/user_model.dart';
import 'package:tirol_office_app/service/user_service.dart';
import 'package:tirol_office_app/views/widgets/menu_drawer.dart';

class ObservationListView extends StatefulWidget {
  @override
  _ObservationListViewState createState() => _ObservationListViewState();
}

class _ObservationListViewState extends State<ObservationListView> {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserService>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        title: Text(PageHelper.observations),
        actions: [
          Visibility(
            visible: user.role == 'Administrador' ? true : false,
            child: IconButton(
              icon: Icon(Icons.add),
              onPressed: () => null,
            ),
          )
        ],
      ),
      drawer: MenuDrawer(
        user: user,
        currentPage: PageHelper.observations,
      ),
    );
  }
}
