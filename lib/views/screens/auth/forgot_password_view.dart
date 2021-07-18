import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tirol_office_app/auth/auth_service.dart';
import 'package:tirol_office_app/utils/page_utils.dart';

class ForgotPasswordView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  static const double _horizontalPadding = 50.0;
  @override
  Widget build(BuildContext context) {
    String _email;
    var WIDGETS_WIDTH = MediaQuery.of(context).size.width * 0.75;
    var SIZE_SCREEN = MediaQuery.of(context).size;
    Widget sizedBox = SizedBox(
      height: 40,
    );
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        padding: PageUtils.BODY_PADDING,
        child: Form(
            key: _formKey,
            child: Column(children: [
              SizedBox(
                height: SIZE_SCREEN.height * 0.1,
              ),
              _forgotPasswordImage(),
              SizedBox(
                height: 30,
              ),
              Text(
                'Esqueceu a senha',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.black54),
              ),
              sizedBox,
              Container(
                width: WIDGETS_WIDTH,
                child: TextFormField(
                  onChanged: (value) => _email = value,
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    prefixIcon: Icon(Icons.email),
                    labelText: 'E-mail cadastrado',
                    labelStyle: TextStyle(
                        color: Colors.grey[700],
                        height: 0.9,
                        fontWeight: FontWeight.w600),
                    filled: true,
                    counterStyle: TextStyle(color: Colors.red),
                    hintText: 'E-mail cadastrado',
                    contentPadding: EdgeInsets.only(
                      left: 10.0,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              sizedBox,
              SizedBox(
                height: 44,
                width: WIDGETS_WIDTH,
                child: ElevatedButton(
                    onPressed: () =>
                        AuthService().validateUserEmail(_email, context),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Theme.of(context).buttonColor),
                    ),
                    child: Text('Enviar')),
              ),
              SizedBox(
                height: 20,
              ),
              _popButton(context, WIDGETS_WIDTH)
            ])),
      ),
    );
  }

  Widget _forgotPasswordImage() {
    return SizedBox(
      child: SvgPicture.asset(
        'assets/images/forgot_password.svg',
        height: 150,
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

  Widget _popButton(BuildContext context, double sizeWidth) {
    return SizedBox(
      width: sizeWidth,
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
    );
  }
}
