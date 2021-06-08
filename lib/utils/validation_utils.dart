import 'package:email_validator/email_validator.dart';
import 'package:string_validator/string_validator.dart';

class ValidationUtils {
  isEmptyMessage(String field) => 'Por favor, preencha o campo $field';

  bool checkEmail(String email) {
    bool isValid = EmailValidator.validate(email);
    return isValid;
  }

  String validateName(String name) {
    if (name.isEmpty) {
      return isEmptyMessage('nome');
    } else if (!isAlpha(name)) {
      return 'Apenas letras podem ser utilizadas';
    }
  }

  String validatePhoneNumber(String phoneNumber) {
    if (phoneNumber.isEmpty)
      return isEmptyMessage('telefone');
    else if (!isNumeric(phoneNumber))
      return 'Apenas números podem ser utilizados';
    else if (phoneNumber.length > 13) return 'No máximo 13 dígitos';
  }

  String validateEmail(String email) {
    if (email.isEmpty) {
      return isEmptyMessage('e-mail');
    } else if (!checkEmail(email)) {
      return 'Formato de e-mail inválido';
    }
  }

  String validatePassword(String password) {
    if (password.isEmpty)
      return isEmptyMessage('senha');
    else if (!isAlphanumeric(password))
      return 'Sua senha deve conter apenas letras e/ou números';
    else if (password.length < 6)
      return 'Sua senha deve conter no mínimo 6 caracteres';
  }

  String validateActualPassword(String oldPassword, String value) {
    if (value.isEmpty) return isEmptyMessage('senha atual');
    if (value != oldPassword) return 'Senha atual não confere';
  }
}
