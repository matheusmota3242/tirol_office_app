import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import 'package:tirol_office_app/auth/auth_service.dart';
import 'package:tirol_office_app/utils/page_utils.dart';
import 'package:tirol_office_app/utils/validation_utils.dart';
import 'package:tirol_office_app/views/screens/auth/login_view.dart';
import 'package:tirol_office_app/views/widgets/toast.dart';

class RegisterView extends StatelessWidget {
  ValidationUtils _validationHelper = ValidationUtils();
  final _formKey = GlobalKey<FormState>();
  String _email, _password, _passwordConfirm, _name;

  @override
  Widget build(BuildContext context) {
    AuthService _authService = Provider.of<AuthService>(context);
    var screenSize = MediaQuery.of(context).size;
    var screenHeight = screenSize.height;
    var widgetsWidth = screenSize.width * 0.75;
    return Scaffold(
      body: Container(
        child: Form(
          child: ListView(
            children: [
              SizedBox(
                height: screenHeight * 0.08,
              ),
              _registerImage(screenHeight),
              SizedBox(
                height: 20,
              ),
              _titlePage(screenHeight),
              SizedBox(
                height: 20,
              ),
              _nameField(screenHeight, widgetsWidth),
              SizedBox(
                height: 20,
              ),
              _emailField(screenSize, widgetsWidth),
              SizedBox(
                height: 20,
              ),
              _passwordField(screenHeight, widgetsWidth),
              SizedBox(
                height: 20,
              ),
              _confirmPasswordField(screenHeight, widgetsWidth),
              SizedBox(
                height: 20,
              ),
              _registerButton(
                  context, screenHeight, widgetsWidth, _authService),
              SizedBox(
                height: 20,
              ),
              Center(
                child: SizedBox(
                  width: widgetsWidth,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: PageUtils.PRIMARY_COLOR,
                      ),
                    ),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.grey[200])),
                  ),
                ),
              )
            ],
          ),
          key: _formKey,
        ),
      ),
    );
  }

  Widget _registerImage(double screenHeight) {
    var imageHeight = 150.0;

    return SizedBox(
      child: SvgPicture.asset(
        'assets/images/register.svg',
        height: imageHeight,
      ),
    );
  }

  Widget _titlePage(double screenHeight) {
    var fontSize = 36.0;

    return Center(
      child: Text(
        'Registro',
        style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
            color: Colors.black54),
      ),
    );
  }

  Widget _emailField(Size screenSize, double width) {
    var fieldVerticalPadding = 8.0;
    var fieldLeftPadding = 8.0;
    var fieldRightPadding = 0.0;
    return Center(
      child: SizedBox(
        width: width,
        child: TextFormField(
          validator: (value) => validateEmail(value),
          onChanged: (value) => _email = value.trim(),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.email),
            filled: true,
            contentPadding: EdgeInsets.fromLTRB(fieldLeftPadding,
                fieldVerticalPadding, fieldRightPadding, fieldVerticalPadding),
            hintText: 'E-mail',
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }

  Widget _nameField(double screenHeight, double width) {
    var fieldVerticalPadding = 8.0;
    var fieldLeftPadding = 8.0;
    var fieldRightPadding = 0.0;
    return Center(
      child: SizedBox(
        width: width,
        child: TextFormField(
          //validator: (value) => _authHelper.validateName(value),
          validator: (value) =>
              value.isEmpty ? 'Por favor, informe seu nome' : null,
          onChanged: (value) => _name = value.trim(),
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.person),
            filled: true,
            contentPadding: EdgeInsets.fromLTRB(fieldLeftPadding,
                fieldVerticalPadding, fieldRightPadding, fieldVerticalPadding),
            hintText: 'Nome',
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }

  Widget _passwordField(double screenHeight, double width) {
    var fieldVerticalPadding = 8.0;
    var fieldLeftPadding = 8.0;
    var fieldRightPadding = 0.0;
    return Center(
      child: SizedBox(
        width: width,
        child: TextFormField(
          validator: (value) => validatePassword(value),
          onChanged: (value) => _password = value.trim(),
          obscureText: true,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock),
            filled: true,
            counterStyle: TextStyle(color: Colors.red),
            hintText: 'Senha',
            contentPadding: EdgeInsets.fromLTRB(fieldLeftPadding,
                fieldVerticalPadding, fieldRightPadding, fieldVerticalPadding),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }

  Widget _confirmPasswordField(double screenHeight, double width) {
    var fieldVerticalPadding = 8.0;
    var fieldLeftPadding = 8.0;
    var fieldRightPadding = 0.0;
    return Center(
      child: SizedBox(
        width: width,
        child: TextFormField(
          validator: (value) {
            String msg;
            if (value.isEmpty) {
              msg = 'Por favor, confirme sua senha';
            }
            if (_password != _passwordConfirm) {
              msg = 'Senha e confirmação de senha incompatíveis';
            }
            return msg;
          },
          onChanged: (value) => _passwordConfirm = value.trim(),
          obscureText: true,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock),
            filled: true,
            counterStyle: TextStyle(color: Colors.red),
            hintText: 'Confirmar senha',
            contentPadding: EdgeInsets.fromLTRB(fieldLeftPadding,
                fieldVerticalPadding, fieldRightPadding, fieldVerticalPadding),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }

  Widget _registerButton(BuildContext context, double screenHeight,
      double width, AuthService authService) {
    var buttonPadding = 16.0;
    return Center(
      child: SizedBox(
        width: width,
        child: RaisedButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          onPressed: () async {
            if (_formKey.currentState.validate()) {
              await signup(context, authService);
            }
          },
          child: Text(
            'Enviar',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          color: Theme.of(context).buttonColor,
          padding: EdgeInsets.only(top: buttonPadding, bottom: buttonPadding),
        ),
      ),
    );
  }

  String validateEmail(String email) {
    return _validationHelper.validateEmail(email);
  }

  String validatePassword(String password) {
    return _validationHelper.validatePasswordFields(password, 'senha');
  }

  dynamic signup(BuildContext context, AuthService authService) async {
    var result = await authService.signUp(
        email: _email, password: _password, name: _name);
    if (result is bool) {
      if (result) {
        Toasts.showToast(content: 'Registro realizado com sucesso');
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => LoginView(),
          ),
        );
      } else {
        Toasts.showToast(content: "Registro inválido");
      }
    } else {
      Toasts.showToast(content: "Registro inválido");
    }
  }
}
