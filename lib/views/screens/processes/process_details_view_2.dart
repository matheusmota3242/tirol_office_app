import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:tirol_office_app/mobx/equipment/equipment_mobx.dart';
import 'package:tirol_office_app/mobx/equipment_list.dart/equipment_list_mobx.dart';
import 'package:tirol_office_app/models/department_model.dart';
import 'package:tirol_office_app/models/process_model.dart';
import 'package:tirol_office_app/service/process_service.dart';
import 'package:tirol_office_app/service/user_service.dart';
import 'package:tirol_office_app/utils/page_utils.dart';
import 'package:tirol_office_app/views/widgets/process_card_item.dart';

class ProcessDetailsViewTwo extends StatefulWidget {
  final Process process;
  final bool edit;

  const ProcessDetailsViewTwo({Key key, this.process, this.edit})
      : super(key: key);
  @override
  _ProcessDetailsViewTwoState createState() => _ProcessDetailsViewTwoState();
}

class _ProcessDetailsViewTwoState extends State<ProcessDetailsViewTwo> {
  ProcessService processService = ProcessService();
  EquipmentListMobx equipmentListMobx = EquipmentListMobx();
  Department department = Department();
  bool isEquipmentOk(String status) => status == 'Funcionando';
  @override
  void initState() {
    initEquipmentListMobx();
    super.initState();
  }

  scanQRCode() async {
    await processService.finalQRCodeScan(context, widget.process);
  }

  /* Inicializando EquipmentListMobx */
  initEquipmentListMobx() {
    widget.process.getDepartment.equipments.forEach((equipment) {
      EquipmentMobx equipmentMobx = EquipmentMobx();
      equipmentMobx.setDescription(equipment.description);
      equipmentMobx.setStatus(equipment.status);
      equipmentListMobx.addEquipment(equipmentMobx);
    });
  }

  @override
  Widget build(BuildContext context) {
    var _userService = Provider.of<UserService>(context);

    Widget observationsField() {
      TextEditingController controller =
          TextEditingController(text: widget.process.getObservations);
      return Card(
        margin: EdgeInsets.all(0),
        child: Container(
          padding: EdgeInsets.all(20.0),
          width: double.maxFinite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Observações',
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(
                height: 12.0,
              ),
              TextFormField(
                onChanged: (value) => widget.process.setObservations = value,
                controller: controller,
                readOnly: processService.hasOwnership(
                            widget.process.userId, _userService.getUser.id) &&
                        widget.process.end != null
                    ? true
                    : false,
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  labelStyle: TextStyle(
                      color: Colors.grey[700],
                      height: 0.9,
                      fontWeight: FontWeight.w600),
                  filled: true,
                  counterStyle: TextStyle(color: Colors.red),
                  contentPadding: EdgeInsets.all(
                    10.0,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }

    /* Analisa se o usuário é dono processo e se o processo possui um campo fim */
    getQRCodeVisibility() =>
        _userService.getUser.id == widget.process.getUserId &&
        widget.process.getEnd == null;

    return Scaffold(
      appBar: AppBar(
        title: Text(PageUtils.PROCESS_DETIALS_TITLE),
        shadowColor: Colors.transparent,
        actions: [
          Visibility(
            visible: getQRCodeVisibility(),
            child: IconButton(
              icon: PageUtils.qrCodeIcon,
              onPressed: () {
                scanQRCode();
              },
            ),
          )
        ],
      ),
      body: Container(
          padding: EdgeInsets.all(12.0),
          color: PageUtils.PRIMARY_COLOR,
          child: ListView(
            children: [
              ProcessCardItem(
                isProcessDetailsView: true,
                isLastItem: false,
                process: widget.process,
              ),
              Card(
                margin: EdgeInsets.all(0),
                shadowColor: Colors.transparent,
                child: Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Equipamentos',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      SizedBox(
                        height: 12.0,
                      ),
                      equipmentListMobx.equipmentList.isEmpty
                          ? Text('Não há equipamentos cadastrados')
                          : Observer(
                              builder: (_) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: equipmentListMobx.equipmentList
                                    .map(
                                      (e) => processService.hasOwnership(
                                                  widget.process.getUserId,
                                                  _userService.getUser.id) &&
                                              widget.process.end == null
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  e.getDescription,
                                                  style: TextStyle(
                                                      color: e.getStatus ==
                                                              'Danificado'
                                                          ? Colors.red[400]
                                                          : Colors.black),
                                                ),
                                                Switch(
                                                    value: isEquipmentOk(
                                                        e.getStatus),
                                                    onChanged: (value) {
                                                      e.changeStatus(
                                                          e.getStatus);
                                                    }),
                                              ],
                                            )
                                          : Container(
                                              padding:
                                                  EdgeInsets.only(top: 8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(e.description),
                                                  Container(
                                                    height: 24,
                                                    width: 24,
                                                    child: Icon(
                                                      e.getStatus ==
                                                              'Danificado'
                                                          ? Icons
                                                              .warning_amber_rounded
                                                          : Icons.done,
                                                      color: Colors.white,
                                                      size: 16,
                                                    ),
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: e.getStatus ==
                                                                'Danificado'
                                                            ? Colors.red
                                                            : Colors.green),
                                                  ),
                                                ],
                                              ),
                                            ),
                                    )
                                    .toList(),
                              ),
                            )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              observationsField()
            ],
          )),
    );
  }
}
