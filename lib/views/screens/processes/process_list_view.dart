import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import 'package:tirol_office_app/auth/auth_service.dart';
import 'package:tirol_office_app/db/firestore.dart';
import 'package:tirol_office_app/helpers/datetime_helper.dart';
import 'package:tirol_office_app/helpers/page_helper.dart';
import 'package:tirol_office_app/mobx/picked_date_mobx.dart';
import 'package:tirol_office_app/models/enums/user_role_enum.dart';
import 'package:tirol_office_app/models/process_model.dart';
import 'package:tirol_office_app/models/user_model.dart';
import 'package:tirol_office_app/service/process_service.dart';
import 'package:tirol_office_app/service/user_service.dart';
import 'package:tirol_office_app/views/screens/empty_view.dart';
import 'package:tirol_office_app/views/screens/error_view.dart';
import 'package:tirol_office_app/views/screens/loading_view.dart';
import 'package:tirol_office_app/views/screens/users/waiting_for_approval_view.dart';
import 'package:tirol_office_app/views/widgets/appbar.dart';
import 'package:tirol_office_app/views/widgets/dialogs.dart';
import 'package:tirol_office_app/views/widgets/menu_drawer.dart';
import 'package:tirol_office_app/views/widgets/process_card_item.dart';

class ProcessListView extends StatefulWidget {
  final String uid;

  const ProcessListView({Key key, this.uid}) : super(key: key);
  @override
  _ProcessListViewState createState() => _ProcessListViewState();
}

class _ProcessListViewState extends State<ProcessListView> {
  User user = User();
  bool loadingUser = false;
  @override
  void initState() {
    // TODO: implement initState
    _getUser();
    super.initState();
  }

  _getUser() async {
    setState(() {
      loadingUser = true;
    });
    user = await FirestoreDB().findById(widget.uid);
    setState(() {
      loadingUser = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    String title = PageHelper.processes;
    final _authService = Provider.of<AuthService>(context);
    Provider.of<UserService>(context).setUser(user);
    final _processService = ProcessService();
    PickedDateMobx pickedDateMobx = PickedDateMobx();
    final _processes = FirestoreDB().db_processes;

    showFilterDialog(BuildContext context) async {
      var pickedTimestamp = await Dialogs().showProcessFilterDialog(context);
      if (pickedTimestamp != null) pickedDateMobx.setPicked(pickedTimestamp);
    }

    return Builder(builder: (_) {
      if (loadingUser == false) {
        return Observer(
          builder: (_) => FutureBuilder(
              future: ProcessService().queryByDate(pickedDateMobx.getPicked),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Text('Ocorreu um erro');
                  case ConnectionState.waiting:
                    return LoadingView();

                    break;
                  default:
                    if (snapshot.hasError) {
                      return ErrorView();
                    }

                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        if (user.role ==
                            Role()
                                .getRoleByEnum(UserRole.WAITING_FOR_APPROVAL)) {
                          return WaitingForApprovalView();
                        } else if (user.role ==
                                Role().getRoleByEnum(UserRole.ADMIN) ||
                            user.role ==
                                Role().getRoleByEnum(UserRole.DEFAULT)) {
                          var _docs = snapshot.data.docs;
                          return Scaffold(
                            backgroundColor: Theme.of(context).buttonColor,
                            appBar: AppBar(
                              //automaticallyImplyLeading: false,>
                              title: Text(title),
                              //backgroundColor: Theme.of(context).buttonColor,
                              backgroundColor: Theme.of(context).buttonColor,
                              shadowColor: Colors.transparent,
                              actions: [
                                IconButton(
                                  icon: Icon(Icons.date_range),
                                  onPressed: () => showFilterDialog(context),
                                ),
                                IconButton(
                                  icon: Icon(Icons.qr_code),
                                  onPressed: () =>
                                      _processService.scanQRCode(context, null),
                                ),
                              ],
                            ),
                            drawer: MenuDrawer(
                              user: user,
                              currentPage: title,
                            ),
                            body: Padding(
                              padding:
                                  const EdgeInsets.all(PageHelper.bodyPadding),
                              child: Column(
                                  // color: Theme.of(context).buttonColor,
                                  // padding: EdgeInsets.all(16.0),
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        '${DateTimeHelper().convertIntToStringWeekday(pickedDateMobx.getPicked.weekday)}, ${pickedDateMobx.getPicked.day} de ${DateTimeHelper().convertIntToStringMonth(pickedDateMobx.getPicked.month)} de ${pickedDateMobx.getPicked.year}',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    _docs.isEmpty
                                        ? Padding(
                                            padding: EdgeInsets.only(
                                                top: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    4),
                                            child: EmptyView(),
                                          )
                                        : Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 16.0),
                                              child: ListView.builder(
                                                itemCount: _docs.length,
                                                itemBuilder: (context, index) {
                                                  var doc = _docs[index].data();
                                                  Process process =
                                                      Process.fromJson(doc);
                                                  process.setId =
                                                      _docs[index].id;
                                                  return ProcessCardItem(
                                                    process: process,
                                                    isProcessDetailsView: false,
                                                    isLastItem: index ==
                                                            (_docs.length - 1)
                                                        ? true
                                                        : false,
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                  ]),
                            ),
                          );
                        } else {
                          return ErrorView();
                        }
                      } else {
                        return ErrorView();
                      }
                    }
                    return LoadingView();
                }
              }),
        );
      } else {
        return LoadingView();
      }
    });
  }
}
