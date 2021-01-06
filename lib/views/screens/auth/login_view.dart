import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LoginView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  static const double _horizontalPadding = 50.0;
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        child: Form(
          child: ListView(
            children: [
              _loginImage(screenHeight),
              _titlePage(screenHeight),
              _usernameField(screenHeight),
              _passwordField(screenHeight),
              _forgotPasswordButton(screenHeight),
              _loginButton(context, screenHeight),
              _orText(),
              _signUpButton(context, screenHeight)
            ],
          ),
          key: _formKey,
        ),
      ),
    );
  }

  Widget _loginImage(double screenHeight) {
    var heightImage = 150.0;
    var paddingTop = (screenHeight / 12);
    var paddingBottom = (screenHeight / 30);
    return SizedBox(
      child: Padding(
        padding: EdgeInsets.only(top: paddingTop, bottom: paddingBottom),
        child: SvgPicture.asset(
          'assets/images/undraw_Login_re_4vu2.svg',
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
          'Login',
          style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              color: Colors.black54),
        ),
      ),
    );
  }

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

  Widget _forgotPasswordButton(double screenHeight) {
    return Container(
      height: 32.0,
      padding: EdgeInsets.only(right: _horizontalPadding),
      alignment: Alignment.topRight,
      child: TextButton(
        onPressed: () {},
        child: Text(
          'Esqueceu a senha?',
          style: TextStyle(fontSize: 12),
        ),
      ),
    );
  }

  Widget _loginButton(BuildContext context, double screenHeight) {
    var buttonPadding = 16.0;
    var verticalPadding = (screenHeight / 40);
    return Padding(
      padding: EdgeInsets.fromLTRB(_horizontalPadding, verticalPadding,
          _horizontalPadding, verticalPadding),
      child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        onPressed: () {},
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

  Widget _signUpButton(BuildContext context, double screenHeight) {
    var verticalPadding = (screenHeight / 40);
    var buttonPadding = 16.0;
    return Padding(
      padding: EdgeInsets.fromLTRB(_horizontalPadding, verticalPadding,
          _horizontalPadding, verticalPadding),
      child: RaisedButton(
        onPressed: () {},
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
