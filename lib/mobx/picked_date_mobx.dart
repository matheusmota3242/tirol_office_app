import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';

part 'picked_date_mobx.g.dart';

class PickedDateMobx = PickedDateMobxBase with _$PickedDateMobx;

abstract class PickedDateMobxBase with Store {
  @observable
  DateTime picked = DateTime.now();

  @computed
  get getPicked => this.picked;

  @action
  void setPicked(DateTime picked) => this.picked = picked;
}
