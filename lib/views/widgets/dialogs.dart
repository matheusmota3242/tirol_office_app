import 'package:flutter/material.dart';
import 'package:tirol_office_app/models/enums/user_role_enum.dart';
import 'package:tirol_office_app/service/qrcode_service.dart';

class Dialogs {
  showScannerErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      child: AlertDialog(
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
    showDialog(
      context: context,
      child: AlertDialog(
        title: Text('Checkin'),
        content: Text('Deseja realizar o checkin em ' + response + '?'),
        actions: [
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          FlatButton(
            onPressed: () {
              QRCodeService().save(response, username);
              Navigator.pop(context);
            },
            child: Text('Sim'),
          )
        ],
      ),
    );
  }
}
