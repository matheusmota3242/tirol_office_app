// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'picked_date_mobx.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$PickedDateMobx on PickedDateMobxBase, Store {
  Computed<dynamic> _$getPickedComputed;

  @override
  dynamic get getPicked =>
      (_$getPickedComputed ??= Computed<dynamic>(() => super.getPicked,
              name: 'PickedDateMobxBase.getPicked'))
          .value;

  final _$pickedAtom = Atom(name: 'PickedDateMobxBase.picked');

  @override
  DateTime get picked {
    _$pickedAtom.reportRead();
    return super.picked;
  }

  @override
  set picked(DateTime value) {
    _$pickedAtom.reportWrite(value, super.picked, () {
      super.picked = value;
    });
  }

  final _$PickedDateMobxBaseActionController =
      ActionController(name: 'PickedDateMobxBase');

  @override
  void setPicked(DateTime picked) {
    final _$actionInfo = _$PickedDateMobxBaseActionController.startAction(
        name: 'PickedDateMobxBase.setPicked');
    try {
      return super.setPicked(picked);
    } finally {
      _$PickedDateMobxBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
picked: ${picked},
getPicked: ${getPicked}
    ''';
  }
}
