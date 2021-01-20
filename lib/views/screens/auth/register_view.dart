import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:tirol_office_app/auth/auth_service.dart';

class RegisterView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  static const double _horizontalPadding = 50.0;
  String _email, _password;
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
              _emailField(screenHeight),
              // _cpfField(screenHeight),
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
        validator: (value) =>
            value.isEmpty ? 'Por favor, digite seu e-mail' : null,
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

  // Widget _cpfField(double screenHeight) {
  //   var borderWidth = 1.0;
  //   var verticalPadding = (screenHeight / 40);
  //   var fieldVerticalPadding = 8.0;
  //   var fieldLeftPadding = 8.0;
  //   var fieldRightPadding = 0.0;
  //   return Padding(
  //     padding: EdgeInsets.fromLTRB(
  //       _horizontalPadding,
  //       verticalPadding,
  //       _horizontalPadding,
  //       (verticalPadding / 2),
  //     ),
  //     child: TextFormField(
  //       decoration: InputDecoration(
  //         filled: true,
  //         contentPadding: EdgeInsets.fromLTRB(fieldLeftPadding,
  //             fieldVerticalPadding, fieldRightPadding, fieldVerticalPadding),
  //         hintText: 'CPF',
  //         border: OutlineInputBorder(
  //           borderSide: BorderSide.none,
  //         ),
  //       ),
  //     ),
  //   );
  // }

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
            validator: (value) =>
                value.isEmpty ? 'Por favor, digite sua senha' : null,
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
            validator: (value) =>
                value.isEmpty ? 'Por favor, confirme sua senha' : null,
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
            authService.signUp(email: _email, password: _password);
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
}
