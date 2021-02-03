import 'package:flutter/material.dart';
import 'package:tirol_office_app/service/qrcode_service.dart';

class AppBarWidget extends PreferredSize {
  final String title;
  final QRCodeService _qrCodeService = QRCodeService();

  AppBarWidget(this.title);

  @override
  Size get preferredSize => AppBar().preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      //automaticallyImplyLeading: false,
      title: Text(this.title),
      backgroundColor: Theme.of(context).appBarTheme.color,
      actions: [
        IconButton(icon: Icon(Icons.date_range), onPressed: () {}),
        IconButton(
          icon: Icon(Icons.qr_code),
          onPressed: () => _qrCodeService.scanQRCode(context),
        ),
      ],
    );
  }
}
