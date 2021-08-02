import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tirol_office_app/models/maintenance_model.dart';
import 'package:tirol_office_app/service/maintenance_service.dart';
import 'package:tirol_office_app/service/user_service.dart';
import 'package:tirol_office_app/utils/datetime_utils.dart';
import 'package:tirol_office_app/utils/page_utils.dart';
import 'package:tirol_office_app/views/screens/loading_view.dart';
import 'package:tirol_office_app/views/widgets/menu_drawer.dart';

class MaintenancesView extends StatefulWidget {
  @override
  _MaintenancesViewState createState() => _MaintenancesViewState();
}

class _MaintenancesViewState extends State<MaintenancesView> {
  MaintenanceService _service = MaintenanceService();
  String dropdownValue = 'Remover';

  @override
  Widget build(BuildContext context) {
    delete(String maintenanceId) async {
      await _service.delete(maintenanceId);
    }

    showDeleteDialog(Maintenance maintenance) {
      showDialog(
        context: context,
        builder: (_) => StatefulBuilder(
            builder: (BuildContext localContext, innerSetState) {
          return AlertDialog(
            title: Text(
              'Remover',
              style: TextStyle(color: Colors.red[500]),
            ),
            content: Text('Você realmente deseja remover esse item?'),
            actions: [
              Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancelar'),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        delete(maintenance.id);
                        Navigator.pop(localContext);
                        setState(() {});
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).buttonColor),
                      ),
                      child: Text('Sim'),
                    )
                  ],
                ),
              )
            ],
          );
        }),
      );
    }

    handlingOptionSelected(String value, Maintenance maintenance) async {
      if (value == 'Remover') {
        showDeleteDialog(maintenance);
      } else {
        await _service.updateHasOccured(maintenance);
        setState(() {});
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(PageUtils.MAINTENANCES_TITLE),
        shadowColor: Colors.transparent,
      ),
      drawer: MenuDrawer(
        user: Provider.of<UserService>(context).getUser,
        currentPage: PageUtils.MAINTENANCES_TITLE,
      ),
      backgroundColor: PageUtils.PRIMARY_COLOR,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(PageUtils.BODY_PADDING_VALUE,
            PageUtils.BODY_PADDING_VALUE, PageUtils.BODY_PADDING_VALUE, 0),
        child: FutureBuilder(
            future: MaintenanceService().getAll(),
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.active ||
                  snapshot.connectionState == ConnectionState.done) {
                /* Caso não exista conteudo */
                if (!snapshot.hasData || snapshot.data.docs.length == 0)
                  return Center(
                    child: Text(
                      'Não há itens cadastrados',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                  );
                /* Caso tenha conteúdo */
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (_, index) {
                      Maintenance maintenance = Maintenance.fromJson(
                          snapshot.data.docs[index].data());
                      maintenance.id = snapshot.data.docs[index].id;
                      return Card(
                        margin: EdgeInsets.only(
                            bottom: PageUtils.BODY_PADDING_VALUE),
                        child: Container(
                          padding: PageUtils.BODY_PADDING,
                          child: Stack(children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                PageUtils.getAttributeField(
                                    'Data',
                                    DateTimeUtils.toBRFormat(
                                        maintenance.dateTime)),
                                SizedBox(
                                  height: 24,
                                ),
                                PageUtils.getAttributeField('Equipamento',
                                    maintenance.equipmentDescription),
                                SizedBox(
                                  height: 24,
                                ),
                                PageUtils.getAttributeField(
                                    'Departamento', maintenance.departmentName),
                                SizedBox(
                                  height: 24,
                                ),
                                PageUtils.getAttributeField(
                                    'Provedor do serviço',
                                    maintenance.serviceProvider.name),
                                SizedBox(
                                  height: 24,
                                ),
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      'Status',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey[600]),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      maintenance.hasOccurred
                                          ? "Concluída"
                                          : "Aguardando",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w400,
                                          color: defineColorForStatus(
                                              maintenance)),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Positioned(
                                top: -10,
                                right: -12,
                                child: PopupMenuButton<String>(
                                    onSelected: (value) =>
                                        handlingOptionSelected(
                                            value, maintenance),
                                    icon: Icon(Icons.more_vert,
                                        color: Colors.black),
                                    itemBuilder: (context) =>
                                        defineOptionsForMaintenance(maintenance)
                                            .map((value) => PopupMenuItem(
                                                value: value,
                                                child: Text(value)))
                                            .toList()))
                          ]),
                        ),
                      );
                    });
              } else {
                return LoadingView(
                  background: PageUtils.PRIMARY_COLOR,
                );
              }
            }),
      ),
    );
  }

  Color defineColorForStatus(Maintenance maintenance) {
    Color color;
    if (DateTime.now().isAfter(maintenance.dateTime)) {
      if (maintenance.hasOccurred)
        color = Colors.green[700];
      else
        color = color = Colors.yellow[700];
    }
    return color;
  }

  List<String> defineOptionsForMaintenance(Maintenance maintenance) {
    var list = [dropdownValue];
    if (DateTime.now().isAfter(maintenance.dateTime)) {
      if (maintenance.hasOccurred)
        list.insert(0, "Desconcluir");
      else
        list.insert(0, "Concluir");
    }
    return list;
  }
}
