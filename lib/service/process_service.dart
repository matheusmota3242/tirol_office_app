import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'package:tirol_office_app/db/firestore.dart';
import 'package:tirol_office_app/helpers/datetime_helper.dart';
import 'package:tirol_office_app/models/department_model.dart';
import 'package:tirol_office_app/models/equipment_model.dart';
import 'package:tirol_office_app/models/process_model.dart';
import 'package:tirol_office_app/models/user_model.dart';
import 'package:tirol_office_app/views/widgets/dialogs.dart';
import 'package:tirol_office_app/views/widgets/toast.dart';

class ProcessService {
  Process currentProcess;
  DateTime picked;

  ProcessService() {
    picked = DateTime.now();
  }

  /* Método que escaneia o QRCode */
  Future<void> firstQRCodeScan(BuildContext context,
      [Department department, String observations]) async {
    String response = await FlutterBarcodeScanner.scanBarcode(
        '#FF0000', "Cancelar", true, ScanMode.QR);

    if (response == '-1') {
      /* Caso o leitor não reconheça o código QR... */
      Toasts.showToast(content: 'Código inválido');
    } else {
      /* Caso reconheça como um código QR válido... */
      await Dialogs()
          .showFirstScanDialog(context, response, department, observations);
    }
  }

  Future<void> finalQRCodeScan(BuildContext context, Process process) async {
    String response = await FlutterBarcodeScanner.scanBarcode(
        '#FF0000', "Cancelar", true, ScanMode.QR);

    if (response == process.getDepartment.name) {
      await Dialogs().showFinalScanDialog(context, response, process);
    } else {
      Toasts.showToast(content: 'Código diferente do esperado');
    }
  }

  Future<Process> create(
      Process process, User user, Department department) async {
    process.setStart = DateTime.now();
    process.setDepartment = department;
    process.setResponsible = user.name;
    process.setUserId = user.id;
    try {
      await FirestoreDB.dbProcesses.add(process.toJson());
      Toasts.showToast(content: 'Processo iniciado com sucesso');
    } catch (e) {
      Toasts.showToast(content: 'Ocorreu um erro');
    }
    return process;
  }

  add(String response, String observations, User user) async {
    Process process = Process();
    QuerySnapshot processSnapshot;
    QuerySnapshot departmentSnapshot;
    var now = DateTime.now();

    departmentSnapshot =
        await FirestoreDB.departments.where('name', isEqualTo: response).get();

    /* Caso o departamento não exista... */
    if (departmentSnapshot.docs.isEmpty) return null;

    Department department =
        Department.fromJson(departmentSnapshot.docs.first.data());

    process.setStart = now;
    process.department = department;
    process.setResponsible = user.name;
    process.setUserId = user.id;

    try {
      processSnapshot = await FirestoreDB.dbProcesses
          .where(
            'start',
            isGreaterThanOrEqualTo: Timestamp.fromDate(
              DateTimeHelper.convertToInitialDate(now),
            ),
          )
          .where(
            'start',
            isLessThanOrEqualTo: Timestamp.fromDate(
              DateTimeHelper.convertToEndDate(now),
            ),
          )
          .where('department.name', isEqualTo: response)
          .get();
    } catch (e) {
      Toasts.showWarningToast(content: 'Erro ao criar processo!');
      print("Error: $e");
    }

    if (processSnapshot.docs.isNotEmpty) {
      Toasts.showToast(content: 'Processo já em andamento');
    } else {
      try {
        await FirestoreDB.dbProcesses.add(process.toJson());
      } catch (e) {
        Toasts.showWarningToast(content: 'Erro ao criar processo!');
        print("Error: $e");
      }
    }
    return process;
  }

  // Método que salva o processo no banco de dados
  Future<Process> persist(String response, Department department, User user,
      String observations) async {
    var now = DateTime.now();
    QuerySnapshot processSnapshot;
    QuerySnapshot departmentSnapshot;
    Process process;

    if (department == null) {
      departmentSnapshot = await FirestoreDB.departments
          .where('name', isEqualTo: response)
          .get();

      department = Department.fromJson(departmentSnapshot.docs.first.data());
    }

    try {
      processSnapshot = await FirestoreDB.dbProcesses
          .where(
            'start',
            isGreaterThanOrEqualTo: Timestamp.fromDate(
              DateTimeHelper.convertToInitialDate(now),
            ),
          )
          .where(
            'start',
            isLessThanOrEqualTo: Timestamp.fromDate(
              DateTimeHelper.convertToEndDate(now),
            ),
          )
          .where('department.name', isEqualTo: response)
          .get();

      /* Verificando existencia do snapshot para o processo resultado da query */
      if (processSnapshot != null) {
        /* Verificando se snapshot não está vazio */
        if (processSnapshot.docs.isNotEmpty) {
          var doc = processSnapshot.docs.first;
          process = Process.fromJson(doc.data());
          /* Caso o processo exista, verificando se ele já não foi finalizado */
          if (process.getEnd == null) {
            process.setDepartment = department;
            process.setEnd = now;
            process.setObservations = observations;

            try {
              await FirestoreDB.dbProcesses.doc(doc.id).update({
                'end': process.getEnd,
                'observations': observations,
                'department': department.toJson()
              });
              Toasts.showToast(content: 'Processo finalizado com sucesso');
            } catch (e) {
              Toasts.showToast(content: 'Erro ao atualizar');
            }
          } else {
            Toasts.showToast(content: 'Processo finalizado');
          }
        } else {
          Process process = Process();
          process = await create(process, user, department);
        }
      } else {
        Process process = Process();
        process = await create(process, user, department);
      }
    } catch (e) {
      print('Erro ao tentar criar um novo processo');
    }

    return process;
  }

  update(Process process) async {
    bool result = false;
    var now = DateTime.now();
    QuerySnapshot snapshot = await FirestoreDB.departments
        .where('name', isEqualTo: process.getDepartment.name)
        .get();

    if (snapshot.docs.isNotEmpty) {
      try {
        await FirestoreDB.departments.doc(snapshot.docs.first.id).update({
          'equipments': process.getDepartment.equipments
              .map((Equipment e) => e.toJson())
              .toList(),
        });

        QuerySnapshot processSnapshot = await FirestoreDB.dbProcesses
            .where(
              'start',
              isGreaterThanOrEqualTo: Timestamp.fromDate(
                DateTimeHelper.convertToInitialDate(now),
              ),
            )
            .where(
              'start',
              isLessThanOrEqualTo: Timestamp.fromDate(
                DateTimeHelper.convertToEndDate(now),
              ),
            )
            .where('department.name', isEqualTo: process.getDepartment.name)
            .get();
        process.setEnd = now;
        await FirestoreDB.dbProcesses
            .doc(processSnapshot.docs.first.id)
            .update(process.toJson());

        Toasts.showToast(content: 'Processo finalizado com sucesso');

        result = true;
      } catch (e) {
        Toasts.showToast(content: 'Erro ao finalizar processo');
        print('[ERRO] $e');
      }
    }
    return result;
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
  //       .dbProcesses
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
    return await FirestoreDB.dbProcesses
        .where('start', isGreaterThanOrEqualTo: Timestamp.fromDate(pickedStart))
        .where('start', isLessThanOrEqualTo: Timestamp.fromDate(pickedEnd))
        .get();
  }

  hasOwnership(String processOwnerId, String userId) =>
      processOwnerId == userId ? true : false;
}
