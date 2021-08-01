import 'package:flutter/material.dart';
import 'package:tirol_office_app/models/department_model.dart';
import 'dart:math' as math;

import 'package:tirol_office_app/models/equipment_model.dart';
import 'package:tirol_office_app/models/special_equipment_model.dart';
import 'package:tirol_office_app/service/department_service.dart';
import 'package:tirol_office_app/utils/page_utils.dart';
import 'package:tirol_office_app/utils/route_utils.dart';
import 'package:tirol_office_app/views/widgets/department_form_equipment_item.dart';
import 'package:tirol_office_app/views/widgets/toast.dart';

class DepartmentTestView extends StatefulWidget {
  final Department currentDepartment;
  final bool edit;

  const DepartmentTestView(
      {Key key, this.currentDepartment, @required this.edit})
      : super(key: key);
  @override
  _DepartmentTestViewState createState() => _DepartmentTestViewState();
}

class _DepartmentTestViewState extends State<DepartmentTestView>
    with TickerProviderStateMixin {
  var equipmentStatusOptions = <String>['Funcionando', 'Danificado'];
  static const String MSG_REQUIRED_FIELD = 'Campo obrigatório';
  static const String MSG_EQUIPMENT_DESCRIPTION_ALREADY_EXISTS =
      'Nome de equipamento já usado';
  AnimationController _animationController;
  DepartmentService _service = DepartmentService();

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    super.initState();
  }

  bool checkEdition() => widget.edit ? true : false;

  @override
  Widget build(BuildContext context) {
    var themeData = Theme.of(context);
    GlobalKey<FormState> _key = GlobalKey<FormState>();
    // Campo nome do deprtamento a ser adicionado
    Widget departmentNameField() {
      TextEditingController controller =
          TextEditingController(text: widget.currentDepartment?.name);

      return Container(
        child: Form(
          key: _key,
          child: TextFormField(
            onChanged: (value) => widget.currentDepartment.name = value,
            validator: (value) => value.isEmpty ? 'Campo obrigatório' : null,
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
        ),
      );
    }

    void submit() {
      String msg = '';
      if (_key.currentState.validate()) {
        if (checkEdition()) {
          _service.update(widget.currentDepartment);
          msg = 'Departamendo editado com sucesso';
        } else {
          _service.save(widget.currentDepartment);
          msg = 'Departamendo salvo com sucesso';
        }
        Navigator.pushNamedAndRemoveUntil(
            context, RouteUtils.DEPARTMENTS, (route) => false);
        Toasts.showToast(content: msg);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title:
            Text(checkEdition() ? 'Editar departamento' : 'Novo departamento'),
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
                onPressed: () => index == 0 ? submit() : Navigator.pop(context),
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
        padding: PageUtils.BODY_PADDING,
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
                Text('Equipamentos', style: themeData.textTheme.headline5),
                IconButton(
                  onPressed: () {
                    final _formKey = GlobalKey<FormState>();
                    showAddEquipmentDialog(_formKey, false);
                  },
                  color: Theme.of(context).buttonColor,
                  icon: Icon(Icons.add_circle),
                )
              ],
            ),
            Container(
              child: departmentEquipmentsIsEmpty(widget.currentDepartment)
                  ? Row(
                      children: [
                        Text(
                          'Nenhum equipamento adicionado.',
                          style: TextStyle(
                              fontSize: 14.0, color: Colors.grey[600]),
                        ),
                      ],
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.currentDepartment.equipments.length,
                      itemBuilder: (context, index) {
                        var equipment =
                            widget.currentDepartment.equipments[index];
                        equipment.id = index;
                        return DepartmentFormEquipmentItem(
                          equipment: equipment,
                          editing: false,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  bool departmentEquipmentsIsEmpty(Department department) =>
      department.equipments.isEmpty ? true : false;

  showAddEquipmentDialog(GlobalKey<FormState> formKey, bool isSpecial) {
    GlobalKey<FormState> _formKey = GlobalKey();
    SpecialEquipment specialEquipment = new SpecialEquipment();
    showDialog(
        context: context,
        builder: (_) =>
            StatefulBuilder(builder: (BuildContext context, setState) {
              return AlertDialog(
                title: Text(
                  'Novo equipamento',
                  style: Theme.of(context).textTheme.headline5,
                ),
                content: Form(
                  key: formKey,
                  child: Container(
                    //height: isSpecial ? 384 : 256,
                    width: double.maxFinite,
                    child: ListView(
                      shrinkWrap: true,
                      //mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        equipmentNameField(specialEquipment, _formKey),
                        SizedBox(
                          height: 30.0,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Status atual do equipamento',
                            style: TextStyle(fontWeight: FontWeight.w500),
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
                          child: DropdownButton<String>(
                            underline: SizedBox(),
                            isExpanded: true,
                            value: specialEquipment.status,
                            onChanged: (value) {
                              setState(() {
                                specialEquipment.status = value;
                              });
                            },
                            items: equipmentStatusOptions.map((value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Container(
                                  padding: EdgeInsets.only(left: 6.0),
                                  child: Text(value),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(height: 30.0),
                        ToggleButtons(
                          borderRadius: BorderRadius.all(Radius.circular(6.0)),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Comum'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Especial'),
                            )
                          ],
                          isSelected: [!isSpecial, isSpecial],
                          fillColor: Colors.white,
                          color: Colors.red,
                          onPressed: (int index) {
                            if (index == 0) {
                              setState(() {
                                isSpecial = false;
                              });
                            } else if (index == 1) {
                              setState(() {
                                isSpecial = true;
                              });
                            }
                          },
                        ),
                        Visibility(
                            visible: isSpecial, child: SizedBox(height: 30.0)),
                        Visibility(
                          visible: isSpecial,
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Intervalo em dias entre manutenções preventivas',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        Visibility(
                            visible: isSpecial, child: SizedBox(height: 16.0)),
                        Visibility(
                          visible: isSpecial,
                          child: Container(
                            child: TextFormField(
                              key: formKey,
                              validator: (value) =>
                                  value.isEmpty ? 'Campo obrigatório' : null,
                              onChanged: (value) =>
                                  specialEquipment.interval = int.parse(value),
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                alignLabelWithHint: false,
                                labelText: 'Intervalo',
                                labelStyle: TextStyle(
                                    color: Colors.grey[800],
                                    height: 0.9,
                                    fontWeight: FontWeight.w600),
                                filled: true,
                                counterStyle: TextStyle(color: Colors.red),
                                hintText: 'Exemplo: 30',
                                contentPadding: EdgeInsets.only(
                                  left: 10.0,
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  Container(
                      padding: EdgeInsets.only(right: 14.0, bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          cancelButton(context),
                          ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState.validate() &&
                                  _formKey.currentState.validate()) {
                                Navigator.of(context).pop(true);
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Theme.of(context).buttonColor),
                            ),
                            child: Text(
                              'Salvar',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ))
                ],
              );
            })).then((result) {
      if (result) {
        setState(() {
          /* Verifica caso o equipamento em questão seja especial */
          if (isSpecial == false) {
            Equipment defaultEquipment = new Equipment.fromSpecial(
                specialEquipment.description, specialEquipment.status);
            widget.currentDepartment.equipments.add(defaultEquipment);
          } else if (isSpecial == true) {
            widget.currentDepartment.equipments.add(specialEquipment);
          }
        });
      }
    });
  }

  String validateNewEquipment(String description) {
    String msg;
    if (description.isEmpty)
      msg = MSG_REQUIRED_FIELD;
    else if (widget.currentDepartment.equipments
        .any((element) => element.description == description))
      msg = MSG_EQUIPMENT_DESCRIPTION_ALREADY_EXISTS;
    return msg;
  }

  // Campo nome do equipamento a ser adicionado ao deprtamento
  Widget equipmentNameField(
      Equipment equipment, GlobalKey<FormState> equipmentFormKey) {
    TextEditingController controller =
        TextEditingController(text: equipment.description);
    return Form(
      key: equipmentFormKey,
      child: Container(
        child: TextFormField(
          validator: (value) => validateNewEquipment(value),
          onChanged: (value) => equipment.description = value,
          keyboardType: TextInputType.name,
          controller: controller,
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
      ),
    );
  }

  Widget cancelButton(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
      ),
      onPressed: () => Navigator.pop(context),
      child: Text(
        'Cancelar',
        style: TextStyle(color: Theme.of(context).buttonColor),
      ),
    );
  }
}
