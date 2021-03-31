import 'package:flutter/material.dart';
import 'package:tirol_office_app/helpers/auth_helper.dart';
import 'dart:math' as math;

import 'package:tirol_office_app/helpers/page_helper.dart';
import 'package:tirol_office_app/models/service_provider_model.dart';
import 'package:tirol_office_app/service/service_provider_service.dart';
import 'package:tirol_office_app/views/widgets/toast.dart';

class ServiceProviderFormView extends StatefulWidget {
  _ServiceProviderFormViewState createState() =>
      _ServiceProviderFormViewState();
}

class _ServiceProviderFormViewState extends State<ServiceProviderFormView>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ServiceProviderService _service = ServiceProviderService();
    ServiceProvider currentServiceProvider = ServiceProvider();
    AuthHelper _authHelper = AuthHelper();
    var themeData = Theme.of(context);

    void save() {
      _service.save(currentServiceProvider);
      Navigator.pop(context);
      Toasts.showToast(content: 'Serviço adicionado com sucesso');
    }

    String validateEmail(String email) {
      _authHelper.validateEmail(email);
    }

    void cancel() {
      Navigator.pop(context);
    }

    Widget serviceProviderNameField() {
      return Container(
        child: TextFormField(
          onChanged: (value) => currentServiceProvider.name = value,
          decoration: InputDecoration(
            alignLabelWithHint: true,
            labelText: 'Nome',
            labelStyle: TextStyle(
                color: Colors.grey[700],
                height: 0.9,
                fontWeight: FontWeight.w600),
            filled: true,
            counterStyle: TextStyle(color: Colors.red),
            hintText: 'Nome',
            contentPadding: EdgeInsets.only(
              left: 10.0,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
          ),
        ),
      );
    }

    Widget serviceProviderEmailField() {
      return Container(
        child: TextFormField(
          onChanged: (value) => currentServiceProvider.email = value,
          validator: (value) => validateEmail(value),
          decoration: InputDecoration(
            alignLabelWithHint: true,
            labelText: 'Email',
            labelStyle: TextStyle(
                color: Colors.grey[700],
                height: 0.9,
                fontWeight: FontWeight.w600),
            filled: true,
            counterStyle: TextStyle(color: Colors.red),
            hintText: 'exemplo@exemplo.com',
            contentPadding: EdgeInsets.only(
              left: 10.0,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
          ),
        ),
      );
    }

    Widget serviceProviderPhoneField() {
      return Container(
        child: TextFormField(
          onChanged: (value) => currentServiceProvider.phone = value,
          decoration: InputDecoration(
            alignLabelWithHint: true,
            labelText: 'Telefone',
            labelStyle: TextStyle(
                color: Colors.grey[700],
                height: 0.9,
                fontWeight: FontWeight.w600),
            filled: true,
            counterStyle: TextStyle(color: Colors.red),
            hintText: '(99) 99999-9999',
            contentPadding: EdgeInsets.only(
              left: 10.0,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
          ),
        ),
      );
    }

    Widget serviceProviderCategoryField() {
      return Container(
        child: TextFormField(
          onChanged: (value) => currentServiceProvider.category = value,
          decoration: InputDecoration(
            alignLabelWithHint: true,
            labelText: 'Categoria',
            labelStyle: TextStyle(
                color: Colors.grey[700],
                height: 0.9,
                fontWeight: FontWeight.w600),
            filled: true,
            counterStyle: TextStyle(color: Colors.red),
            hintText: 'Categoria',
            contentPadding: EdgeInsets.only(
              left: 10.0,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(PageHelper.servicesForm),
      ),
      body: Container(
        padding: EdgeInsets.all(PageHelper.bodyPadding),
        child: Column(
          children: [
            serviceProviderNameField(),
            SizedBox(
              height: 12.0,
            ),
            serviceProviderEmailField(),
            SizedBox(
              height: 12.0,
            ),
            serviceProviderPhoneField(),
            SizedBox(
              height: 12.0,
            ),
            serviceProviderCategoryField(),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(PageHelper.fabIcons.length, (int index) {
          Widget child = Container(
            height: 70.0,
            width: 56.0,
            alignment: FractionalOffset.topCenter,
            child: ScaleTransition(
              scale: CurvedAnimation(
                parent: _animationController,
                curve: Interval(
                    0.0, 1.0 - index / PageHelper.fabIcons.length / 2.0,
                    curve: Curves.easeOut),
              ),
              child: FloatingActionButton(
                heroTag: null,
                backgroundColor: PageHelper.fabIconsColors[index],
                mini: true,
                child: Icon(PageHelper.fabIcons[index], color: Colors.white),
                onPressed: () => index == 0 ? save() : cancel(),
              ),
            ),
          );
          return child;
        }).toList()
          ..add(
            FloatingActionButton(
              backgroundColor: themeData.buttonColor,
              heroTag: null,
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) => Transform(
                  transform: new Matrix4.rotationZ(
                      _animationController.value * 0.5 * math.pi),
                  alignment: FractionalOffset.center,
                  child: Icon(_animationController.isDismissed
                      ? Icons.share
                      : Icons.close),
                ),
              ),
              onPressed: () {
                if (_animationController.isDismissed) {
                  _animationController.forward();
                } else {
                  _animationController.reverse();
                }
              },
            ),
          ),
      ),
    );
  }
}
