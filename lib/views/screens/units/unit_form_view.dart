import 'package:flutter/material.dart';
import 'package:tirol_office_app/models/unit.dart';

import 'package:tirol_office_app/service/unit_service.dart';
import 'package:tirol_office_app/utils/page_utils.dart';

class UnitFormView extends StatefulWidget {
  const UnitFormView({Key key}) : super(key: key);
  @override
  _UnitFormViewState createState() => _UnitFormViewState();
}

class _UnitFormViewState extends State<UnitFormView>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  Unit unit = Unit();
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Nova unidade'),
      ),
      body: Container(
        padding: PageUtils.BODY_PADDING,
        child: TextFormField(
          onChanged: (value) => unit.name = value,
          decoration: InputDecoration(
            alignLabelWithHint: true,
            labelText: 'Nome',
            labelStyle: TextStyle(
                color: Colors.grey[700],
                height: 0.9,
                fontWeight: FontWeight.w600),
            filled: true,
            counterStyle: TextStyle(color: Colors.red),
            hintText: 'Nome',
            contentPadding: EdgeInsets.only(
              left: 10.0,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
      floatingActionButton:
          PageUtils.getFloatActionButton(_animationController, persist, pop),
    );
  }

  persist() async {
    await UnitService().add(unit);
  }

  pop() {
    Navigator.pop(context);
  }
}
