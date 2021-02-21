// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'department_service.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$DepartmentService on DepartmentServiceBase, Store {
  Computed<dynamic> _$getEquipmentStatusComputed;

  @override
  dynamic get getEquipmentStatus => (_$getEquipmentStatusComputed ??=
          Computed<dynamic>(() => super.getEquipmentStatus,
              name: 'DepartmentServiceBase.getEquipmentStatus'))
      .value;

  final _$equipmentStatusAtom =
      Atom(name: 'DepartmentServiceBase.equipmentStatus');

  @override
  String get equipmentStatus {
    _$equipmentStatusAtom.reportRead();
    return super.equipmentStatus;
  }

  @override
  set equipmentStatus(String value) {
    _$equipmentStatusAtom.reportWrite(value, super.equipmentStatus, () {
      super.equipmentStatus = value;
    });
  }

  final _$DepartmentServiceBaseActionController =
      ActionController(name: 'DepartmentServiceBase');

  @override
  dynamic setEquipmentStatus(String value) {
    final _$actionInfo = _$DepartmentServiceBaseActionController.startAction(
        name: 'DepartmentServiceBase.setEquipmentStatus');
    try {
      return super.setEquipmentStatus(value);
    } finally {
      _$DepartmentServiceBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
equipmentStatus: ${equipmentStatus},
getEquipmentStatus: ${getEquipmentStatus}
    ''';
  }
}
