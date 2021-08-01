// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_provider_name_mobx.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ServiceProviderNameMobx on ServiceProviderNameMobxBase, Store {
  Computed<dynamic> _$nameComputed;

  @override
  dynamic get name => (_$nameComputed ??= Computed<dynamic>(() => super.name,
          name: 'ServiceProviderNameMobxBase.name'))
      .value;

  final _$_nameAtom = Atom(name: 'ServiceProviderNameMobxBase._name');

  @override
  String get _name {
    _$_nameAtom.reportRead();
    return super._name;
  }

  @override
  set _name(String value) {
    _$_nameAtom.reportWrite(value, super._name, () {
      super._name = value;
    });
  }

  final _$ServiceProviderNameMobxBaseActionController =
      ActionController(name: 'ServiceProviderNameMobxBase');

  @override
  dynamic setName(String name) {
    final _$actionInfo = _$ServiceProviderNameMobxBaseActionController
        .startAction(name: 'ServiceProviderNameMobxBase.setName');
    try {
      return super.setName(name);
    } finally {
      _$ServiceProviderNameMobxBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
name: ${name}
    ''';
  }
}
