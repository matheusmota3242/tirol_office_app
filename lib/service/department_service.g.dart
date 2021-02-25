// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'department_service.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$DepartmentService on DepartmentServiceBase, Store {
  Computed<dynamic> _$getDepartmentComputed;

  @override
  dynamic get getDepartment =>
      (_$getDepartmentComputed ??= Computed<dynamic>(() => super.getDepartment,
              name: 'DepartmentServiceBase.getDepartment'))
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

  final _$departmentAtom = Atom(name: 'DepartmentServiceBase.department');

  @override
  Department get department {
    _$departmentAtom.reportRead();
    return super.department;
  }

  @override
  set department(Department value) {
    _$departmentAtom.reportWrite(value, super.department, () {
      super.department = value;
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
  dynamic setDepartment(Department department) {
    final _$actionInfo = _$DepartmentServiceBaseActionController.startAction(
        name: 'DepartmentServiceBase.setDepartment');
    try {
      return super.setDepartment(department);
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
department: ${department},
currentEquipment: ${currentEquipment},
equipmentStatus: ${equipmentStatus},
getDepartment: ${getDepartment},
getCurrentEquipment: ${getCurrentEquipment},
getEquipmentStatus: ${getEquipmentStatus}
    ''';
  }
}
