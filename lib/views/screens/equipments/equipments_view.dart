import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tirol_office_app/service/user_service.dart';

import 'package:tirol_office_app/utils/page_utils.dart';
import 'package:tirol_office_app/views/widgets/menu_drawer.dart';

class EquipmentsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(PageUtils.EQUIPMENTS_TITLE),
        ),
        drawer: MenuDrawer(
          currentPage: PageUtils.EQUIPMENTS_TITLE,
          user: Provider.of<UserService>(context).getUser,
        ));
  }
}
