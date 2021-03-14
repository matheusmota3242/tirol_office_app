import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tirol_office_app/auth/auth_service.dart';
import 'package:tirol_office_app/helpers/route_helper.dart';
import 'package:tirol_office_app/models/enums/user_role_enum.dart';
import 'package:tirol_office_app/models/process_model.dart';
import 'package:tirol_office_app/service/process_service.dart';
import 'package:tirol_office_app/views/widgets/toast.dart';

class Dialogs {
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

  showCheckinDialog(BuildContext context, String response, String username) {
    ProcessService processService =
        Provider.of<ProcessService>(context, listen: false);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Checkin'),
        content: Text('Deseja realizar o checkin em ' + response + '?'),
        actions: [
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          FlatButton(
            onPressed: () {
              processService.save(response, username);
              if (processService.currentProcess != null) {
                Navigator.popAndPushNamed(context, RouteHelper.processDetails);
              } else {
                Navigator.pop(context);
              }
            },
            child: Text('Sim'),
          )
        ],
      ),
    );
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
