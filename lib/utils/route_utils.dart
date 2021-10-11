import 'package:flutter/material.dart';

import 'package:tirol_office_app/models/dto/department_dto_model.dart';
import 'package:tirol_office_app/models/equipment_model.dart';
import 'package:tirol_office_app/models/maintenance_model.dart';
import 'package:tirol_office_app/views/screens/equipments/corrective/equipment_corrective_maintanance_form_view.dart';
import 'package:tirol_office_app/views/screens/equipments/corrective/equipment_corrective_maintenances_view.dart';
import 'package:tirol_office_app/views/screens/units/unit_form_view.dart';

class RouteUtils {
  static const String processes = 'processes';
  static const String observations = 'observations';
  static const String login = 'login';
  static const String DEPARTMENTS = 'departments';
  static const String departmentsEditForm = 'departmentsEditForm';
  static const String EQUIPMENTS = 'equipments';
  static const String MAINTENANCES = 'maintenances';
  static const String users = 'users';
  static const String processDetails = 'processDetails';
  static const String serviceProviders = 'serviceProviders';
  static const String serviceProvidersForm = 'serviceProvidersForm';
  static const String personalInfo = 'personalInfo';
  static const String personalInfoForm = 'personalInfoForm';
  static const String units = 'units';

  /* Página de formulário de manutenção corretiva.
   * Recebe a descrição do equipmaneto e o nome do departamento
   */
  static void pushToEquipmentCorrectiveMaintenancesFormView(
      {BuildContext context,
      Equipment equipment,
      DepartmentDTO departmentDTO,
      Maintenance maintenance,
      bool edit,
      bool fromMaintenancesView}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EquipmentCorrectiveMaintenanceFormView(
          equipment: equipment,
          departmentDTO: departmentDTO,
          maintenance: maintenance,
          edit: edit,
          fromMaintenancesView: fromMaintenancesView,
        ),
      ),
    );
  }

  static void pushToEquipmentCorrectiveMaintenancesView(
      BuildContext context, Equipment equipment, DepartmentDTO departmentDTO) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EquipmentCorrectiveMaintenancesView(
          equipment: equipment,
          departmentDTO: departmentDTO,
        ),
      ),
    );
  }

  static void pushToUnitFormView(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => UnitFormView()));
  }
}
