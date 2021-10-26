import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tirol_office_app/models/unit.dart';
import 'package:tirol_office_app/service/unit_service.dart';
import 'package:tirol_office_app/service/user_service.dart';
import 'package:tirol_office_app/utils/page_utils.dart';
import 'package:tirol_office_app/utils/route_utils.dart';
import 'package:tirol_office_app/views/screens/departments/department_list_view.dart';
import 'package:tirol_office_app/views/widgets/dialogs.dart';
import 'package:tirol_office_app/views/widgets/menu_drawer.dart';

import '../error_view.dart';
import '../loading_view.dart';
import 'unit_form_view.dart';

class UnitListView extends StatefulWidget {
  const UnitListView({Key key}) : super(key: key);
  @override
  _UnitListViewState createState() => _UnitListViewState();
}

class _UnitListViewState extends State<UnitListView> {
  UnitService _service = UnitService();
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
      body: Container(
        padding: PageUtils.BODY_PADDING,
        child: FutureBuilder(
          future: UnitService.getUnits(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            Widget page;
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                page = LoadingView();
                break;
              case ConnectionState.active:
                page = Container();
                break;
              case ConnectionState.done:
                page = getPageOnConnectionStateDone(snapshot);
                break;
              default:
                page = ErrorView();
            }
            return page;
          },
        ),
      ),
    );
  }

  superSetState() {
    setState(() {});
  }

  getPageOnConnectionStateDone(AsyncSnapshot<QuerySnapshot> snapshot) {
    Widget page;
    if (snapshot.data.docs.isEmpty) {
      page = PageUtils.getNoContent(blackFont: true);
    } else {
      page = ListView.builder(
          itemCount: snapshot.data.size,
          itemBuilder: (context, index) {
            var doc = snapshot.data.docs[index];
            Unit unit = Unit.fromJson(doc.data());
            unit.id = doc.id;
            return InkWell(
              onDoubleTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => UnitFormView(unit: unit, edit: true),
                ),
              ),
              onLongPress: () => Dialogs.showDeleteDialog(
                  context, _service.remove, superSetState, unit.id),
              child: ListTile(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            DepartmentListView(unitName: unit.name))),
                title: Text('${unit.name}'),
                subtitle:
                    Text('${unit.address}, ${unit.number}, ${unit.district}'),
                contentPadding: EdgeInsets.all(0),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                ),
              ),
            );
          });
    }
    return page;
  }
}
