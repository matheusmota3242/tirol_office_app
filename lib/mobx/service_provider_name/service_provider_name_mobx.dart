import 'package:mobx/mobx.dart';

part 'service_provider_name_mobx.g.dart';

class ServiceProviderNameMobx = ServiceProviderNameMobxBase
    with _$ServiceProviderNameMobx;

abstract class ServiceProviderNameMobxBase with Store {
  @observable
  String _name;

  @computed
  get name => _name;

  @action
  setName(String name) => _name = name;
}
