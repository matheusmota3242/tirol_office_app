import 'package:cloud_firestore/cloud_firestore.dart';
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

  void remove(String id) async {
    await FirestoreDB().db_observations.doc(id).delete();
  }

  Future<QuerySnapshot> queryByDate(DateTime picked) async {
    picked = DateTime(picked.year, picked.month, picked.day, 12, 00);
    DateTime pickedStart =
        DateTime(picked.year, picked.month, picked.day, 0, 00);
    DateTime pickedEnd =
        DateTime(picked.year, picked.month, picked.day, 23, 59);
    print(picked);
    return await FirestoreDB()
        .db_observations
        .where('dateTime',
            isGreaterThanOrEqualTo: Timestamp.fromDate(pickedStart))
        .where('dateTime', isLessThanOrEqualTo: Timestamp.fromDate(pickedEnd))
        .get();
  }
}
