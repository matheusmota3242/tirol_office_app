import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:tirol_office_app/helpers/equipment_helper.dart';
import 'package:tirol_office_app/helpers/route_helper.dart';
import 'package:tirol_office_app/models/department_model.dart';
import 'dart:math' as math;

import 'package:tirol_office_app/models/enums/equipment_status_enum.dart';
import 'package:tirol_office_app/models/equipment_model.dart';
import 'package:tirol_office_app/service/department_service.dart';
import 'package:tirol_office_app/views/widgets/department_form_equipment_item.dart';
import 'package:tirol_office_app/views/widgets/toast.dart';

class DepartmentEditFormView extends StatefulWidget {
  final Department department;

  const DepartmentEditFormView({Key key, @required this.department})
      : super(key: key);
  _DepartmentEditFormViewState createState() => _DepartmentEditFormViewState();
}

class _DepartmentEditFormViewState extends State<DepartmentEditFormView>
    with TickerProviderStateMixin {
  //var equipmentStatus;

  AnimationController _animationController;
  var equipmentStatusOptions = <String>['Funcionando', 'Danificado'];

  // Configurações do FabIcon animado
  static const List<IconData> fabIcons = const [Icons.done, Icons.close];
  static const List<Color> fabIconsColors = const [Colors.green, Colors.red];

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var themeData = Theme.of(context);
    var _departmentService =
        Provider.of<DepartmentService>(context, listen: false);
    _departmentService.setCurrentDepartment(widget.department);
    String tempName = widget.department.name;

    // Campo nome do deprtamento a ser adicionado
    Widget departmentNameField() {
      TextEditingController controller =
          TextEditingController(text: widget.department.name);
      return Container(
        child: TextFormField(
          onChanged: (value) => tempName = value,
          controller: controller,
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
      );
    }

    // Seleciona o status do equipamento a ser adicionado
    selectStatusEquipment(String value) {
      _departmentService.setEquipmentStatus(value);
    }

    setEquipmentName(String value) {
      _departmentService.setEquipmentName(value);
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
            labelText: 'Descrição',
            labelStyle: TextStyle(
                color: Colors.grey[800],
                height: 0.9,
                fontWeight: FontWeight.w600),
            filled: true,
            counterStyle: TextStyle(color: Colors.red),
            hintText: 'Descrição',
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

    Widget submitButton(GlobalKey<FormState> formKey, BuildContext context) {
      return RaisedButton(
        onPressed: () {
          if (formKey.currentState.validate()) {
            Equipment equipment = new Equipment();
            equipment.setDescription = _departmentService.equipmentName;

            _departmentService.setCurrentEquipment(equipment);
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

    void update() {
      _departmentService.editedDepartment.setName(tempName);
      _departmentService.update();
      Toasts.showToast(content: 'Departamento atualizado com sucesso!');
      Navigator.pop(context);
    }

    void cancel() {
      _departmentService.setCurrentDepartment(null);
      _departmentService.equipments.clear();
      _departmentService.setEquipmentName('');
      _departmentService.setEquipmentStatus(null);
      Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Editar departamento'),
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
                backgroundColor: fabIconsColors[index],
                mini: true,
                child: Icon(fabIcons[index], color: Colors.white),
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
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: ListView(
          children: [
            departmentNameField(),
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
                            height: 190.0,
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
                                // SizedBox(height: 30.0),
                                // Container(
                                //   alignment: Alignment.center,
                                //   child: Row(
                                //     mainAxisAlignment:
                                //         MainAxisAlignment.spaceEvenly,
                                //     children: [

                                //     ],
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                        actions: [
                          cancelButton(context),
                          RaisedButton(
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
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
                    ).then((result) {
                      if (result) {
                        Equipment equipment = new Equipment();
                        equipment.setDescription =
                            _departmentService.equipmentName;

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
                child: _departmentService.currentDepartment.equipments.isEmpty
                    ? Row(
                        children: [
                          Text(
                            'Nenhum equipamento adicionado.',
                            style: themeData.textTheme.bodyText1,
                          ),
                        ],
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: _departmentService
                            .currentDepartment.equipments.length,
                        itemBuilder: (context, index) {
                          var equipment = _departmentService
                              .currentDepartment.equipments[index];
                          equipment.id = index;
                          return DepartmentFormEquipmentItem(
                            equipment: equipment,
                            editing: true,
                          );
                        },
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void addEquipmentDialog(BuildContext context) {}
}
