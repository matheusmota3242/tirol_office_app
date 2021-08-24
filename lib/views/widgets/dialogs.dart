import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tirol_office_app/auth/auth_service.dart';
import 'package:tirol_office_app/models/department_model.dart';
import 'package:tirol_office_app/models/process_model.dart';
import 'package:tirol_office_app/service/department_service.dart';
import 'package:tirol_office_app/service/process_service.dart';
import 'package:tirol_office_app/service/user_service.dart';
import 'package:tirol_office_app/utils/page_utils.dart';
import 'package:tirol_office_app/views/screens/processes/process_list_view.dart';

class Dialogs {
  static showDeleteDialog(
      BuildContext context, Function remove, Function setState, Object arg) {
    showDialog(
      context: context,
      builder: (_) =>
          StatefulBuilder(builder: (BuildContext localContext, innerSetState) {
        return AlertDialog(
          title: Text(
            'Remover',
            style: TextStyle(color: Colors.red[500]),
          ),
          content: Text('Você realmente deseja remover esse item?'),
          actions: [
            Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(localContext);
                    },
                    child: Text('Cancelar'),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      remove(arg);
                      Navigator.pop(localContext);
                      setState();
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

  // Filtra processos por data
  showProcessFilterDialog(BuildContext context) async {
    print('entrou no datepicker');
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime.now(),
        builder: (context, child) {
          return Theme(
              data: ThemeData.light().copyWith(
                primaryColor: Colors.red,
                accentColor: Colors.red,
                colorScheme:
                    ColorScheme.light(primary: const Color(0xFF166D97)),
              ),
              child: child);
        });
    return picked;
  }

  showPickDateDialog(BuildContext context) async {
    DateTime now = DateTime.now();
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: DateTime(now.year),
        lastDate: DateTime(now.year + 5),
        builder: (context, child) {
          return Theme(
              data: ThemeData.light().copyWith(
                primaryColor: Colors.red,
                accentColor: Colors.red,
                colorScheme:
                    ColorScheme.light(primary: const Color(0xFF166D97)),
              ),
              child: child);
        });
    return picked;
  }

  showScannerErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Erro na leitura'),
        content: const Text(
            'O leitor não identificou um código QR válido. Por favor, tente novamente.'),
        actions: [
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Ok'),
          )
        ],
      ),
    );
  }

  showFirstScanDialog(BuildContext context, String response,
      Department department, observations) {
    ProcessService processService =
        Provider.of<ProcessService>(context, listen: false);

    showDialog(
        context: context,
        builder: (_) =>
            StatefulBuilder(builder: (BuildContext context, setState) {
              return AlertDialog(
                title: const Text('Checkin'),
                content: Text(
                    'Deseja dar continuidade ao processo em ' + response + '?'),
                actions: [
                  Container(
                    padding: EdgeInsets.only(right: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          child: Text('Cancelar'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
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
            })).then((result) async {
      if (result) {
        if (department != null) DepartmentService().update(department);

        await processService.persist(
            response,
            department,
            Provider.of<UserService>(context, listen: false).getUser,
            observations);

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => ProcessListView()),
            (route) => false);
      }
    });
  }

  updateProcess(Process process, BuildContext context) async {
    ProcessService processService = ProcessService();
    bool result = await processService.update(process);
    if (result) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => ProcessListView()),
          (route) => false);
    }

    return result;
  }

  showFinalScanDialog(
      BuildContext context, String response, Process process) async {
    showDialog(
      context: context,
      builder: (_) =>
          StatefulBuilder(builder: (BuildContext localContext, setState) {
        return AlertDialog(
            title: Text('Checkout'),
            content: Text('Deseja finalizar o processo ' + response + '?'),
            actions: [
              Container(
                padding: EdgeInsets.only(right: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(localContext);
                      },
                      child: Text('Cancelar'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        updateProcess(process, context);
                        Navigator.of(localContext).pop();
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
            ]);
      }),
    );
  }

  static showErrorActualPassword(BuildContext context, String content) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext localContext, setState) => AlertDialog(
          title: Text('Ocorreu um erro'),
          content: Text(content),
          actions: [
            Container(
              padding: EdgeInsets.only(
                  right: PageUtils.alertDialogPaddingRB[0],
                  bottom: PageUtils.alertDialogPaddingRB[1]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(localContext),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white)),
                    child: Text(
                      'Ok',
                      style: TextStyle(color: Theme.of(context).buttonColor),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  showLogoutDialog(BuildContext globalContext) {
    showDialog(
        context: globalContext,
        builder: (_) =>
            StatefulBuilder(builder: (BuildContext context, setState) {
              return AlertDialog(
                title: const Text('Logout'),
                content: const Text('Tem certeza que deseja sair?'),
                actions: [
                  Container(
                    padding: EdgeInsets.only(
                        right: PageUtils.alertDialogPaddingRB[0],
                        bottom: PageUtils.alertDialogPaddingRB[1]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white)),
                          child: Text(
                            'Cancelar',
                            style:
                                TextStyle(color: Theme.of(context).buttonColor),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Provider.of<AuthService>(globalContext,
                                    listen: false)
                                .logout(globalContext);
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith((states) =>
                                      Theme.of(context).buttonColor)),
                          child: Text('Sim'),
                        )
                      ],
                    ),
                  )
                ],
              );
            }));
  }
}
