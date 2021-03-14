import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import 'package:tirol_office_app/db/firestore.dart';
import 'package:tirol_office_app/helpers/datetime_helper.dart';
import 'package:tirol_office_app/helpers/route_helper.dart';
import 'package:tirol_office_app/models/department_model.dart';
import 'package:tirol_office_app/models/process_model.dart';
import 'package:tirol_office_app/service/department_service.dart';
import 'package:tirol_office_app/views/widgets/dialogs.dart';
import 'package:tirol_office_app/views/widgets/toast.dart';

class ProcessService {
  Process currentProcess;

  // Método que escaneia o QRCode
  void scanQRCode(BuildContext context, String username) async {
    String response = await FlutterBarcodeScanner.scanBarcode(
        '#FF0000', "Cancelar", true, ScanMode.QR);

    if (response == '-1') {
      // Caso o leitor não reconheça o código QR...
      Toasts.showToast(content: 'Código inválido');
    } else {
      // Caso reconheça como um código QR válido...

      var doc = await FirestoreDB().db_departments.doc(response).get();

      if (doc.exists) {
        var department = Department.fromJson(doc.data());
        Provider.of<DepartmentService>(context, listen: false)
            .setCurrentDepartment(department);
        Dialogs().showCheckinDialog(context, response, username);
      } else
        Toasts.showToast(content: 'Departamento não existe');
    }
  }

  // Método que salva o processo no banco de dados
  void save(String response, String username) async {
    Process process = Process();
    var now = DateTime.now();
    process.setDepartmentId =
        response + DateTimeHelper().generateProcessDateForId(now);
    process.setStart = now;
    process.setResponsible = username;
    currentProcess = Process();
    currentProcess = process;
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
        currentProcess.setEnd = process.getEnd;
        FirestoreDB()
            .db_processes
            .doc(process.getDepartmentId)
            .update({'end': process.getEnd});
      }
    });
  }
}
