import 'package:flutter/material.dart';
import 'package:tirol_office_app/models/unit.dart';

import 'package:tirol_office_app/service/unit_service.dart';
import 'package:tirol_office_app/utils/page_utils.dart';
import 'package:tirol_office_app/utils/route_utils.dart';
import 'package:tirol_office_app/utils/validation_utils.dart';

import 'unit_list_view.dart';

class UnitFormView extends StatefulWidget {
  const UnitFormView({Key key}) : super(key: key);
  @override
  _UnitFormViewState createState() => _UnitFormViewState();
}

class _UnitFormViewState extends State<UnitFormView>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  Unit unit = Unit();

  final GlobalKey<FormState> _formKey = GlobalKey();

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
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                validator: (value) => ValidationUtils().isEmpty(value),
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
              SizedBox(
                height: PageUtils.BODY_PADDING_VALUE,
              ),
              TextFormField(
                validator: (value) => ValidationUtils().isEmpty(value),
                onChanged: (value) => unit.address = value,
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  labelText: 'Endereço',
                  labelStyle: TextStyle(
                      color: Colors.grey[700],
                      height: 0.9,
                      fontWeight: FontWeight.w600),
                  filled: true,
                  counterStyle: TextStyle(color: Colors.red),
                  hintText: 'Endereço',
                  contentPadding: EdgeInsets.only(
                    left: 10.0,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(
                height: PageUtils.BODY_PADDING_VALUE,
              ),
              TextFormField(
                validator: (value) => ValidationUtils().isEmpty(value),
                onChanged: (value) => unit.number = int.parse(value),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  labelText: 'Número',
                  labelStyle: TextStyle(
                      color: Colors.grey[700],
                      height: 0.9,
                      fontWeight: FontWeight.w600),
                  filled: true,
                  counterStyle: TextStyle(color: Colors.red),
                  hintText: 'Número',
                  contentPadding: EdgeInsets.only(
                    left: 10.0,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(
                height: PageUtils.BODY_PADDING_VALUE,
              ),
              TextFormField(
                validator: (value) => ValidationUtils().isEmpty(value),
                onChanged: (value) => unit.district = value,
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  labelText: 'Bairro',
                  labelStyle: TextStyle(
                      color: Colors.grey[700],
                      height: 0.9,
                      fontWeight: FontWeight.w600),
                  filled: true,
                  counterStyle: TextStyle(color: Colors.red),
                  hintText: 'Bairro',
                  contentPadding: EdgeInsets.only(
                    left: 10.0,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton:
          PageUtils.getFloatActionButton(_animationController, persist, pop),
    );
  }

  persist() async {
    if (_formKey.currentState.validate()) {
      await UnitService().add(unit);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => UnitListView()), (route) => false);
    }
  }

  pop() {
    Navigator.pop(context);
  }
}
