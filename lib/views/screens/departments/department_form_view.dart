import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

import 'package:tirol_office_app/models/enums/equipment_status_enum.dart';
import 'package:tirol_office_app/models/equipment_model.dart';
import 'package:tirol_office_app/service/department_service.dart';
import 'package:tirol_office_app/views/widgets/department_form_equipment_item.dart';

class DepartmentFormView extends StatefulWidget {
  _DepartmentFormViewState createState() => _DepartmentFormViewState();
}

class _DepartmentFormViewState extends State<DepartmentFormView>
    with TickerProviderStateMixin {
  //var equipmentStatus;
  var _departmentService = DepartmentService();
  AnimationController _animationController;
  var equipmentStatusOptions = <String>['Funcionando', 'Danificado'];
  static const List<IconData> fabIcons = const [
    Icons.ac_unit,
    Icons.ac_unit_sharp
  ];

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Novo departamento'),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(fabIcons.length, (int index) {
          Widget child = Container(
            height: 70.0,
            width: 56.0,
            alignment: FractionalOffset.topCenter,
            child: ScaleTransition(
              scale: CurvedAnimation(
                parent: _animationController,
                curve: Interval(0.0, 1.0 - index / fabIcons.length / 2.0,
                    curve: Curves.easeOut),
              ),
              child: FloatingActionButton(
                heroTag: null,
                backgroundColor: Colors.blue,
                mini: true,
                child: Icon(fabIcons[index], color: Colors.red),
                onPressed: () {},
              ),
            ),
          );
          return child;
        }).toList()
          ..add(
            FloatingActionButton(
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
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: ListView(
          children: [
            departmentNameField,
            SizedBox(
              height: 10.0,
            ),
            Divider(
              color: Colors.grey[600],
            ),
            Row(
              children: [
                Text('Equipamentos', style: themeData.textTheme.headline6),
                IconButton(
                  onPressed: () {
                    final _formKey = GlobalKey<FormState>();
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('Novo equipamento'),
                        content: Form(
                          key: _formKey,
                          child: Container(
                            height: 240.0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                equipmentNameField(),
                                SizedBox(
                                  height: 30.0,
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Status atual do equipamento',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ),
                                SizedBox(
                                  height: 16.0,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(4.0),
                                    ),
                                  ),
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.only(left: 3.0),
                                  child: Observer(
                                    builder: (_) => DropdownButton<String>(
                                      underline: SizedBox(),
                                      isExpanded: true,
                                      value:
                                          _departmentService.getEquipmentStatus,
                                      onChanged: (value) {
                                        selectStatusEquipment(value);
                                      },
                                      items:
                                          equipmentStatusOptions.map((value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 30.0),
                                Container(
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      cancelButton(context),
                                      RaisedButton(
                                        onPressed: () {
                                          if (_formKey.currentState
                                              .validate()) {
                                            Navigator.of(context).pop(true);
                                          }
                                        },
                                        child: Text(
                                          'Salvar',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ).then((result) {
                      if (result) {
                        Equipment equipment = new Equipment(
                            _departmentService.equipmentName,
                            EquipmentStatus.ABLE);
                        setState(() {
                          _departmentService.equipments.add(equipment);
                        });
                      }
                    });
                  },
                  color: Theme.of(context).buttonColor,
                  icon: Icon(Icons.add_circle),
                )
              ],
            ),
            Observer(
              builder: (_) => Container(
                  child: _departmentService.equipments.isEmpty
                      ? Row(
                          children: [
                            Text(
                              'Nenhum equipamento adicionado.',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ],
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: _departmentService.equipments.length,
                          itemBuilder: (context, index) {
                            var department =
                                _departmentService.equipments[index];

                            return DepartmentFormEquipmentItem(
                              description: department.description,
                              status: department.status,
                            );
                          },
                        )),
            )
          ],
        ),
      ),
    );
  }

  void addEquipmentDialog(BuildContext context) {}

  // Seleciona o status do equipamento a ser adicionado
  selectStatusEquipment(String value) {
    _departmentService.setEquipmentStatus(value);
  }

  // Campo nome do equipamento a ser adicionado ao deprtamento
  Widget equipmentNameField() {
    return Container(
      child: TextFormField(
        validator: (value) => value.isEmpty ? 'Campo obrigatório' : null,
        onChanged: (value) => setEquipmentName(value.trim()),
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          alignLabelWithHint: true,
          labelText: 'Nome',
          labelStyle: TextStyle(
              color: Colors.grey[800],
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
    );
  }

  // Campo nome do deprtamento a ser adicionado
  Widget departmentNameField = Container(
    child: TextFormField(
      decoration: InputDecoration(
        alignLabelWithHint: true,
        labelText: 'Nome',
        labelStyle: TextStyle(
            color: Colors.grey[700], height: 0.9, fontWeight: FontWeight.w600),
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
  );

  Widget submitButton(GlobalKey<FormState> formKey, BuildContext context) {
    return RaisedButton(
      onPressed: () {
        if (formKey.currentState.validate()) {
          Equipment equipment = new Equipment(
              _departmentService.equipmentName, EquipmentStatus.ABLE);
          _departmentService.setEquipment(equipment);
          Navigator.of(context, rootNavigator: true).pop();
        }
      },
      child: Text(
        'Salvar',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget cancelButton(BuildContext context) {
    return RaisedButton(
      color: Colors.red,
      onPressed: () => Navigator.pop(context),
      child: Text(
        'Cancelar',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  setEquipmentName(String value) {
    _departmentService.setEquipmentName(value);
  }
}
