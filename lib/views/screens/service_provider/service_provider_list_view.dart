import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tirol_office_app/db/firestore.dart';
import 'package:tirol_office_app/helpers/page_helper.dart';
import 'package:tirol_office_app/helpers/route_helper.dart';
import 'package:tirol_office_app/views/screens/empty_view.dart';
import 'package:tirol_office_app/views/screens/error_view.dart';
import 'package:tirol_office_app/views/screens/loading_view.dart';
import 'package:tirol_office_app/views/widgets/appbar.dart';

class ServiceProviderListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(PageHelper.services),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => pushToServiceProvidersFormView(context),
          )
        ],
      ),
      body: StreamBuilder(
          stream: FirestoreDB().db_service_providers.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return LoadingView();

                break;
              case ConnectionState.active:
                if (!snapshot.hasData) return EmptyView();

                if (snapshot.hasError) return ErrorView();

                return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      String name = snapshot.data.docs[index]['name'];
                      String email = snapshot.data.docs[index]['email'];
                      String phone = snapshot.data.docs[index]['phone'];
                      String category = snapshot.data.docs[index]['category'];
                      return ListTile(
                        //isThreeLine: true,
                        leading: Icon(Icons.person),
                        title: Text(name),
                        subtitle: Text(category),
                      );
                    });
              case ConnectionState.none:
                return ErrorView();
                break;
              case ConnectionState.done:
                return null;
                break;
            }
            return LoadingView();
          }),
    );
  }

  Widget setBody(BuildContext context) {}

  void pushToServiceProvidersFormView(BuildContext context) {
    Navigator.pushNamed(context, RouteHelper.serviceProvidersForm);
  }
}
