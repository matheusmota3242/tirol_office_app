import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import 'package:tirol_office_app/auth/auth_service.dart';
import 'package:tirol_office_app/views/widgets/menu_drawer.dart';
import '';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _authService = Provider.of<AuthService>(context);
    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        title: Text('Home'),
        backgroundColor: Theme.of(context).appBarTheme.color,
        actions: [
          IconButton(icon: Icon(Icons.date_range), onPressed: () {}),
          IconButton(
            icon: Icon(Icons.qr_code),
            onPressed: () => scanQRCode(context),
          ),
        ],
      ),
      drawer: MenuDrawer(
        userEmail: _authService.user.email,
      ),
      body: Container(
        padding: EdgeInsets.all(12.0),
        child: ListView(
          children: [
            Container(
              height: 132.0,
              child: Card(
                child: Container(
                  padding: EdgeInsets.all(12.0),
                  child: Stack(
                    children: [
                      Positioned(
                          child: Text(
                            'Banheiro 1',
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[800]),
                          ),
                          top: 0,
                          left: 0),
                      Positioned(
                        child: Text(
                          'Em andamento',
                          style: TextStyle(
                              color: Colors.yellow[600],
                              fontStyle: FontStyle.italic,
                              fontSize: 14.0),
                        ),
                        top: 0,
                        right: 0,
                      ),
                      Positioned(
                        child: Row(
                          children: [
                            Text(
                              'Horário:',
                              style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[800]),
                            ),
                            SizedBox(
                              width: 6.0,
                            ),
                            Text(
                              '15:00 - 15:40',
                              style: TextStyle(
                                  fontSize: 15.0, color: Colors.grey[800]),
                            ),
                          ],
                        ),
                        top: 40.0,
                      ),
                      Positioned(
                        child: Row(
                          children: [
                            Text(
                              'Responsável:',
                              style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[800]),
                            ),
                            SizedBox(
                              width: 6.0,
                            ),
                            Text(
                              'Regiane Silva',
                              style: TextStyle(
                                  fontSize: 15.0, color: Colors.grey[800]),
                            ),
                          ],
                        ),
                        top: 80.0,
                      ),
                      Positioned(
                          child: IconButton(
                            icon: Icon(Icons.search),
                          ),
                          right: 0,
                          top: 22.0)
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Método que escaneia o QRCode
  void scanQRCode(BuildContext context) async {
    String response = await FlutterBarcodeScanner.scanBarcode(
        '#FF0000', "Cancelar", true, ScanMode.QR);
    showDialog(
      context: context,
      child: AlertDialog(
        title: Text('Checkin'),
        content: Text('Deseja realizar o checkin em ' + response + '?'),
        actions: [
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Sim'),
          )
        ],
      ),
    );
  }
}
