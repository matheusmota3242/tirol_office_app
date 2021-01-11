import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tirol_office_app/views/screens/auth/forgot_password_view.dart';
import 'package:tirol_office_app/views/screens/auth/register_view.dart';
import 'package:tirol_office_app/views/screens/home_view.dart';

class LoginView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  static const double _horizontalPadding = 50.0;
  @override
  Widget build(BuildContext context) {
    // Altura da página
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _loginImage(screenHeight),
              _titlePage(screenHeight),
              _usernameField(screenHeight),
              _passwordField(screenHeight),
              _forgotPasswordButton(screenHeight, context),
              _submitButton(context, screenHeight),
              _orText(),
              _registerButton(context, screenHeight)
            ],
          ),
        ),
      ),
    );
  }

  // Imagem da página
  Widget _loginImage(double screenHeight) {
    var heightImage = 150.0;
    var paddingTop = (screenHeight / 12);
    var paddingBottom = (screenHeight / 30);
    return SizedBox(
      child: Padding(
        padding: EdgeInsets.only(top: paddingTop, bottom: paddingBottom),
        child: SvgPicture.asset(
          'assets/images/login.svg',
          height: heightImage,
        ),
      ),
    );
  }

  // Título da página
  Widget _titlePage(double screenHeight) {
    var fontSize = 36.0;
    var paddingBottom = (screenHeight / 40);
    return Padding(
      padding: EdgeInsets.only(bottom: paddingBottom),
      child: Center(
        child: Text(
          'Login',
          style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              color: Colors.black54),
        ),
      ),
    );
  }

  // Campo do usuário
  Widget _usernameField(double screenHeight) {
    var borderWidth = 1.0;
    var verticalPadding = (screenHeight / 40);
    var fieldVerticalPadding = 8.0;
    var fieldLeftPadding = 8.0;
    var fieldRightPadding = 0.0;
    return Padding(
      padding: EdgeInsets.fromLTRB(_horizontalPadding, verticalPadding,
          _horizontalPadding, verticalPadding),
      child: TextFormField(
        decoration: InputDecoration(
          filled: true,
          contentPadding: EdgeInsets.fromLTRB(fieldLeftPadding,
              fieldVerticalPadding, fieldRightPadding, fieldVerticalPadding),
          hintText: 'Usuário',
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  // Campo do senha
  Widget _passwordField(double screenHeight) {
    var verticalPadding = (screenHeight / 40);
    var fieldVerticalPadding = 8.0;
    var fieldLeftPadding = 8.0;
    var fieldRightPadding = 0.0;
    return Padding(
      padding: EdgeInsets.fromLTRB(
          _horizontalPadding, verticalPadding, _horizontalPadding, 0.0),
      child: Column(
        children: [
          TextFormField(
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

  // Botão "esqueceu a senha?"
  Widget _forgotPasswordButton(double screenHeight, BuildContext context) {
    return Container(
      height: 32.0,
      padding: EdgeInsets.only(right: _horizontalPadding),
      alignment: Alignment.topRight,
      child: TextButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ForgotPasswordView(),
          ),
        ),
        child: Text(
          'Esqueceu a senha?',
          style: TextStyle(fontSize: 12),
        ),
      ),
    );
  }

  // Botão de submissão do formulário
  Widget _submitButton(BuildContext context, double screenHeight) {
    var buttonPadding = 16.0;
    var verticalPadding = (screenHeight / 40);
    return Padding(
      padding: EdgeInsets.fromLTRB(_horizontalPadding, verticalPadding,
          _horizontalPadding, verticalPadding),
      child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => HomeView(),
          ),
        ),
        child: Text(
          'Entrar',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        color: Theme.of(context).buttonColor,
        padding: EdgeInsets.only(top: buttonPadding, bottom: buttonPadding),
      ),
    );
  }

  Widget _orText() {
    var verticalPadding = 10.0;
    return Container(
      padding: EdgeInsets.only(top: verticalPadding, bottom: verticalPadding),
      alignment: Alignment.center,
      child: Text(
        'ou',
        style: TextStyle(color: Colors.black54),
      ),
    );
  }

  Widget _registerButton(BuildContext context, double screenHeight) {
    var verticalPadding = (screenHeight / 40);
    var buttonPadding = 16.0;
    return Padding(
      padding: EdgeInsets.fromLTRB(_horizontalPadding, verticalPadding,
          _horizontalPadding, verticalPadding),
      child: RaisedButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => RegisterView(),
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        color: Colors.grey[200],
        child: Text(
          'Registre-se',
          style: TextStyle(color: Theme.of(context).buttonColor),
        ),
        padding: EdgeInsets.only(top: buttonPadding, bottom: buttonPadding),
      ),
    );
  }
}
