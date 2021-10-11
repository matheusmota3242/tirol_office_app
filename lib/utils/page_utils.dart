import 'package:flutter/material.dart';

import 'dart:math' as math;

class PageUtils {
  static const PROCESSES_TITLE = 'Processos';
  static const DEPARTIMENTS_TITLE = 'Departamentos';
  static const OBSERVATIONS_TITLE = 'Observações';
  static const observationDetailsTitle = 'Detalhes da observação';
  static const EQUIPMENTS_TITLE = 'Equipamentos';
  static const MAINTENANCES_TITLE = 'Manutenções';
  static const EQUIPMENT_DETAILS_TITLE = 'Detalhes do equipamento';
  static const maintenanceForm = 'Nova manutenção';
  static const EQUIPMENT_PREVENTIVE_MAINTENANCE_FORM_TITLE =
      'Nova manutenção preventiva';
  static const OBSERVATIONS_DETAILS_TITLE = 'Detalhes da observação';
  static const SERVICES_TITLE = 'Serviços';
  static const SERVICES_FORM_TITLE = 'Novo serviço';
  static const PERSONAL_INFO_TITLE = 'Informações pessoais';
  static const PERSONAL_INFO_PASSWORD = 'Alterar senha';
  static const USERS_TITLE = 'Usuários';
  static const PROCESS_DETIALS_TITLE = 'Detalhes do processo';
  static const SERVICE_PROVIDER_TITLE = 'Detalhes do serviço';
  static const UNITS_TITLE = 'Unidades';

  static const STATUS_WORKING = 'Funcionando';
  static const STATUS_DAMAGED = 'Danificado';

  static const String NAME_FIELD = 'Nome';
  static const String EMAIL_FIELD = 'Email';
  static const String PASSWORD_FIELD = 'Senha';
  static const String ACTUAL_PASSWORD_FIELD = 'Senha atual';
  static const String NEW_PASSWORD_FIELD = 'Nova senha';
  static const String CONFIRM_NEW_PASSWORD_FIELD = 'Confirmar nova senha';

  static const PRIMARY_COLOR = Color(0xFF166D97);
  static const EdgeInsets BODY_PADDING = EdgeInsets.all(BODY_PADDING_VALUE);
  static const double cardPadding = 20.0;
  static const double BODY_PADDING_VALUE = 16.0;
  static const List<double> alertDialogPaddingRB = [14.0, 8.0];
  static const double cardBorderRadius = 8.0;
  static const Icon qrCodeIcon = Icon(Icons.qr_code);
  static const List<IconData> fabIcons = const [Icons.done, Icons.close];
  static const List<Color> fabIconsColors = const [PRIMARY_COLOR, Colors.red];

  static const textButtonStyle = TextStyle(
      color: PRIMARY_COLOR, fontWeight: FontWeight.w500, fontSize: 15);

  static Widget horizonalSeparatorGrey = Column(
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

  static Widget HORIZONTAL_SEPARATOR_WHITE = Column(
    children: [
      SizedBox(
        height: 16.0,
      ),
      Container(
        width: double.maxFinite,
        height: 0.5,
        color: Colors.white,
      ),
      SizedBox(
        height: 16.0,
      ),
    ],
  );

  static Widget getFloatActionButton(AnimationController animationController,
      Function persist, Function cancel) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(fabIcons.length, (int index) {
        Widget child = Container(
          height: 70.0,
          width: 56.0,
          alignment: FractionalOffset.topCenter,
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: animationController,
              curve: Interval(0.0, 1.0 - index / fabIcons.length / 2.0,
                  curve: Curves.easeOut),
            ),
            child: FloatingActionButton(
              heroTag: null,
              backgroundColor: fabIconsColors[index],
              mini: true,
              child: Icon(fabIcons[index], color: Colors.white),
              onPressed: () => index == 0 ? persist() : cancel(),
            ),
          ),
        );
        return child;
      }).toList()
        ..add(
          FloatingActionButton(
            backgroundColor: PRIMARY_COLOR,
            heroTag: null,
            child: AnimatedBuilder(
              animation: animationController,
              builder: (context, child) => Transform(
                transform: new Matrix4.rotationZ(
                    animationController.value * 0.5 * math.pi),
                alignment: FractionalOffset.center,
                child: Icon(animationController.isDismissed
                    ? Icons.share
                    : Icons.close),
              ),
            ),
            onPressed: () {
              if (animationController.isDismissed) {
                animationController.forward();
              } else {
                animationController.reverse();
              }
            },
          ),
        ),
    );
  }

  static Widget getAttributeField(String field, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          field,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.grey[600]),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget getTextFormField(String label) {
    return TextFormField(
      onChanged: (value) => {},
      validator: (value) => value.isEmpty ? 'Campo obrigatório' : null,
      decoration: InputDecoration(
        alignLabelWithHint: true,
        labelText: label,
        labelStyle: TextStyle(
            color: Colors.grey[700], height: 0.9, fontWeight: FontWeight.w600),
        filled: true,
        counterStyle: TextStyle(color: Colors.red),
        hintText: label,
        contentPadding: EdgeInsets.only(
          left: 10.0,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
