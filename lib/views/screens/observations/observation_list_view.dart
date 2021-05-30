import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tirol_office_app/db/firestore.dart';
import 'package:tirol_office_app/helpers/page_helper.dart';
import 'package:tirol_office_app/helpers/route_helper.dart';
import 'package:tirol_office_app/models/observation_model.dart';
import 'package:tirol_office_app/models/user_model.dart';
import 'package:tirol_office_app/service/user_service.dart';
import 'package:tirol_office_app/views/screens/empty_view.dart';
import 'package:tirol_office_app/views/screens/error_view.dart';
import 'package:tirol_office_app/views/screens/loading_view.dart';
import 'package:tirol_office_app/views/screens/observations/observation_form_view.dart';
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
                onPressed: () => pushToObservationFormView(context),
              ),
            )
          ],
        ),
        drawer: MenuDrawer(
          user: user,
          currentPage: PageHelper.observations,
        ),
        body: StreamBuilder(
          stream: FirestoreDB().db_observations.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return LoadingView();

                break;
              case ConnectionState.none:
                return ErrorView();
                break;
              case ConnectionState.done:
                return null;
                break;
              case ConnectionState.active:
                var docs = snapshot.data.docs;
                if (!snapshot.hasData || docs.length == 0) return EmptyView();

                if (snapshot.hasError) return ErrorView();

                return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (_, index) {
                      Observation observation =
                          Observation.fromJson(docs[index].data());
                      observation.id = docs[index].id;
                      return Text(observation.title);
                    });
            }
            return LoadingView();
          },
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
}
