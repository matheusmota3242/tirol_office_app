import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tirol_office_app/auth/auth_service.dart';
import 'package:tirol_office_app/utils/page_utils.dart';
import 'package:tirol_office_app/utils/validation_utils.dart';

class ForgotPasswordView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  static const double _horizontalPadding = 50.0;
  @override
  Widget build(BuildContext context) {
    String _email;
    var WIDGETS_WIDTH = MediaQuery.of(context).size.width * 0.75;
    var SIZE_SCREEN = MediaQuery.of(context).size;
    const double HORIZONTAL_PADDING = 40;
    Widget sizedBox = SizedBox(
      height: 70,
    );
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(
            left: HORIZONTAL_PADDING, right: HORIZONTAL_PADDING),
        width: double.maxFinite,
        child: Form(
            key: _formKey,
            child: ListView(children: [
              SizedBox(
                height: SIZE_SCREEN.height * 0.1,
              ),
              _forgotPasswordImage(),
              SizedBox(
                height: 30,
              ),
              Center(
                child: Text(
                  'Esqueceu a senha',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.black54),
                ),
              ),
              sizedBox,
              Container(
                width: WIDGETS_WIDTH,
                child: TextFormField(
                  onChanged: (value) => _email = value,
                  validator: (value) => ValidationUtils().validateEmail(value),
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
                    onPressed: () {
                      if (_formKey.currentState.validate())
                        AuthService().sendPasswordResetEmail(_email);
                    },
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

  Widget _submitButton(
      String email, BuildContext context, double screenHeight) {
    var buttonPadding = 16.0;
    var verticalPadding = (screenHeight / 40);
    return Padding(
      padding: EdgeInsets.fromLTRB(_horizontalPadding, verticalPadding,
          _horizontalPadding, verticalPadding),
      child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        onPressed: () => AuthService().sendPasswordResetEmail(email),
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
