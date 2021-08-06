import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tirol_office_app/db/firestore.dart';
import 'package:tirol_office_app/models/observation_model.dart';
import 'package:tirol_office_app/views/widgets/toast.dart';

class ObservationService {
  void save(Observation observation) async {
    observation.dateTime = DateTime.now();
    await FirestoreDB.db_observations.add(observation.toJson());
  }

  void update(Observation observation) async {
    await FirestoreDB.db_observations
        .doc(observation.id)
        .update(observation.toJson());
  }

  Future<bool> remove(String id) async {
    bool result = false;
    try {
      await FirestoreDB.db_observations.doc(id).delete();
      Toasts.showToast(content: 'Observação removida com sucesso');
      result = true;
    } catch (e) {
      Toasts.showToast(content: 'Ocorreu um erro');
    }
    return result;
  }

  Future<QuerySnapshot> queryByDate(DateTime picked) async {
    picked = DateTime(picked.year, picked.month, picked.day, 12, 00);
    DateTime pickedStart =
        DateTime(picked.year, picked.month, picked.day, 0, 00);
    DateTime pickedEnd =
        DateTime(picked.year, picked.month, picked.day, 23, 59);
    print(picked);
    return await FirestoreDB.db_observations
        .where('dateTime',
            isGreaterThanOrEqualTo: Timestamp.fromDate(pickedStart))
        .where('dateTime', isLessThanOrEqualTo: Timestamp.fromDate(pickedEnd))
        .get();
  }
}
