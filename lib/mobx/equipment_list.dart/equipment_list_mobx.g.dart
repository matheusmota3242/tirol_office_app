// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'equipment_list_mobx.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$EquipmentListMobx on EquipmentListMobxBase, Store {
  final _$equipmentListAtom = Atom(name: 'EquipmentListMobxBase.equipmentList');

  @override
  ObservableList<EquipmentMobx> get equipmentList {
    _$equipmentListAtom.reportRead();
    return super.equipmentList;
  }

  @override
  set equipmentList(ObservableList<EquipmentMobx> value) {
    _$equipmentListAtom.reportWrite(value, super.equipmentList, () {
      super.equipmentList = value;
    });
  }

  final _$EquipmentListMobxBaseActionController =
      ActionController(name: 'EquipmentListMobxBase');

  @override
  void addEquipment(EquipmentMobx equipmentMobx) {
    final _$actionInfo = _$EquipmentListMobxBaseActionController.startAction(
        name: 'EquipmentListMobxBase.addEquipment');
    try {
      return super.addEquipment(equipmentMobx);
    } finally {
      _$EquipmentListMobxBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
equipmentList: ${equipmentList}
    ''';
  }
}
