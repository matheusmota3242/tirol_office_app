import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tirol_office_app/auth/auth_service.dart';
import 'package:tirol_office_app/utils/page_utils.dart';
import 'package:tirol_office_app/utils/validation_utils.dart';

class ForgotPasswordView extends StatelessWidget {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String _email;
    var widgetsWidth = MediaQuery.of(context).size.width * 0.75;
    var sizeScreen = MediaQuery.of(context).size;
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
                height: sizeScreen.height * 0.1,
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
                width: widgetsWidth,
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
                width: widgetsWidth,
                child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate())
                        await AuthService().sendPasswordResetEmail(_email);
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
              _popButton(context, widgetsWidth)
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
