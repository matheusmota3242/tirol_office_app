import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:tirol_office_app/utils/page_utils.dart';

class PersonalInfoFormView extends StatefulWidget {
  final String name;
  final String email;
  const PersonalInfoFormView({Key key, this.name, this.email})
      : super(key: key);
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
        child: Column(
          children: [
            personalInfoAttribute(PageUtils.NAME_FIELD, widget.name),
            PageUtils().separator,
            personalInfoAttribute(PageUtils.EMAIL_FIELD, widget.email)
          ],
        ),
      ),
    );
  }

  Widget personalInfoAttribute(String label, String value) {
    TextEditingController controller = TextEditingController(text: value);
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
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
