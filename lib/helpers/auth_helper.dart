import 'package:email_validator/email_validator.dart';

class AuthHelper {
  bool checkEmail(String email) {
    bool isValid = EmailValidator.validate(email);
    return isValid;
  }

  String validateEmail(String email) {
    if (email.isEmpty) {
      return 'Por favor, preencha o campo de e-mail';
    } else if (!checkEmail(email)) {
      return 'Formato de e-mail inválido';
    }
  }

  String validatePassword(String password) {
    if (password.isEmpty) {
      return 'Por favor, preencha o campo de senha';
    } else if (password.length < 6) {
      return 'Sua senha deve conter no mínimo 6 caracteres';
    }
  }
}
