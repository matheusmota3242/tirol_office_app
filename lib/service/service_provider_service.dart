import 'package:tirol_office_app/db/firestore.dart';
import 'package:tirol_office_app/models/service_provider_model.dart';

class ServiceProviderService {
  void save(ServiceProvider serviceProvider) {
    FirestoreDB().db_service_providers.add(serviceProvider.toJson());
  }
}
