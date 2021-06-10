import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:string_validator/string_validator.dart';
import 'package:tirol_office_app/auth/auth_service.dart';
import 'package:tirol_office_app/service/user_service.dart';
import 'dart:math' as math;

import 'package:tirol_office_app/utils/page_utils.dart';
import 'package:tirol_office_app/utils/validation_utils.dart';
import 'package:tirol_office_app/views/widgets/dialogs.dart';
import 'package:tirol_office_app/views/widgets/toast.dart';

class PersonalInfoPasswordFormView extends StatefulWidget {
  @override
  _PersonalInfoPasswordFormViewState createState() =>
      _PersonalInfoPasswordFormViewState();
}

class _PersonalInfoPasswordFormViewState
    extends State<PersonalInfoPasswordFormView> with TickerProviderStateMixin {
  AnimationController _animationController;
  ValidationUtils _validationUtils = ValidationUtils();
  final _key = GlobalKey<FormState>();
  String _actualPassword, _newPassword, _confirmNewPassword;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var themeData = Theme.of(context);
    var _auth = Provider.of<AuthService>(context);
    var _user = Provider.of<UserService>(context, listen: false).getUser;

    void onChangedHandler(String field, String value) {
      switch (field) {
        case PageUtils.ACTUAL_PASSWORD_FIELD:
          _actualPassword = value;
          break;
        case PageUtils.NEW_PASSWORD_FIELD:
          _newPassword = value;
          break;
        case PageUtils.CONFIRM_NEW_PASSWORD_FIELD:
          _confirmNewPassword = value;
          break;
        default:
      }
    }

    validationHandler(String field, String value) {
      switch (field) {
        case PageUtils.ACTUAL_PASSWORD_FIELD:
          return _validationUtils.validatePasswordFields(
              value, ValidationUtils.ACTUAL_PASSWORD_FIELD);

          break;
        case PageUtils.NEW_PASSWORD_FIELD:
          return _validationUtils.validatePasswordFields(
              value, ValidationUtils.NEW_PASSWORD_FIELD);
          break;
        case PageUtils.CONFIRM_NEW_PASSWORD_FIELD:
          if (value.isEmpty)
            return 'Por favor, preenhca o campo confirmação de nova senha';
          if (value != _newPassword)
            return 'Valor não confere com nova senha inserida';

          return _validationUtils.validatePasswordFields(
              value, ValidationUtils.CONFIRM_NEW_PASSWORD_FIELD);
        default:
      }
    }

    Widget personalInfoAttribute(String label) {
      return Container(
          child: TextFormField(
        onChanged: (value) => onChangedHandler(label, value),
        validator: (value) => validationHandler(label, value),
        obscureText: true,
        style: TextStyle(
            fontSize: 16.0,
            color: Colors.grey[800],
            fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          alignLabelWithHint: true,
          labelText: label,
          labelStyle: TextStyle(
              color: Colors.grey[700],
              height: 0.9,
              fontWeight: FontWeight.w600),
          filled: true,
          counterStyle: TextStyle(color: Colors.red),
          hintText: label,
          contentPadding: EdgeInsets.only(
            left: 10.0,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
        ),
      ));
    }

    Future<Null> submit() async {
      bool result;
      var errorMsg;
      if (_key.currentState.validate()) {
        result = await _auth.validateUserPassword(_actualPassword);
        if (result) {
          result = await _auth.updatePassword(_newPassword);
          if (result) {
            Toasts.showToast(content: 'Senha alterada com sucesso');
            Navigator.pop(context);
          } else {
            errorMsg = 'Desculpe, ocorreu um erro. Tente novamente mais tarde';
            Dialogs.showErrorActualPassword(context, errorMsg);
          }
        } else {
          errorMsg = 'Valor inserido no campo difere da sua senha atual';
          Dialogs.showErrorActualPassword(context, errorMsg);
        }
      }
    }

    void cancel() {
      Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(PageUtils.personalInfoPassword),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(PageUtils.fabIcons.length, (int index) {
          Widget child = Container(
            height: 70.0,
            width: 56.0,
            alignment: FractionalOffset.topCenter,
            child: ScaleTransition(
              scale: CurvedAnimation(
                parent: _animationController,
                curve: Interval(
                    0.0, 1.0 - index / PageUtils.fabIcons.length / 2.0,
                    curve: Curves.easeOut),
              ),
              child: FloatingActionButton(
                heroTag: null,
                backgroundColor: PageUtils.fabIconsColors[index],
                mini: true,
                child: Icon(PageUtils.fabIcons[index], color: Colors.white),
                onPressed: () => index == 0 ? submit() : cancel(),
              ),
            ),
          );
          return child;
        }).toList()
          ..add(
            FloatingActionButton(
              backgroundColor: themeData.buttonColor,
              heroTag: null,
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) => Transform(
                  transform: new Matrix4.rotationZ(
                      _animationController.value * 0.5 * math.pi),
                  alignment: FractionalOffset.center,
                  child: Icon(_animationController.isDismissed
                      ? Icons.share
                      : Icons.close),
                ),
              ),
              onPressed: () {
                if (_animationController.isDismissed) {
                  _animationController.forward();
                } else {
                  _animationController.reverse();
                }
              },
            ),
          ),
      ),
      body: Padding(
        padding: PageUtils.bodyPadding,
        child: Form(
          key: _key,
          child: Column(
            children: [
              personalInfoAttribute(PageUtils.ACTUAL_PASSWORD_FIELD),
              sizedBox,
              personalInfoAttribute(PageUtils.NEW_PASSWORD_FIELD),
              sizedBox,
              personalInfoAttribute(PageUtils.CONFIRM_NEW_PASSWORD_FIELD),
            ],
          ),
        ),
      ),
    );
  }

  Widget sizedBox = SizedBox(
    height: PageUtils.bodyPaddingValue,
  );
}
