import 'package:flutter/material.dart';
import 'package:tirol_office_app/db/firestore.dart';
import 'package:tirol_office_app/models/service_provider_model.dart';
import 'package:tirol_office_app/views/screens/service_provider/service_provider_form_view.dart';

class ServiceProviderService {
  void persist(ServiceProvider serviceProvider) {
    serviceProvider.id == null
        ? save(serviceProvider)
        : update(serviceProvider);
  }

  void save(ServiceProvider serviceProvider) {
    FirestoreDB.db_service_providers.add(serviceProvider.toJson());
  }

  void update(ServiceProvider serviceProvider) {
    FirestoreDB.db_service_providers
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

  void remove(String id) async {
    await FirestoreDB.db_service_providers.doc(id).delete();
  }
}
