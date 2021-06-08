import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tirol_office_app/auth/auth_service.dart';
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
    var _auth = Provider.of<AuthService>(context, listen: false);

    _auth.showCurrentUser();
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
                onPressed: () => index == 0 ? null : null,
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

  Widget personalInfoAttribute(String label) {
    return Container(
        child: TextFormField(
      onChanged: (v) => null,
      style: TextStyle(
          fontSize: 16.0, color: Colors.grey[800], fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        alignLabelWithHint: true,
        labelText: label,
        labelStyle: TextStyle(
            color: Colors.grey[700], height: 0.9, fontWeight: FontWeight.w600),
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
}
