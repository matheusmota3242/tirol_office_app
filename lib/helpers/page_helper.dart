import 'package:flutter/material.dart';

class PageHelper {
  static const processes = 'Processos';
  static const departaments = 'Departamentos';
  static const observations = 'Observações';
  static const services = 'Serviços';
  static const servicesForm = 'Novo serviço';
  static const users = 'Usuários';
  static const processDetails = 'Detalhes do processo';
  static const serviceProvider = 'Detalhes do serviço';

  static const double bodyPadding = 12.0;
  static const double cardBorderRadius = 8.0;

  static const Icon qrCodeIcon = Icon(Icons.qr_code);
  static const List<IconData> fabIcons = const [Icons.done, Icons.close];
  static const List<Color> fabIconsColors = const [
    Color(0xFF166D97),
    Color(0xffef5350)
  ];
}
