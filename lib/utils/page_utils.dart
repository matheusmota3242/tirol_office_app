import 'package:flutter/material.dart';

class PageUtils {
  static const processes = 'Processos';
  static const departaments = 'Departamentos';
  static const observations = 'Observações';
  static const observationDetails = 'Detalhes da observação';
  static const services = 'Serviços';
  static const servicesForm = 'Novo serviço';
  static const personalInfo = 'Informações pessoais';
  static const personalInfoPassword = 'Alterar senha';
  static const users = 'Usuários';
  static const processDetails = 'Detalhes do processo';
  static const serviceProvider = 'Detalhes do serviço';

  static const String NAME_FIELD = 'Nome';
  static const String EMAIL_FIELD = 'Email';
  static const String PASSWORD_FIELD = 'Senha';
  static const String ACTUAL_PASSWORD_FIELD = 'Senha atual';
  static const String NEW_PASSWORD_FIELD = 'Nova senha';
  static const String CONFIRM_NEW_PASSWORD_FIELD = 'Confirmar nova senha';

  static const primaryColor = Color(0xFF166D97);
  static const EdgeInsets bodyPadding = EdgeInsets.all(bodyPaddingValue);
  static const double cardPadding = 20.0;
  static const double bodyPaddingValue = 16.0;
  static const List<double> alertDialogPaddingRB = [14.0, 8.0];
  static const double cardBorderRadius = 8.0;
  static const Icon qrCodeIcon = Icon(Icons.qr_code);
  static const List<IconData> fabIcons = const [Icons.done, Icons.close];
  static const List<Color> fabIconsColors = const [primaryColor, Colors.red];

  static const textButtonStyle =
      TextStyle(color: primaryColor, fontWeight: FontWeight.w500, fontSize: 15);

  Widget separator = Column(
    children: [
      SizedBox(
        height: 16.0,
      ),
      Container(
        width: double.maxFinite,
        height: 0.5,
        color: Colors.grey[400],
      ),
      SizedBox(
        height: 16.0,
      ),
    ],
  );
}
