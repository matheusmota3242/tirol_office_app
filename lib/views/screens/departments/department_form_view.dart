import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:tirol_office_app/service/department_service.dart';

class DepartmentFormView extends StatelessWidget {
  var equipmentStatus;
  var _departmentService = DepartmentService();
  var equipmentStatusOptions = <String>['Funcionando', 'Danificado'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Novo departamento'),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: ListView(
          children: [
            departmentNameField,
            Container(
              child: Row(
                children: [
                  Text('Nenhum equipamento adicionado.'),
                  IconButton(
                    onPressed: () => addEquipment(context),
                    icon: Icon(Icons.add_circle),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void addEquipment(BuildContext context) {
    showDialog(
      context: context,
      child: AlertDialog(
        title: Text('Novo equipamento'),
        content: Container(
          height: 300.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              equipmentNameField,
              SizedBox(
                height: 40.0,
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
              submitButton,
            ],
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
  Widget equipmentNameField = Container(
    child: TextFormField(
      decoration: InputDecoration(
        alignLabelWithHint: true,
        labelText: 'Nome',
        labelStyle: TextStyle(
            color: Colors.grey[800], height: 0.9, fontWeight: FontWeight.w600),
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

  // Campo nome do deprtamento a ser adicionado
  Widget departmentNameField = Container(
    child: TextFormField(
      decoration: InputDecoration(
        alignLabelWithHint: true,
        labelText: 'Nome',
        labelStyle: TextStyle(color: Colors.grey[800], height: 0.9),
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

  Widget submitButton = TextButton(
    onPressed: () {},
    child: Text('Salvar'),
  );
}
