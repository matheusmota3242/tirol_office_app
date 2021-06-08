import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

import 'package:tirol_office_app/auth/auth_service.dart';
import 'package:tirol_office_app/models/user_model.dart';
import 'package:tirol_office_app/utils/page_utils.dart';
import 'package:tirol_office_app/utils/route_utils.dart';
import 'package:tirol_office_app/views/widgets/toast.dart';

class PersonalInfoFormView extends StatefulWidget {
  final User user;
  const PersonalInfoFormView({Key key, this.user}) : super(key: key);
  _PersonalInfoFormViewState createState() => _PersonalInfoFormViewState();
}

class _PersonalInfoFormViewState extends State<PersonalInfoFormView>
    with TickerProviderStateMixin {
  AnimationController _animationController;
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
    var auth = Provider.of<AuthService>(context, listen: false);
    void update() async {
      await auth.update(widget.user, context);
      Toasts.showToast(content: 'Informações atualizadas com sucesso');
      Navigator.pushNamed(context, RouteUtils.personalInfo);
    }

    void cancel() {
      Navigator.pushNamed(context, RouteUtils.personalInfo);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Editar informações pessoais'),
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
                onPressed: () => index == 0 ? update() : cancel(),
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
        child: Column(
          children: [
            personalInfoNameField(PageUtils.NAME_FIELD, widget.user.name),
            PageUtils().separator,
            personalInfoEmailField(PageUtils.EMAIL_FIELD, widget.user.email)
          ],
        ),
      ),
    );
  }

  void action(String field, String value) {
    switch (field) {
      case PageUtils.NAME_FIELD:
        break;
      case PageUtils.EMAIL_FIELD:
        break;
      default:
    }
  }

  Widget personalInfoNameField(String label, String value) {
    TextEditingController controller = TextEditingController(text: value);
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            onChanged: (newName) {
              controller.text = newName;
              widget.user.name = newName;
            },
            controller: controller,
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
          )
        ],
      ),
    );
  }

  Widget personalInfoEmailField(String label, String value) {
    TextEditingController controller = TextEditingController(text: value);
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            onChanged: (newEmail) {
              widget.user.email = newEmail;
              controller.text = newEmail;
            },
            controller: controller,
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
          )
        ],
      ),
    );
  }
}
