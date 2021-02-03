import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ForgotPasswordView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  static const double _horizontalPadding = 50.0;
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _forgotPasswordImage(screenHeight),
              _titlePage(screenHeight),
              _usernameField(screenHeight),
              _cpfField(screenHeight),
              _passwordField(screenHeight),
              _confirmPasswordField(screenHeight),
              _submitButton(context, screenHeight)
            ],
          ),
        ),
      ),
    );
  }

  Widget _forgotPasswordImage(double screenHeight) {
    var heightImage = 150.0;
    var paddingTop = (screenHeight / 12);
    var paddingBottom = (screenHeight / 30);
    return SizedBox(
      child: Padding(
        padding: EdgeInsets.only(top: paddingTop, bottom: paddingBottom),
        child: SvgPicture.asset(
          'assets/images/forgot_password.svg',
          height: heightImage,
        ),
      ),
    );
  }

  Widget _titlePage(double screenHeight) {
    var fontSize = 32.0;
    var paddingBottom = (screenHeight / 40);
    return Padding(
      padding: EdgeInsets.only(bottom: paddingBottom),
      child: Center(
        child: Text(
          'Esqueceu a senha?',
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
      padding: EdgeInsets.fromLTRB(
        _horizontalPadding,
        verticalPadding,
        _horizontalPadding,
        (verticalPadding / 2),
      ),
      child: TextFormField(
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

  Widget _cpfField(double screenHeight) {
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
        decoration: InputDecoration(
          filled: true,
          contentPadding: EdgeInsets.fromLTRB(fieldLeftPadding,
              fieldVerticalPadding, fieldRightPadding, fieldVerticalPadding),
          hintText: 'CPF',
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
            decoration: InputDecoration(
              filled: true,
              counterStyle: TextStyle(color: Colors.red),
              hintText: 'Nova senha',
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
            decoration: InputDecoration(
              filled: true,
              counterStyle: TextStyle(color: Colors.red),
              hintText: 'Confirmar nova senha',
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

  Widget _submitButton(BuildContext context, double screenHeight) {
    var buttonPadding = 16.0;
    var verticalPadding = (screenHeight / 40);
    return Padding(
      padding: EdgeInsets.fromLTRB(_horizontalPadding, verticalPadding,
          _horizontalPadding, verticalPadding),
      child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        onPressed: () {},
        child: Text(
          'Salvar',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        color: Theme.of(context).buttonColor,
        padding: EdgeInsets.only(top: buttonPadding, bottom: buttonPadding),
      ),
    );
  }
}
