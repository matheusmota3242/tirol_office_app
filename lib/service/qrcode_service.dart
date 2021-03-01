import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:tirol_office_app/db/firestore.dart';
import 'package:tirol_office_app/models/process_model.dart';
import 'package:tirol_office_app/views/widgets/dialogs.dart';

class QRCodeService {
  // Método que escaneia o QRCode
  void scanQRCode(BuildContext context, String username) async {
    String response = await FlutterBarcodeScanner.scanBarcode(
        '#FF0000', "Cancelar", true, ScanMode.QR);

    if (response == '-1') {
      // Caso o leitor não reconheça o código QR...
      Dialogs().showScannerErrorDialog(context);
    } else {
      // Caso reconheça como um código QR válido...
      Dialogs().showCheckinDialog(context, response, username);
    }
  }

  // Método que salva o processo no banco de dados
  void save(String response, String username) {
    Process process = Process();
    process.setDepartmentId = response;
    process.setStart = DateTime.now();
    process.setResponsible = username;
    FirestoreDB()
        .db_processes
        .doc(process.getDepartmentId)
        .get()
        .then((snapshot) {
      if (!snapshot.exists) {
        FirestoreDB()
            .db_processes
            .doc(process.getDepartmentId)
            .set(process.toJson());
      } else {
        process.setEnd = DateTime.now();
        FirestoreDB()
            .db_processes
            .doc(process.getDepartmentId)
            .update({'end': process.getEnd});
      }
    });
  }
}
