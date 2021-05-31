import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:tirol_office_app/utils/page_utils.dart';
import 'package:tirol_office_app/utils/validation_utils.dart';
import 'package:tirol_office_app/models/service_provider_model.dart';
import 'package:tirol_office_app/service/service_provider_service.dart';
import 'package:tirol_office_app/views/widgets/toast.dart';

class ServiceProviderFormView extends StatefulWidget {
  final ServiceProvider serviceProvider;

  const ServiceProviderFormView({Key key, this.serviceProvider})
      : super(key: key);
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
    ValidationHelper _validationHelper = ValidationHelper();
    var themeData = Theme.of(context);
    GlobalKey<FormState> _formKey = GlobalKey();
    void persist() {
      if (_formKey.currentState.validate()) {
        _service.persist(this.widget.serviceProvider);
        Navigator.pop(context);
        Toasts.showToast(content: 'Serviço adicionado com sucesso');
      }
    }

    void cancel() {
      Navigator.pop(context);
    }

    Widget serviceProviderNameField() {
      TextEditingController controller =
          TextEditingController(text: this.widget.serviceProvider.name);
      return Container(
        child: TextFormField(
          controller: controller,
          onChanged: (value) => this.widget.serviceProvider.name = value,
          validator: (value) => _validationHelper.validateName(value),
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
      TextEditingController controller =
          TextEditingController(text: this.widget.serviceProvider.email);
      return Container(
        child: TextFormField(
          onChanged: (value) => this.widget.serviceProvider.email = value,
          validator: (value) => _validationHelper.validateEmail(value),
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
      TextEditingController controller =
          TextEditingController(text: this.widget.serviceProvider.phone);
      return Container(
        child: TextFormField(
          onChanged: (value) => this.widget.serviceProvider.phone = value,
          controller: controller,
          validator: (value) => _validationHelper.validatePhoneNumber(value),
          decoration: InputDecoration(
            alignLabelWithHint: true,
            labelText: 'Telefone',
            labelStyle: TextStyle(
                color: Colors.grey[700],
                height: 0.9,
                fontWeight: FontWeight.w600),
            filled: true,
            counterStyle: TextStyle(color: Colors.red),
            hintText: '999999999',
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
      TextEditingController controller =
          TextEditingController(text: this.widget.serviceProvider.category);
      return Container(
        child: TextFormField(
          onChanged: (value) => this.widget.serviceProvider.category = value,
          controller: controller,
          validator: (value) =>
              value.isEmpty ? 'Por favor, preencha o campo categoria' : null,
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
        title: Text(PageUtils.servicesForm),
      ),
      body: Container(
        padding: EdgeInsets.all(PageUtils.bodyPadding),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              serviceProviderNameField(),
              SizedBox(
                height: PageUtils.bodyPadding,
              ),
              serviceProviderEmailField(),
              SizedBox(
                height: PageUtils.bodyPadding,
              ),
              serviceProviderPhoneField(),
              SizedBox(
                height: PageUtils.bodyPadding,
              ),
              serviceProviderCategoryField(),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(PageUtils.fabIcons.length, (int index) {
          Widget child = Container(
            height: 70.0,
            width: 56.0,
            alignment: FractionalOffset.topCenter,
            child: ScaleTransition(
              scale: CurvedAnimation(
                parent: _animationController,
                curve: Interval(
                    0.0, 1.0 - index / PageUtils.fabIcons.length / 2.0,
                    curve: Curves.easeOut),
              ),
              child: FloatingActionButton(
                heroTag: null,
                backgroundColor: PageUtils.fabIconsColors[index],
                mini: true,
                child: Icon(PageUtils.fabIcons[index], color: Colors.white),
                onPressed: () => index == 0 ? persist() : cancel(),
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
