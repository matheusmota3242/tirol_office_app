// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'department_service.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$DepartmentService on DepartmentServiceBase, Store {
  Computed<dynamic> _$currentDepartmentComputed;

  @override
  dynamic get currentDepartment => (_$currentDepartmentComputed ??=
          Computed<dynamic>(() => super.currentDepartment,
              name: 'DepartmentServiceBase.currentDepartment'))
      .value;
  Computed<dynamic> _$getCurrentEquipmentComputed;

  @override
  dynamic get getCurrentEquipment => (_$getCurrentEquipmentComputed ??=
          Computed<dynamic>(() => super.getCurrentEquipment,
              name: 'DepartmentServiceBase.getCurrentEquipment'))
      .value;
  Computed<dynamic> _$getEquipmentStatusComputed;

  @override
  dynamic get getEquipmentStatus => (_$getEquipmentStatusComputed ??=
          Computed<dynamic>(() => super.getEquipmentStatus,
              name: 'DepartmentServiceBase.getEquipmentStatus'))
      .value;

  final _$_currentDepartmentAtom =
      Atom(name: 'DepartmentServiceBase._currentDepartment');

  @override
  Department get _currentDepartment {
    _$_currentDepartmentAtom.reportRead();
    return super._currentDepartment;
  }

  @override
  set _currentDepartment(Department value) {
    _$_currentDepartmentAtom.reportWrite(value, super._currentDepartment, () {
      super._currentDepartment = value;
    });
  }

  final _$currentEquipmentAtom =
      Atom(name: 'DepartmentServiceBase.currentEquipment');

  @override
  Equipment get currentEquipment {
    _$currentEquipmentAtom.reportRead();
    return super.currentEquipment;
  }

  @override
  set currentEquipment(Equipment value) {
    _$currentEquipmentAtom.reportWrite(value, super.currentEquipment, () {
      super.currentEquipment = value;
    });
  }

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
  void setCurrentDepartment(Department department) {
    final _$actionInfo = _$DepartmentServiceBaseActionController.startAction(
        name: 'DepartmentServiceBase.setCurrentDepartment');
    try {
      return super.setCurrentDepartment(department);
    } finally {
      _$DepartmentServiceBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setCurrentEquipment(Equipment equipment) {
    final _$actionInfo = _$DepartmentServiceBaseActionController.startAction(
        name: 'DepartmentServiceBase.setCurrentEquipment');
    try {
      return super.setCurrentEquipment(equipment);
    } finally {
      _$DepartmentServiceBaseActionController.endAction(_$actionInfo);
    }
  }

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
currentEquipment: ${currentEquipment},
equipmentStatus: ${equipmentStatus},
currentDepartment: ${currentDepartment},
getCurrentEquipment: ${getCurrentEquipment},
getEquipmentStatus: ${getEquipmentStatus}
    ''';
  }
}
