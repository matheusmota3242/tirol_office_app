import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:tirol_office_app/helpers/equipment_helper.dart';
import 'package:tirol_office_app/models/enums/equipment_status_enum.dart';
import 'package:tirol_office_app/models/equipment_model.dart';
import 'package:tirol_office_app/service/department_service.dart';
import 'package:tirol_office_app/service/equipment_sevice.dart';

class DepartmentFormEquipmentItem extends StatefulWidget {
  final Equipment equipment;
  final bool editing;

  const DepartmentFormEquipmentItem(
      {Key key, @required this.equipment, this.editing})
      : super(key: key);

  @override
  _DepartmentFormEquipmentItem createState() => _DepartmentFormEquipmentItem();
}

class _DepartmentFormEquipmentItem extends State<DepartmentFormEquipmentItem> {
  @override
  Widget build(BuildContext context) {
    final EquipmentService _service = EquipmentService();
    var _departmentService =

        // Service recebe equipamento do componente
        _service.currentEquipment = widget.equipment;

    // Lista com opções do menu
    var equipmentStatusOptions = <String>['Funcionando', 'Danificado'];

    // Variáveis que guardam valores temporários
    String descriptionTemp = widget.equipment.getDescription;
    String statusTemp = widget.equipment.getStatus;

    // Atribui nova descrição ao equipamento do service
    void setEquipmentDescription(String value) {
      widget.equipment.setDescription = value;
      //_service.currentEquipment.setDescription(value);
    }

    // Atribui novo status ao equipamento do service
    void setEquipmentStatus(String value) {
      widget.equipment.setStatus = value;
    }

    // Botão de cancelar modal
    Widget cancelButton(BuildContext context) {
      return ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
        ),
        onPressed: () => Navigator.pop(context),
        child: Text(
          'Cancelar',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    // Campo descrição do equipamento
    Widget equipmentDescriptionField(String description) {
      TextEditingController controller =
          TextEditingController(text: description);
      return Container(
        child: TextFormField(
          validator: (value) => value.isEmpty ? 'Campo obrigatório' : null,
          onChanged: (value) => descriptionTemp = value.trim(),
          controller: controller,
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

    // Abre modal de edição
    void edit(Equipment equipment) {
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
                  equipmentDescriptionField(equipment.getDescription),
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
                      value: statusTemp,
                      onChanged: (value) {
                        print(value);
                        statusTemp = value;
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
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  setState(() {
                    if (widget.editing) {
                      setEquipmentDescription(descriptionTemp);
                      setEquipmentStatus(statusTemp);
                      Provider.of<DepartmentService>(context, listen: false)
                          .modifyEquipment(widget.equipment);
                    } else {
                      widget.equipment.setDescription = descriptionTemp;
                      widget.equipment.setStatus = statusTemp;
                    }
                    Navigator.of(context).pop(true);
                  });
                }
              },
              child: Text(
                'Salvar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    }

    void handleChoice(String value) {
      if (value == 'Editar') edit(widget.equipment);
    }

    var themeData = Theme.of(context);
    return Card(
      child: Container(
        height: 90.0,
        padding: EdgeInsets.all(12.0),
        child: Stack(
          children: [
            Positioned(
              child: Text(widget.equipment.getDescription,
                  style: Theme.of(context).textTheme.headline6),
            ),
            Positioned(
              //top: 28.0,
              bottom: 0.0,
              child: Row(
                children: [
                  Text(
                    'Status:',
                    style: themeData.textTheme.subtitle1,
                  ),
                  SizedBox(
                    width: 6.0,
                  ),
                  Text(
                    widget.equipment.getStatus ==
                            EquipmentHelper()
                                .getRoleByEnum(EquipmentStatus.ABLE)
                        ? 'Funcionando'
                        : 'Danificado',
                    style: TextStyle(fontSize: 15.0, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 0,
              top: 9.0,
              child: PopupMenuButton(
                onSelected: (value) => handleChoice(value),
                padding: EdgeInsets.all(0),
                itemBuilder: (_) => ['Editar']
                    .map(
                      (choice) => PopupMenuItem<String>(
                        child: Text(choice),
                        value: choice,
                      ),
                    )
                    .toList(),
              ),
              // child: IconButton(
              //   onPressed: () {edit(equipment)},
              //   icon: Icon(Icons.more_vert),
              // ),
            ),
          ],
        ),
      ),
    );
  }
}
