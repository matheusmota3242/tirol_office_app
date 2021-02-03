import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'package:tirol_office_app/auth/auth_service.dart';
import 'package:tirol_office_app/helpers/auth_helper.dart';
import 'package:tirol_office_app/views/screens/auth/login_view.dart';
import 'package:tirol_office_app/views/widgets/toast.dart';

class RegisterView extends StatelessWidget {
  AuthHelper _authHelper = AuthHelper();
  final _formKey = GlobalKey<FormState>();
  static const double _horizontalPadding = 50.0;
  String _email, _password, _passwordConfirm, _name;
  @override
  Widget build(BuildContext context) {
    AuthService _authService = Provider.of<AuthService>(context);
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        child: Form(
          child: ListView(
            children: [
              _registerImage(screenHeight),
              _titlePage(screenHeight),
              _nameField(screenHeight),
              _emailField(screenHeight),
              _passwordField(screenHeight),
              _confirmPasswordField(screenHeight),
              _registerButton(context, screenHeight, _authService)
            ],
          ),
          key: _formKey,
        ),
      ),
    );
  }

  Widget _registerImage(double screenHeight) {
    var heightImage = 150.0;
    var paddingTop = (screenHeight / 12);
    var paddingBottom = (screenHeight / 30);
    return SizedBox(
      child: Padding(
        padding: EdgeInsets.only(top: paddingTop, bottom: paddingBottom),
        child: SvgPicture.asset(
          'assets/images/register.svg',
          height: heightImage,
        ),
      ),
    );
  }

  Widget _titlePage(double screenHeight) {
    var fontSize = 36.0;
    var paddingBottom = (screenHeight / 40);
    return Padding(
      padding: EdgeInsets.only(bottom: paddingBottom),
      child: Center(
        child: Text(
          'Registro',
          style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              color: Colors.black54),
        ),
      ),
    );
  }

  Widget _emailField(double screenHeight) {
    var borderWidth = 1.0;
    var verticalPadding = (screenHeight / 40);
    var fieldVerticalPadding = 8.0;
    var fieldLeftPadding = 8.0;
    var fieldRightPadding = 0.0;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        _horizontalPadding,
        verticalPadding,
        _horizontalPadding,
        (verticalPadding / 2),
      ),
      child: TextFormField(
        validator: (value) => validateEmail(value),
        onChanged: (value) => _email = value.trim(),
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          filled: true,
          contentPadding: EdgeInsets.fromLTRB(fieldLeftPadding,
              fieldVerticalPadding, fieldRightPadding, fieldVerticalPadding),
          hintText: 'E-mail',
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _nameField(double screenHeight) {
    var borderWidth = 1.0;
    var verticalPadding = (screenHeight / 40);
    var fieldVerticalPadding = 8.0;
    var fieldLeftPadding = 8.0;
    var fieldRightPadding = 0.0;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        _horizontalPadding,
        verticalPadding,
        _horizontalPadding,
        (verticalPadding / 2),
      ),
      child: TextFormField(
        validator: (value) => _authHelper.validateName(value),
        onChanged: (value) => _name = value.trim(),
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          filled: true,
          contentPadding: EdgeInsets.fromLTRB(fieldLeftPadding,
              fieldVerticalPadding, fieldRightPadding, fieldVerticalPadding),
          hintText: 'Nome',
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _passwordField(double screenHeight) {
    var verticalPadding = (screenHeight / 40);
    var fieldVerticalPadding = 8.0;
    var fieldLeftPadding = 8.0;
    var fieldRightPadding = 0.0;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        _horizontalPadding,
        verticalPadding,
        _horizontalPadding,
        (verticalPadding / 2),
      ),
      child: Column(
        children: [
          TextFormField(
            validator: (value) => validatePassword(value),
            onChanged: (value) => _password = value.trim(),
            obscureText: true,
            decoration: InputDecoration(
              filled: true,
              counterStyle: TextStyle(color: Colors.red),
              hintText: 'Senha',
              contentPadding: EdgeInsets.fromLTRB(
                  fieldLeftPadding,
                  fieldVerticalPadding,
                  fieldRightPadding,
                  fieldVerticalPadding),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _confirmPasswordField(double screenHeight) {
    var verticalPadding = (screenHeight / 40);
    var fieldVerticalPadding = 8.0;
    var fieldLeftPadding = 8.0;
    var fieldRightPadding = 0.0;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        _horizontalPadding,
        verticalPadding,
        _horizontalPadding,
        (verticalPadding / 2),
      ),
      child: Column(
        children: [
          TextFormField(
            // ignore: missing_return
            validator: (value) {
              if (value.isEmpty) {
                return 'Por favor, confirme sua senha';
              }
              if (_password != _passwordConfirm) {
                return 'Senha e confirmação de senha incompatíveis';
              }
            },
            onChanged: (value) => _passwordConfirm = value.trim(),
            obscureText: true,
            decoration: InputDecoration(
              filled: true,
              counterStyle: TextStyle(color: Colors.red),
              hintText: 'Confirmar senha',
              contentPadding: EdgeInsets.fromLTRB(
                  fieldLeftPadding,
                  fieldVerticalPadding,
                  fieldRightPadding,
                  fieldVerticalPadding),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _registerButton(
      BuildContext context, double screenHeight, AuthService authService) {
    var buttonPadding = 16.0;
    var verticalPadding = (screenHeight / 40);
    return Padding(
      padding: EdgeInsets.fromLTRB(_horizontalPadding, verticalPadding,
          _horizontalPadding, verticalPadding),
      child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            signup(context, authService);
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
    );
  }

  String validateEmail(String email) {
    return _authHelper.validateEmail(email);
  }

  String validatePassword(String password) {
    return _authHelper.validatePassword(password);
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
