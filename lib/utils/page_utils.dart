import 'package:flutter/material.dart';

class PageUtils {
  static const PROCESSES_TITLE = 'Processos';
  static const DEPARTIMENTS_TITLE = 'Departamentos';
  static const OBSERVATIONS_TITLE = 'Observações';
  static const EQUIPMENTS_TITLE = 'Equipamentos';
  static const OBSERVATIONS_DETAILS_TITLE = 'Detalhes da observação';
  static const SERVICES_TITLE = 'Serviços';
  static const SERVICES_FORM_TITLE = 'Novo serviço';
  static const PERSONAL_INFO_TITLE = 'Informações pessoais';
  static const PERSONAL_INFO_PASSWORD = 'Alterar senha';
  static const USERS_TITLE = 'Usuários';
  static const PROCESS_DETIALS_TITLE = 'Detalhes do processo';
  static const SERVICE_PROVIDER_TITLE = 'Detalhes do serviço';

  static const STATUS_WORKING = 'Funcionando';
  static const STATUS_DAMAGED = 'Danificado';

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
