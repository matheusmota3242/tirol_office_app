import 'package:flutter/material.dart';
import 'package:tirol_office_app/models/process_model.dart';
import 'package:tirol_office_app/utils/page_utils.dart';

class ProcessDetailsViewTwo extends StatefulWidget {
  final Process process;
  final bool edit;

  const ProcessDetailsViewTwo({Key key, this.process, this.edit})
      : super(key: key);
  @override
  _ProcessDetailsViewTwoState createState() => _ProcessDetailsViewTwoState();
}

class _ProcessDetailsViewTwoState extends State<ProcessDetailsViewTwo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(PageUtils.PROCESS_DETIALS_TITLE),
        shadowColor: Colors.transparent,
        actions: [
          IconButton(
            icon: PageUtils.qrCodeIcon,
            onPressed: () {
              //scanQRCode();
            },
          )
        ],
      ),
    );
  }
}
