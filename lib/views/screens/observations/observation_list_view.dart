import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'package:tirol_office_app/db/firestore.dart';
import 'package:tirol_office_app/mobx/picked_date_mobx.dart';
import 'package:tirol_office_app/models/observation_model.dart';
import 'package:tirol_office_app/models/user_model.dart';
import 'package:tirol_office_app/service/observation_service.dart';
import 'package:tirol_office_app/service/user_service.dart';
import 'package:tirol_office_app/utils/page_utils.dart';
import 'package:tirol_office_app/views/screens/empty_view.dart';
import 'package:tirol_office_app/views/screens/error_view.dart';
import 'package:tirol_office_app/views/screens/loading_view.dart';
import 'package:tirol_office_app/views/screens/observations/observation_details_view.dart';
import 'package:tirol_office_app/views/screens/observations/observation_form_view.dart';
import 'package:tirol_office_app/views/widgets/dialogs.dart';
import 'package:tirol_office_app/views/widgets/menu_drawer.dart';
import 'package:tirol_office_app/views/widgets/toast.dart';
import 'package:tirol_office_app/helpers/datetime_helper.dart';

class ObservationListView extends StatefulWidget {
  @override
  _ObservationListViewState createState() => _ObservationListViewState();
}

class _ObservationListViewState extends State<ObservationListView> {
  ObservationService _service = ObservationService();
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserService>(context).getUser;
    var themeData = Theme.of(context);
    PickedDateMobx pickedDateMobx = PickedDateMobx();
    showFilterDialog(BuildContext context) async {
      var pickedTimestamp = await Dialogs().showProcessFilterDialog(context);
      if (pickedTimestamp != null) pickedDateMobx.setPicked(pickedTimestamp);
    }

    return Scaffold(
        backgroundColor: themeData.backgroundColor,
        appBar: AppBar(
          title: Text(PageUtils.observations),
          shadowColor: Colors.transparent,
          actions: [
            IconButton(
              icon: Icon(Icons.date_range),
              onPressed: () => showFilterDialog(context),
            ),
            Visibility(
              visible: user.role == 'Administrador' ? true : false,
              child: IconButton(
                icon: Icon(Icons.add),
                onPressed: () => pushToObservationFormView(context),
              ),
            )
          ],
        ),
        drawer: MenuDrawer(
          user: user,
          currentPage: PageUtils.observations,
        ),
        body: Observer(
          builder: (_) => FutureBuilder(
            future: _service.queryByDate(pickedDateMobx.getPicked),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return LoadingView();

                  break;
                case ConnectionState.none:
                  return ErrorView();
                  break;
                case ConnectionState.active:
                  return Container();
                  break;
                case ConnectionState.done:
                  var docs = snapshot.data.docs;
                  if (!snapshot.hasData || docs.length == 0)
                    return Stack(
                      children: [
                        Positioned(
                          top: 6.0,
                          left: 14.0,
                          child: Text(
                            '${DateTimeHelper.convertIntToStringWeekday(pickedDateMobx.getPicked.weekday)}, ${pickedDateMobx.getPicked.day} de ${DateTimeHelper.convertIntToStringMonth(pickedDateMobx.getPicked.month)} de ${pickedDateMobx.getPicked.year}',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Não há itens cadastrados.',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                        )
                      ],
                    );
                  // return Column(
                  //   children: [
                  //     Text(
                  //       '${DateTimeHelper().convertIntToStringWeekday(pickedDateMobx.getPicked.weekday)}, ${pickedDateMobx.getPicked.day} de ${DateTimeHelper().convertIntToStringMonth(pickedDateMobx.getPicked.month)} de ${pickedDateMobx.getPicked.year}',
                  //       style: TextStyle(
                  //           color: Colors.white,
                  //           fontSize: 20,
                  //           fontWeight: FontWeight.w700),
                  //     ),
                  //     Container(
                  //       alignment: Alignment.center,
                  //       child: Text('testando'),
                  //     ),
                  //   ],
                  // );

                  if (snapshot.hasError) return ErrorView();

                  return Container(
                    padding: const EdgeInsets.all(PageUtils.bodyPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${DateTimeHelper.convertIntToStringWeekday(pickedDateMobx.getPicked.weekday)}, ${pickedDateMobx.getPicked.day} de ${DateTimeHelper.convertIntToStringMonth(pickedDateMobx.getPicked.month)} de ${pickedDateMobx.getPicked.year}',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          child: ListView.builder(
                              itemCount: docs.length,
                              itemBuilder: (_, index) {
                                Observation observation =
                                    Observation.fromJson(docs[index].data());
                                observation.id = docs[index].id;
                                return Card(
                                  margin: EdgeInsets.all(0),
                                  child: Container(
                                      height: 133,
                                      padding: EdgeInsets.only(
                                          left: PageUtils.bodyPadding,
                                          bottom: PageUtils.bodyPadding),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              GestureDetector(
                                                onTap: () => Navigator.push(
                                                    _,
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            ObservationDetailsView(
                                                              observation:
                                                                  observation,
                                                            ))),
                                                child: Text(
                                                  observation.title,
                                                  style: themeData
                                                      .textTheme.headline5,
                                                ),
                                              ),
                                              PopupMenuButton(
                                                  onSelected: (value) =>
                                                      handleChoice(context,
                                                          value, observation),
                                                  itemBuilder: (_) => [
                                                        'Editar',
                                                        'Remover'
                                                      ]
                                                          .map((choice) =>
                                                              PopupMenuItem(
                                                                child: Text(
                                                                    choice),
                                                                value: choice,
                                                              ))
                                                          .toList())
                                            ],
                                          ),
                                          Text(
                                            observation.author,
                                            style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 14),
                                          ),
                                          SizedBox(height: 14),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Flexible(
                                                child: Container(
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Flexible(
                                                        child: Container(
                                                          child: Text(
                                                            observation.content,
                                                            style: TextStyle(
                                                                fontSize: 15),
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 12.0,
                                              )
                                            ],
                                          ),
                                        ],
                                      )),
                                );
                              }),
                        ),
                      ],
                    ),
                  );
              }
              return LoadingView();
            },
          ),
        ));
  }

  pushToObservationFormView(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ObservationFormView(
          edit: false,
          observation: Observation(),
        ),
      ),
    );
  }

  pushToObservationEditView(BuildContext context, Observation observation) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ObservationFormView(
          edit: true,
          observation: observation,
        ),
      ),
    );
  }

  void remove(String id) {
    _service.remove(id);
    Toasts.showToast(content: 'Conteúdo removido com sucesso');
  }

  void handleChoice(
      BuildContext context, String choice, Observation observation) {
    switch (choice) {
      case 'Editar':
        pushToObservationEditView(context, observation);
        break;
      case 'Remover':
        remove(observation.id);
        break;
      default:
    }
  }
}
