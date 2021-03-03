import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tirol_office_app/helpers/page_helper.dart';
import 'package:tirol_office_app/service/qrcode_service.dart';
import 'package:tirol_office_app/views/widgets/appbar.dart';
import 'package:tirol_office_app/views/widgets/process_card_item.dart';

class ProcessDetailsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _qrCodeService = Provider.of<QRCodeService>(context);
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (arguments != null) print(arguments['process']);
    return Scaffold(
      appBar: AppBarWidget(PageHelper.processDetails),
      body: Container(
        color: Colors.grey[200],
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            ProcessCardItem(
              process: arguments['process'] == null
                  ? _qrCodeService.currentProcess
                  : arguments['process'],
              isProcessDetailsView: true,
            )
          ],
        ),
      ),
    );
  }
}
