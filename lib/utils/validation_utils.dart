import 'package:email_validator/email_validator.dart';
import 'package:string_validator/string_validator.dart';

class ValidationUtils {
  static const String PASSWORD_FIELD = 'senha';
  static const String ACTUAL_PASSWORD_FIELD = 'senha atual';
  static const String NEW_PASSWORD_FIELD = 'nova senha';
  static const String CONFIRM_NEW_PASSWORD_FIELD = 'confirmação de nova senha';

  isEmptyMessage(String field) => 'Por favor, preencha o campo $field';

  isEmpty(String value) {
    if (value.isEmpty) return 'Campo obrigatório';
  }

  bool checkEmail(String email) {
    bool isValid = EmailValidator.validate(email);
    return isValid;
  }

  validateName(String name) {
    String msg;
    if (name.isEmpty) {
      return isEmptyMessage('nome');
    }
  }

  validatePhoneNumber(String phoneNumber) {
    if (phoneNumber.isEmpty)
      return isEmptyMessage('telefone');
    else if (!isNumeric(phoneNumber))
      return 'Apenas números podem ser utilizados';
    else if (phoneNumber.length > 13) return 'No máximo 13 dígitos';
  }

  validateEmail(String email) {
    if (email.isEmpty) {
      return isEmptyMessage('e-mail');
    } else if (!checkEmail(email)) {
      return 'Formato de e-mail inválido';
    }
  }

  validatePasswordFields(String password, String field) {
    if (password.isEmpty)
      return isEmptyMessage(field);
    else if (!isAlphanumeric(password))
      return 'Sua $field deve conter apenas letras e/ou números';
    else if (password.length < 6)
      return 'Sua $field deve conter no mínimo 6 caracteres';
  }

  validateActualPassword(String oldPassword, String value) {
    if (value.isEmpty) return isEmptyMessage('senha atual');
    if (value != oldPassword) return 'Senha atual não confere';
  }
}
