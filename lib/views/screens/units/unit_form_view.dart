import 'package:flutter/material.dart';
import 'package:tirol_office_app/models/unit.dart';

import 'package:tirol_office_app/service/unit_service.dart';
import 'package:tirol_office_app/utils/page_utils.dart';
import 'package:tirol_office_app/utils/validation_utils.dart';

import 'unit_list_view.dart';

class UnitFormView extends StatefulWidget {
  final Unit unit;
  final bool edit;
  const UnitFormView({
    Key key,
    @required this.unit,
    @required this.edit,
  }) : super(key: key);

  @override
  _UnitFormViewState createState() => _UnitFormViewState();
}

class _UnitFormViewState extends State<UnitFormView>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  final _formKey = GlobalKey<FormState>();
  UnitService _service = UnitService();
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
    String oldUnitName;
    if (widget.edit) {
      oldUnitName = widget.unit.name;
    }

    persist() async {
      if (_formKey.currentState.validate()) {
        if (widget.edit) {
          await _service.update(widget.unit, oldUnitName);
        } else {
          await _service.add(widget.unit);
        }
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => UnitListView()),
            (route) => false);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.edit ? 'Editar unidade' : 'Nova unidade'),
      ),
      body: Container(
        padding: PageUtils.BODY_PADDING,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                validator: (value) => ValidationUtils().isEmpty(value),
                onChanged: (value) {
                  widget.unit.name = value;
                },
                initialValue: widget.unit.name,
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
                onChanged: (value) {
                  widget.unit.address = value;
                },
                initialValue: widget.unit.address,
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
                validator: (value) {
                  var msg;
                  if (value.isEmpty) {
                    msg = 'Campo obrigatório';
                  } else if (int.tryParse(value) == null) {
                    msg = 'Apenas números inteiros';
                  }
                  return msg;
                },
                onChanged: (value) {
                  widget.unit.number = value;
                },
                initialValue: widget.unit.number,
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
                onChanged: (value) {
                  widget.unit.district = value;
                },
                initialValue: widget.unit.district,
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

  pop() {
    Navigator.pop(context);
  }
}
