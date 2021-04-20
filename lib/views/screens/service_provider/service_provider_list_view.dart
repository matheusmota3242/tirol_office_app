import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tirol_office_app/db/firestore.dart';
import 'package:tirol_office_app/helpers/page_helper.dart';
import 'package:tirol_office_app/helpers/route_helper.dart';
import 'package:tirol_office_app/models/service_provider_model.dart';
import 'package:tirol_office_app/service/service_provider_service.dart';
import 'package:tirol_office_app/views/screens/empty_view.dart';
import 'package:tirol_office_app/views/screens/error_view.dart';
import 'package:tirol_office_app/views/screens/loading_view.dart';
import 'package:tirol_office_app/views/screens/service_provider/service_provider_form_view.dart';
import 'package:tirol_office_app/views/screens/service_provider/service_provider_view.dart';
import 'package:tirol_office_app/views/widgets/appbar.dart';
import 'package:tirol_office_app/views/widgets/toast.dart';

class ServiceProviderListView extends StatelessWidget {
  ServiceProviderService _service = ServiceProviderService();
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
                      // String name = snapshot.data.docs[index]['name'];
                      // String email = snapshot.data.docs[index]['email'];
                      // String phone = snapshot.data.docs[index]['phone'];
                      // String category = snapshot.data.docs[index]['category'];
                      ServiceProvider serviceProvider =
                          ServiceProvider.fromJson(
                              snapshot.data.docs[index].data());
                      serviceProvider.id = snapshot.data.docs[index].id;

                      return ListTile(
                        //isThreeLine: true,
                        leading: Icon(Icons.person),
                        title: GestureDetector(
                          onTap: () => _pushToServiceProviderView(
                              context, serviceProvider),
                          child: Text(serviceProvider.name),
                        ),
                        subtitle: Text(serviceProvider.category),

                        trailing: PopupMenuButton<String>(
                          itemBuilder: (_) => [
                            PopupMenuItem(
                              value: 'Editar',
                              child: Text('Editar'),
                            ),
                            PopupMenuItem(
                              value: 'Remover',
                              child: Text('Remover'),
                            ),
                          ],
                          onSelected: (value) =>
                              _handleChoice(context, value, serviceProvider),
                          icon: Icon(Icons.more_vert),
                        ),
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

  _pushToServiceProviderView(
      BuildContext context, ServiceProvider serviceProvider) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ServiceProviderView(
                  serviceProvider: serviceProvider,
                )));
  }

  _handleChoice(
      BuildContext context, String choice, ServiceProvider serviceProvider) {
    switch (choice) {
      case 'Editar':
        _service.edit(context, serviceProvider);
        break;
      case 'Remover':
        _service.remove(serviceProvider.id);
        Toasts.showToast(content: 'Serviço removido com sucesso');
        break;
      default:
    }
  }

  Widget setBody(BuildContext context) {}

  void pushToServiceProvidersFormView(BuildContext context) {
    ServiceProvider serviceProvider = ServiceProvider();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ServiceProviderFormView(
                  serviceProvider: serviceProvider,
                )));
  }
}
