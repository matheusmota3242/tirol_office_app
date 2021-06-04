import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tirol_office_app/auth/auth_service.dart';
import 'package:tirol_office_app/utils/route_utils.dart';
import 'package:tirol_office_app/models/department_model.dart';
import 'package:tirol_office_app/service/department_service.dart';
import 'package:tirol_office_app/service/process_service.dart';
import 'package:tirol_office_app/service/user_service.dart';
import 'package:tirol_office_app/utils/page_utils.dart';

class Dialogs {
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
    print(picked);
    return picked;
  }

  showScannerErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Erro na leitura'),
        content: Text(
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

  showCheckinDialog(BuildContext context, String response,
      Department department, observations) {
    ProcessService processService =
        Provider.of<ProcessService>(context, listen: false);

    showDialog(
        context: context,
        builder: (_) =>
            StatefulBuilder(builder: (BuildContext context, setState) {
              return AlertDialog(
                title: Text('Checkin'),
                content: Text('Deseja realizar o checkin em ' + response + '?'),
                actions: [
                  Container(
                    padding: EdgeInsets.only(right: 5.0),
                    child: Row(
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
                            // if (processService.currentProcess != null &&
                            //     department == null) {
                            //   Navigator.popAndPushNamed(
                            //       context, RouteHelper.processDetails);
                            // } else {
                            //   Navigator.pop(context);
                            // }
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

        await processService.save(
            response,
            Provider.of<UserService>(context, listen: false).getUser,
            observations);

        Navigator.popAndPushNamed(context, RouteUtils.processes);
      }
    });
  }

  showLogoutDialog(BuildContext globalContext) {
    showDialog(
        context: globalContext,
        builder: (_) =>
            StatefulBuilder(builder: (BuildContext context, setState) {
              return AlertDialog(
                title: Text('Logout'),
                content: Text('Tem certeza que deseja sair?'),
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
