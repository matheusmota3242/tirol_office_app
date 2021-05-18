import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tirol_office_app/auth/auth_service.dart';
import 'package:tirol_office_app/helpers/route_helper.dart';
import 'package:tirol_office_app/models/department_model.dart';
import 'package:tirol_office_app/models/enums/user_role_enum.dart';
import 'package:tirol_office_app/models/process_model.dart';
import 'package:tirol_office_app/service/department_service.dart';
import 'package:tirol_office_app/service/process_service.dart';
import 'package:tirol_office_app/service/user_service.dart';
import 'package:tirol_office_app/views/widgets/toast.dart';

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

        Navigator.popAndPushNamed(context, RouteHelper.processes);
      }
    });
  }

  showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Logout'),
        content: Text('Tem certeza que deseja sair?'),
        actions: [
          RaisedButton(
            onPressed: () => Navigator.pop(context),
            color: Colors.red,
            child: Text('Cancelar'),
          ),
          RaisedButton(
            onPressed: () {
              Provider.of<AuthService>(context, listen: false).logout(context);
            },
            child: Text('Sim'),
          )
        ],
      ),
    );
  }
}
