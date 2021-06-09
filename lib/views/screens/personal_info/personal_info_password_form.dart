import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:string_validator/string_validator.dart';
import 'package:tirol_office_app/auth/auth_service.dart';
import 'package:tirol_office_app/service/user_service.dart';
import 'dart:math' as math;

import 'package:tirol_office_app/utils/page_utils.dart';
import 'package:tirol_office_app/utils/validation_utils.dart';

class PersonalInfoPasswordFormView extends StatefulWidget {
  @override
  _PersonalInfoPasswordFormViewState createState() =>
      _PersonalInfoPasswordFormViewState();
}

class _PersonalInfoPasswordFormViewState
    extends State<PersonalInfoPasswordFormView> with TickerProviderStateMixin {
  AnimationController _animationController;
  ValidationUtils _validationUtils = ValidationUtils();
  GlobalKey<FormState> _key = GlobalKey();
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
      print('validando');
      String response;
      switch (field) {
        case PageUtils.ACTUAL_PASSWORD_FIELD:
          response = _auth.validateUserPassword(value, _user.email);

          return response;

          break;
        case PageUtils.NEW_PASSWORD_FIELD:
          return _validationUtils.validatePassword(value);
          break;
        case PageUtils.CONFIRM_NEW_PASSWORD_FIELD:
          if (value.isEmpty) return 'Por favor, confirme sua senha';
          if (!isAlphanumeric(value))
            return 'Sua senha deve conter apenas letras e/ou números';
          if (value.length < 6)
            return 'Sua senha deve conter no mínimo 6 caracteres';
          break;
        default:
      }
    }

    Widget personalInfoAttribute(String label) {
      return Container(
          child: TextFormField(
        onChanged: (value) => onChangedHandler(label, value),
        validator: (value) => validationHandler(label, value),
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

    submit() {
      if (_key.currentState.validate()) print('validado');
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
                onPressed: () => index == 0 ? submit() : null,
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
