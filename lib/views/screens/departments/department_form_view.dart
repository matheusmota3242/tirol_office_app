import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:tirol_office_app/models/enums/equipment_status_enum.dart';
import 'package:tirol_office_app/models/equipment_model.dart';
import 'package:tirol_office_app/service/department_service.dart';

class DepartmentFormView extends StatelessWidget {
  var equipmentStatus;
  var _departmentService = DepartmentService();
  var equipmentStatusOptions = <String>['Funcionando', 'Danificado'];
  @override
  Widget build(BuildContext context) {
    _departmentService = Provider.of<DepartmentService>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Novo departamento'),
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
            SizedBox(
              height: 10.0,
            ),
            Text(
              'Equipamentos',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700]),
            ),
            SizedBox(
              height: 12.0,
            ),
            Observer(
              builder: (_) => Container(
                child: _departmentService.getEquipment == null
                    ? Row(
                        children: [
                          Text(
                            'Nenhum equipamento adicionado.',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          IconButton(
                            onPressed: () => addEquipmentDialog(context),
                            color: Theme.of(context).buttonColor,
                            icon: Icon(Icons.add_circle),
                          )
                        ],
                      )
                    : Card(
                        child: Container(
                          height: 68.0,
                          padding: EdgeInsets.all(12.0),
                          child: Stack(
                            children: [
                              Positioned(
                                child: Text(
                                    '${_departmentService.equipment.getDescription}'),
                              ),
                              Positioned(
                                top: 28.0,
                                child: Text(
                                    _departmentService.equipment.getStatus ==
                                            EquipmentStatus.ABLE
                                        ? 'Funcionando'
                                        : 'Danificado'),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void addEquipmentDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    showDialog(
      context: context,
      child: AlertDialog(
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
                  child: Text('Status atual do equipamento',
                      style: TextStyle(fontWeight: FontWeight.w500)),
                ),
                SizedBox(
                  height: 16.0,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.all(Radius.circular(4.0))),
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 3.0),
                  child: Observer(
                    builder: (_) => DropdownButton<String>(
                      underline: SizedBox(),
                      isExpanded: true,
                      value: _departmentService.getEquipmentStatus,
                      onChanged: (value) {
                        selectStatusEquipment(value);
                      },
                      items: equipmentStatusOptions.map((value) {
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      cancelButton(context),
                      RaisedButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            Equipment equipment = new Equipment(
                                _departmentService.equipmentName,
                                EquipmentStatus.ABLE);
                            _departmentService.setEquipment(equipment);
                            Navigator.of(context, rootNavigator: true).pop();
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
    );
  }

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
