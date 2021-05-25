import 'package:email_validator/email_validator.dart';
import 'package:string_validator/string_validator.dart';

class ValidationHelper {
  bool checkEmail(String email) {
    bool isValid = EmailValidator.validate(email);
    return isValid;
  }

  String validateName(String name) {
    if (name.isEmpty) {
      return 'Por favor, preencha o campo nome';
    } else if (!isAlpha(name)) {
      return 'Apenas letras podem ser utilizadas';
    }
  }

  String validatePhoneNumber(String phoneNumber) {
    if (phoneNumber.isEmpty)
      return 'Por favor, preencha o campo telefone';
    else if (!isNumeric(phoneNumber))
      return 'Apenas números podem ser utilizados';
    else if (phoneNumber.length > 13) return 'No máximo 13 dígitos';
  }

  String validateEmail(String email) {
    if (email.isEmpty) {
      return 'Por favor, preencha o campo e-mail';
    } else if (!checkEmail(email)) {
      return 'Formato de e-mail inválido';
    }
  }

  String validatePassword(String password) {
    if (password.isEmpty) {
      return 'Por favor, preencha o campo senha';
    } else if (!isAlphanumeric(password)) {
      return 'Sua senha deve conter apenas letras e/ou números';
    } else if (password.length < 6) {
      return 'Sua senha deve conter no mínimo 6 caracteres';
    }
  }
}
