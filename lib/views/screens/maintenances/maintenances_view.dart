import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tirol_office_app/service/maintenance_service.dart';
import 'package:tirol_office_app/service/user_service.dart';
import 'package:tirol_office_app/utils/page_utils.dart';
import 'package:tirol_office_app/views/screens/loading_view.dart';
import 'package:tirol_office_app/views/widgets/menu_drawer.dart';

class MaintenancesView extends StatefulWidget {
  @override
  _MaintenancesViewState createState() => _MaintenancesViewState();
}

class _MaintenancesViewState extends State<MaintenancesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(PageUtils.MAINTENANCES_TITLE)),
        drawer: MenuDrawer(
          user: Provider.of<UserService>(context).getUser,
          currentPage: PageUtils.MAINTENANCES_TITLE,
        ),
        body: FutureBuilder(
            future: MaintenanceService().getAll(),
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.active ||
                  snapshot.connectionState == ConnectionState.done) {
                return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (_, index) {
                      return Text(index.toString());
                    });
              } else {
                return Text('Vazio');
              }
            }));
  }
}
