import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:tirol_office_app/views/widgets/dialogs.dart';

class QRCodeService {
  // Método que escaneia o QRCode
  void scanQRCode(BuildContext context) async {
    String response = await FlutterBarcodeScanner.scanBarcode(
        '#FF0000', "Cancelar", true, ScanMode.QR);

    if (response == '-1') {
      // Caso o leitor não reconheça o código QR...
      Dialogs().showScannerErrorDialog(context);
    } else {
      // Caso reconheça como um código QR válido...
      Dialogs().showCheckinDialog(context, response);
    }
  }
}
