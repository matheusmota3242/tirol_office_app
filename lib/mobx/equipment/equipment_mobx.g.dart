// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'equipment_mobx.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$EquipmentMobx on EquipmentMobxBase, Store {
  Computed<dynamic> _$getDescriptionComputed;

  @override
  dynamic get getDescription => (_$getDescriptionComputed ??= Computed<dynamic>(
          () => super.getDescription,
          name: 'EquipmentMobxBase.getDescription'))
      .value;
  Computed<dynamic> _$getStatusComputed;

  @override
  dynamic get getStatus =>
      (_$getStatusComputed ??= Computed<dynamic>(() => super.getStatus,
              name: 'EquipmentMobxBase.getStatus'))
          .value;

  final _$descriptionAtom = Atom(name: 'EquipmentMobxBase.description');

  @override
  String get description {
    _$descriptionAtom.reportRead();
    return super.description;
  }

  @override
  set description(String value) {
    _$descriptionAtom.reportWrite(value, super.description, () {
      super.description = value;
    });
  }

  final _$statusAtom = Atom(name: 'EquipmentMobxBase.status');

  @override
  String get status {
    _$statusAtom.reportRead();
    return super.status;
  }

  @override
  set status(String value) {
    _$statusAtom.reportWrite(value, super.status, () {
      super.status = value;
    });
  }

  final _$EquipmentMobxBaseActionController =
      ActionController(name: 'EquipmentMobxBase');

  @override
  dynamic setDescription(String description) {
    final _$actionInfo = _$EquipmentMobxBaseActionController.startAction(
        name: 'EquipmentMobxBase.setDescription');
    try {
      return super.setDescription(description);
    } finally {
      _$EquipmentMobxBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setStatus(String status) {
    final _$actionInfo = _$EquipmentMobxBaseActionController.startAction(
        name: 'EquipmentMobxBase.setStatus');
    try {
      return super.setStatus(status);
    } finally {
      _$EquipmentMobxBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic changeStatus(String status) {
    final _$actionInfo = _$EquipmentMobxBaseActionController.startAction(
        name: 'EquipmentMobxBase.changeStatus');
    try {
      return super.changeStatus(status);
    } finally {
      _$EquipmentMobxBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
description: ${description},
status: ${status},
getDescription: ${getDescription},
getStatus: ${getStatus}
    ''';
  }
}
