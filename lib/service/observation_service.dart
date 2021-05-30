import 'package:tirol_office_app/db/firestore.dart';
import 'package:tirol_office_app/models/observation_model.dart';

class ObservationService {
  void save(Observation observation) {
    observation.dateTime = DateTime.now();
    FirestoreDB().db_observations.add(observation.toJson());
  }

  void update(Observation observation) {
    FirestoreDB()
        .db_observations
        .doc(observation.id)
        .update(observation.toJson());
  }
}
