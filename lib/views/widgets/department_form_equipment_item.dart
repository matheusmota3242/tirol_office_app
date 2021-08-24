import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'package:tirol_office_app/helpers/equipment_helper.dart';
import 'package:tirol_office_app/mobx/equipment/equipment_mobx.dart';
import 'package:tirol_office_app/models/enums/equipment_status_enum.dart';
import 'package:tirol_office_app/models/equipment_model.dart';
import 'package:tirol_office_app/service/equipment_sevice.dart';

class DepartmentFormEquipmentItem extends StatefulWidget {
  final EquipmentMobx mobx;
  final bool editing;
  final Function remove;
  final Function check;

  const DepartmentFormEquipmentItem(
      {Key key, this.editing, this.remove, this.mobx, this.check})
      : super(key: key);

  @override
  _DepartmentFormEquipmentItem createState() => _DepartmentFormEquipmentItem();
}

class _DepartmentFormEquipmentItem extends State<DepartmentFormEquipmentItem> {
  @override
  Widget build(BuildContext context) {
    final EquipmentService _service = EquipmentService();

    // // Service recebe equipamento do componente
    // _service.currentEquipment = widget.equipment;

    // // Lista com opções do menu
    var equipmentStatusOptions = <String>['Funcionando', 'Danificado'];

    // Botão de cancelar modal
    Widget cancelButton(
        BuildContext context, String oldStatus, String oldDescription) {
      return TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
        ),
        onPressed: () {
          widget.mobx.setStatus(oldStatus);
          widget.mobx.setDescription(oldDescription);
          Navigator.pop(context);
        },
        child: Text(
          'Cancelar',
          style: TextStyle(color: Theme.of(context).buttonColor),
        ),
      );
    }

    // Campo descrição do equipamento
    Widget equipmentDescriptionField(String description, GlobalKey formKey) {
      return Container(
        child: TextFormField(
          validator: (value) => value.isEmpty ? 'Campo obrigatório' : null,
          onChanged: (value) {
            widget.mobx.setDescription(value);
          },
          initialValue: description,
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
    // void updateEquipment() {
    //   setState(() {
    //     setEquipmentDescription(descriptionTemp);
    //     setEquipmentStatus(statusTemp);
    //   });
    // }

    showDeleteDialog() {
      showDialog(
        context: context,
        builder: (_) => StatefulBuilder(
            builder: (BuildContext localContext, innerSetState) {
          return AlertDialog(
            title: Text(
              'Remover',
              style: TextStyle(color: Colors.red[500]),
            ),
            content: Text('Você realmente deseja remover esse item?'),
            actions: [
              Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(localContext);
                      },
                      child: Text('Cancelar'),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        widget.remove(widget.mobx.getDescription);
                        Navigator.pop(localContext);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).buttonColor),
                      ),
                      child: Text('Sim'),
                    )
                  ],
                ),
              )
            ],
          );
        }),
      );
    }

    // Abre modal de edição
    void edit() {
      final _formKey = GlobalKey<FormState>();
      String descriptionTemp = widget.mobx.getDescription;
      String statusTemp = widget.mobx.getStatus;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) =>
            StatefulBuilder(builder: (BuildContext localContext, setState) {
          return AlertDialog(
            title: Text('Editar equipamento'),
            content: Form(
              key: _formKey,
              child: Observer(
                builder: (_) => Container(
                  height: 190.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      equipmentDescriptionField(
                          widget.mobx.getDescription, _formKey),
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
                          value: widget.mobx.getStatus,
                          onChanged: (value) {
                            widget.mobx.setStatus(value);
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
            ),
            actions: [
              Container(
                padding: EdgeInsets.only(right: 14.0, bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    cancelButton(localContext, statusTemp, descriptionTemp),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).buttonColor),
                      ),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          Navigator.of(localContext).pop();
                        } else {
                          widget.mobx.setStatus(statusTemp);
                          widget.mobx.setDescription(descriptionTemp);
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

    // void handleChoice(String value) {
    //   if (value == 'Editar') edit(widget.equipment);
    // }

    var themeData = Theme.of(context);
    return InkWell(
      onLongPress: () => showDeleteDialog(),
      onDoubleTap: () => edit(),
      child: Observer(
        builder: (_) => Card(
          child: Container(
            height: 90.0,
            padding: EdgeInsets.all(12.0),
            child: Stack(
              children: [
                Positioned(
                  child: Text(widget.mobx.getDescription,
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
                        widget.mobx.getStatus ==
                                EquipmentHelper()
                                    .getRoleByEnum(EquipmentStatus.ABLE)
                            ? 'Funcionando'
                            : 'Danificado',
                        style:
                            TextStyle(fontSize: 15.0, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
                // Positioned(
                //   right: 0,
                //   top: 9.0,
                //   child: PopupMenuButton(
                //     onSelected: (value) => null,
                //     padding: EdgeInsets.all(0),
                //     itemBuilder: (_) => ['Editar', 'Remover']
                //         .map(
                //           (choice) => PopupMenuItem<String>(
                //             child: Text(choice),
                //             value: choice,
                //           ),
                //         )
                //         .toList(),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
