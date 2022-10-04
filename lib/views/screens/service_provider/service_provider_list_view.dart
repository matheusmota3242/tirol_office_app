import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tirol_office_app/db/firestore.dart';
import 'package:tirol_office_app/models/service_provider_model.dart';
import 'package:tirol_office_app/models/user_model.dart';
import 'package:tirol_office_app/service/service_provider_service.dart';
import 'package:tirol_office_app/service/user_service.dart';
import 'package:tirol_office_app/utils/page_utils.dart';
import 'package:tirol_office_app/views/screens/error_view.dart';
import 'package:tirol_office_app/views/screens/loading_view.dart';
import 'package:tirol_office_app/views/screens/service_provider/service_provider_form_view.dart';
import 'package:tirol_office_app/views/screens/service_provider/service_provider_view.dart';
import 'package:tirol_office_app/views/widgets/dialogs.dart';
import 'package:tirol_office_app/views/widgets/menu_drawer.dart';

class ServiceProviderListView extends StatefulWidget {
  _ServiceProviderListViewState createState() =>
      _ServiceProviderListViewState();
}

class _ServiceProviderListViewState extends State<ServiceProviderListView> {
  ServiceProviderService _service = ServiceProviderService();

  void pushToServiceProvidersFormView(
      BuildContext context, ServiceProvider serviceProvider, bool edit) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ServiceProviderFormView(
          serviceProvider: serviceProvider,
          edit: edit,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserService>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(PageUtils.SERVICES_TITLE),
        actions: [
          Visibility(
            visible: user.role == 'Administrador',
            child: IconButton(
              icon: Icon(Icons.add),
              onPressed: () => pushToServiceProvidersFormView(
                  context, ServiceProvider(), false),
            ),
          )
        ],
      ),
      drawer: MenuDrawer(
        user: user,
        currentPage: PageUtils.SERVICE_PROVIDER_TITLE,
      ),
      body: StreamBuilder(
          stream: FirestoreDB.dbServiceProviders.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return LoadingView();

                break;
              case ConnectionState.active:
                if (!snapshot.hasData || snapshot.data.docs.length == 0)
                  return Container(
                    color: Colors.white,
                    child: Center(
                      child: Text(
                        'Não há itens cadastrados.',
                        style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  );

                if (snapshot.hasError) return ErrorView();

                return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      ServiceProvider serviceProvider =
                          ServiceProvider.fromJson(
                              snapshot.data.docs[index].data());
                      serviceProvider.id = snapshot.data.docs[index].id;

                      return InkWell(
                        onLongPress: () async => Dialogs.showDeleteDialog(
                            context,
                            _service.remove,
                            setState,
                            serviceProvider.id),
                        onDoubleTap: () => pushToServiceProvidersFormView(
                            context, serviceProvider, true),
                        onTap: () => _pushToServiceProviderView(
                            context, serviceProvider),
                        child: ListTile(
                          //isThreeLine: true,
                          leading: Icon(Icons.person),
                          title: Text(serviceProvider.name),

                          subtitle: Text(serviceProvider.category),

                          // trailing: Visibility(
                          //   visible:
                          //       Provider.of<UserService>(context).getUser.role ==
                          //               'Administrador'
                          //           ? true
                          //           : false,
                          //   child: PopupMenuButton<String>(
                          //     itemBuilder: (_) => [
                          //       PopupMenuItem(
                          //         value: 'Editar',
                          //         child: Text('Editar'),
                          //       ),
                          //       PopupMenuItem(
                          //         value: 'Remover',
                          //         child: Text('Remover'),
                          //       ),
                          //     ],
                          //     onSelected: (value) =>
                          //         _handleChoice(context, value, serviceProvider),
                          //     icon: Icon(Icons.more_vert),
                          //   ),
                          // ),
                        ),
                      );
                    });
              case ConnectionState.none:
                return ErrorView();
                break;
              case ConnectionState.done:
                return Text('dksdjskl');
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
}
