import 'package:flutter/material.dart';
import 'package:tirol_office_app/db/firestore.dart';
import 'package:tirol_office_app/models/service_provider_model.dart';
import 'package:tirol_office_app/views/screens/service_provider/service_provider_form_view.dart';
import 'package:tirol_office_app/views/widgets/toast.dart';

class ServiceProviderService {
  void persist(ServiceProvider serviceProvider) {
    serviceProvider.id == null
        ? save(serviceProvider)
        : update(serviceProvider);
  }

  void save(ServiceProvider serviceProvider) {
    FirestoreDB.dbServiceProviders.add(serviceProvider.toJson());
  }

  void update(ServiceProvider serviceProvider) {
    FirestoreDB.dbServiceProviders
        .doc(serviceProvider.id)
        .update(serviceProvider.toJson());
  }

  void edit(BuildContext context, ServiceProvider serviceProvider) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) =>
                ServiceProviderFormView(serviceProvider: serviceProvider)));
  }

  Future<void> remove(String id) async {
    try {
      await FirestoreDB.dbServiceProviders.doc(id).delete();
      Toasts.showToast(content: 'Serviço removido com sucesso');
    } catch (e) {
      Toasts.showWarningToast(content: 'Erro ao tentar remover');
      print(e);
    }
  }
}
