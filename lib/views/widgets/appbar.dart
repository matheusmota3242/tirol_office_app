import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tirol_office_app/auth/auth_service.dart';
import 'package:tirol_office_app/service/process_service.dart';
import 'package:tirol_office_app/service/user_service.dart';
import 'package:tirol_office_app/views/widgets/dialogs.dart';

class AppBarWidget extends PreferredSize {
  final String title;
  ProcessService _ProcessService = ProcessService();

  AppBarWidget(this.title);

  @override
  Size get preferredSize => AppBar().preferredSize;

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserService>(context).getUser;
    var _processService = Provider.of<ProcessService>(context, listen: false);

    showFilterDialog() async {
      var picked = await Dialogs().showProcessFilterDialog(context);
      var querySnapshot = await _processService.queryByDate(picked);
      print(querySnapshot.docs);
    }

    return AppBar(
      //automaticallyImplyLeading: false,>
      title: Text(this.title),
      backgroundColor: Theme.of(context).buttonColor,
      shadowColor: Colors.transparent,
      actions: [
        IconButton(
          icon: Icon(Icons.date_range),
          onPressed: () => showFilterDialog(),
        ),
        IconButton(
          icon: Icon(Icons.qr_code),
          onPressed: () => _processService.scanQRCode(context, user.name),
        ),
      ],
    );
  }
}
