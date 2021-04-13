import 'package:cloud_firestore/cloud_firestore.dart';
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
  DateTime picked;

  ProcessService() {
    picked = DateTime.now();
  }

  // Método que escaneia o QRCode
  void scanQRCode(BuildContext context, String username) async {
    String response = await FlutterBarcodeScanner.scanBarcode(
        '#FF0000', "Cancelar", true, ScanMode.QR);

    if (response == '-1') {
      // Caso o leitor não reconheça o código QR...
      Toasts.showToast(content: 'Código inválido');
    } else {
      // Caso reconheça como um código QR válido...

      var doc = await FirestoreDB()
          .db_departments
          .where('name', isEqualTo: response)
          .get();

      if (doc.size > 0) {
        // Caso o departamento lido exista
        var department = Department.fromJson(doc.docs[0].data());
        Provider.of<DepartmentService>(context, listen: false)
            .setCurrentDepartment(department);
        Dialogs().showCheckinDialog(context, response, username);
      } else
        Toasts.showToast(content: 'Departamento não existe');
    }
  }

  // Método que salva o processo no banco de dados
  void save(String response, String username, String userId) async {
    Process process = Process();
    var now = DateTime.now();
    process.setUserId = userId;
    process.setDepartmentId = response;
    process.setStart = now;
    process.setResponsible = username;
    currentProcess = Process();
    currentProcess = process;
    FirestoreDB()
        .db_processes
        .doc(process.getDepartmentId)
        .get()
        .then((snapshot) {
      // Caso o processo não exista no banco...
      if (!snapshot.exists) {
        FirestoreDB().db_processes.add(process.toJson());
      } else {
        print(snapshot.data());
        process.setEnd = DateTime.now();
        currentProcess.setEnd = process.getEnd;
        FirestoreDB()
            .db_processes
            .doc(process.getDepartmentId)
            .update({'end': process.getEnd});
      }
    });
  }

  pickDate(BuildContext context) async {
    return await showDatePicker(
        context: context,
        initialDate: picked,
        firstDate: DateTime(2020),
        lastDate: DateTime(2050));
  }

  // Future<QuerySnapshot> list() async {
  //   DateTime pickedStart =
  //       DateTime(picked.year, picked.month, picked.day, 0, 1);
  //   DateTime pickedEnd =
  //       DateTime(picked.year, picked.month, picked.day, 23, 59);

  //   return await FirestoreDB()
  //       .db_processes
  //       .where('start', isLessThanOrEqualTo: Timestamp.fromDate(pickedEnd))
  //       .where('start', isGreaterThanOrEqualTo: Timestamp.fromDate(pickedStart))
  //       .get();
  // }
  Future<QuerySnapshot> queryByDate(DateTime picked) async {
    picked = DateTime(picked.year, picked.month, picked.day, 12, 00);
    DateTime pickedStart =
        DateTime(picked.year, picked.month, picked.day, 0, 00);
    DateTime pickedEnd =
        DateTime(picked.year, picked.month, picked.day, 23, 59);
    print(picked);
    return await FirestoreDB()
        .db_processes
        .where('start', isGreaterThanOrEqualTo: Timestamp.fromDate(pickedStart))
        .where('start', isLessThanOrEqualTo: Timestamp.fromDate(pickedEnd))
        .get();
  }
}
