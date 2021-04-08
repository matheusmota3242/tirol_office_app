import 'package:flutter/material.dart';
import 'package:tirol_office_app/models/department_model.dart';
import 'dart:math' as math;

import 'package:tirol_office_app/models/equipment_model.dart';
import 'package:tirol_office_app/views/widgets/department_form_equipment_item.dart';

class DepartmentTestView extends StatefulWidget {
  final Department currentDepartment;
  final bool edit;

  const DepartmentTestView({Key key, this.currentDepartment, this.edit})
      : super(key: key);
  @override
  _DepartmentTestViewState createState() => _DepartmentTestViewState();
}

class _DepartmentTestViewState extends State<DepartmentTestView>
    with TickerProviderStateMixin {
  var equipmentStatusOptions = <String>['Funcionando', 'Danificado'];
  static const List<IconData> fabIcons = const [Icons.done, Icons.close];
  static const List<Color> fabIconsColors = const [Colors.green, Colors.red];
  AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    print(widget.currentDepartment.equipments.length);
    super.initState();
  }

  bool checkEdition() => widget.edit ? true : false;

  @override
  Widget build(BuildContext context) {
    var themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title:
            Text(checkEdition() ? 'Editar departamento' : 'Novo departamento'),
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
                // !!!build
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
                    showAddEquipmentDialog(_formKey, new Equipment());
                  },
                  color: Theme.of(context).buttonColor,
                  icon: Icon(Icons.add_circle),
                )
              ],
            ),
            Container(
              child: widget.currentDepartment.equipments.isEmpty
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

  showAddEquipmentDialog(GlobalKey<FormState> formKey, Equipment equipment) {
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(builder: (_, setState) {
        return AlertDialog(
          title: Text('Novo equipamento'),
          content: Form(
            key: formKey,
            child: Container(
              height: 190.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  equipmentNameField(equipment),
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
                      // !!!
                      value: equipment.getStatus,

                      onChanged: (value) {
                        // !!!
                        //selectStatusEquipment(value);
                        setState(() {
                          equipment.setStatus = value;
                        });
                      },
                      items: equipmentStatusOptions.map((value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
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
                if (formKey.currentState.validate()) {
                  Navigator.of(context).pop(true);
                }
              },
              child: Text(
                'Salvar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      }),
    ).then((result) {
      if (result) {
        setState(() {
          widget.currentDepartment.equipments.add(equipment);
        });
        // !!!
        // Equipment equipment = new Equipment(
        //   _departmentService.equipmentName,
        //   EquipmentHelper().getRoleByEnum(EquipmentStatus.ABLE),
        //);
        //setState(() {
        //  _departmentService.equipments.add(equipment);
        //});
      }
    });
  }

  // Campo nome do deprtamento a ser adicionado
  Widget departmentNameField() {
    TextEditingController controller =
        TextEditingController(text: widget.currentDepartment?.name);
    return Container(
      child: TextFormField(
        // !!!
        onChanged: (value) => null,
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

  // Campo nome do equipamento a ser adicionado ao deprtamento
  Widget equipmentNameField(Equipment equipment) {
    TextEditingController controller =
        TextEditingController(text: equipment.getDescription);
    return Container(
      child: TextFormField(
        validator: (value) => value.isEmpty ? 'Campo obrigatório' : null,
        // !!!
        //onChanged: (value) => setEquipmentName(value.trim()),
        onChanged: (value) => equipment.setDescription = value,
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
}
