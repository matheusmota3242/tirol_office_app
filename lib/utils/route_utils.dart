import 'package:flutter/material.dart';

import 'package:tirol_office_app/views/screens/equipments/corrective/equipment_corrective_maintanance_form_view.dart';
import 'package:tirol_office_app/views/screens/equipments/preventive/equipment_preventive_form_view.dart';

class RouteUtils {
  static const String processes = 'processes';
  static const String observations = 'observations';
  static const String login = 'login';
  static const String departments = 'departments';
  static const String departmentsEditForm = 'departmentsEditForm';
  static const String EQUIPMENTS = 'equipments';
  static const String users = 'users';
  static const String processDetails = 'processDetails';
  static const String serviceProviders = 'serviceProviders';
  static const String serviceProvidersForm = 'serviceProvidersForm';
  static const String personalInfo = 'personalInfo';
  static const String personalInfoForm = 'personalInfoForm';

  /* Página de formulário de manutenção preventiva */
  static void pushToEquipmentPreventiveMaintenancesFormView(
      BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EquipmentPreventiveMaintananceFormView(),
      ),
    );
  }

  /* Página de formulário de manutenção corretiva */
  static void pushToEquipmentCorrectiveMaintenancesFormView(
      BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EquipmentCorrectiveMaintenanceFormView(),
      ),
    );
  }
}
