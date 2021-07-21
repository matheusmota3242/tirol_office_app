import 'package:mobx/mobx.dart';

part 'loading_mobx.g.dart';

class LoadingMobx = LoadingMobxBase with _$LoadingMobx;

abstract class LoadingMobxBase with Store {
  @observable
  bool _status = false;

  @computed
  get status => this._status;

  @action
  void setStatus(bool status) => this._status = status;
}
