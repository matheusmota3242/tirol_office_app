import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tirol_office_app/service/unit_service.dart';
import 'package:tirol_office_app/service/user_service.dart';
import 'package:tirol_office_app/utils/page_utils.dart';
import 'package:tirol_office_app/utils/route_utils.dart';
import 'package:tirol_office_app/views/widgets/menu_drawer.dart';

import '../loading_view.dart';

class UnitListView extends StatelessWidget {
  const UnitListView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Unidades'), actions: [
        IconButton(
          onPressed: () => RouteUtils.pushToUnitFormView(context),
          icon: Icon(Icons.add),
        )
      ]),
      drawer: MenuDrawer(
        currentPage: PageUtils.UNITS_TITLE,
        user: Provider.of<UserService>(context).getUser,
      ),
      body: FutureBuilder(
        future: UnitService.getUnits(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          Widget page;
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              page = LoadingView();
              break;
            case ConnectionState.active:
              page = Container();
              break;
            case ConnectionState.done:
              page = Container();
              break;
            default:
          }
          return page;
        },
      ),
    );
  }
}
