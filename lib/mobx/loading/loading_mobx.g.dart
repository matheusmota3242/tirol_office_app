// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loading_mobx.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$LoadingMobx on LoadingMobxBase, Store {
  Computed<dynamic> _$statusComputed;

  @override
  dynamic get status => (_$statusComputed ??=
          Computed<dynamic>(() => super.status, name: 'LoadingMobxBase.status'))
      .value;

  final _$_statusAtom = Atom(name: 'LoadingMobxBase._status');

  @override
  bool get _status {
    _$_statusAtom.reportRead();
    return super._status;
  }

  @override
  set _status(bool value) {
    _$_statusAtom.reportWrite(value, super._status, () {
      super._status = value;
    });
  }

  final _$LoadingMobxBaseActionController =
      ActionController(name: 'LoadingMobxBase');

  @override
  void setStatus(bool status) {
    final _$actionInfo = _$LoadingMobxBaseActionController.startAction(
        name: 'LoadingMobxBase.setStatus');
    try {
      return super.setStatus(status);
    } finally {
      _$LoadingMobxBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
status: ${status}
    ''';
  }
}
