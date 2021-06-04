import 'package:flutter/material.dart';

import 'package:tirol_office_app/helpers/equipment_helper.dart';
import 'package:tirol_office_app/models/enums/equipment_status_enum.dart';
import 'package:tirol_office_app/models/equipment_model.dart';
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

    // Atualiza equipamento após confirmação do modal
    void updateEquipment() {
      setState(() {
        setEquipmentDescription(descriptionTemp);
        setEquipmentStatus(statusTemp);
      });
    }

    // Abre modal de edição
    void edit(Equipment equipment) {
      final _formKey = GlobalKey<FormState>();

      showDialog(
        context: context,
        builder: (_) =>
            StatefulBuilder(builder: (BuildContext context, setState) {
          return AlertDialog(
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
                          setState(() {
                            print('novo valor: ' + value);
                            widget.equipment.setStatus = value;
                            statusTemp = value;
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
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).buttonColor),
                      ),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          updateEquipment();
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
          );
        }),
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
                itemBuilder: (_) => ['Editar', 'Remover']
                    .map(
                      (choice) => PopupMenuItem<String>(
                        child: Text(choice),
                        value: choice,
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
