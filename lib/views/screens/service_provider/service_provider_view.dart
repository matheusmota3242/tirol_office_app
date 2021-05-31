import 'package:flutter/material.dart';

import 'package:tirol_office_app/models/service_provider_model.dart';
import 'package:tirol_office_app/utils/page_utils.dart';

class ServiceProviderView extends StatelessWidget {
  final ServiceProvider serviceProvider;

  ServiceProviderView({Key key, this.serviceProvider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(PageUtils.serviceProvider),
      ),
      body: Container(
        padding: EdgeInsets.all(PageUtils.bodyPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            serviceProviderAttribute('Nome', this.serviceProvider.name),
            separator,
            serviceProviderAttribute('Categoria', serviceProvider.category),
            separator,
            serviceProviderAttribute('Email', serviceProvider.email),
            separator,
            serviceProviderAttribute('Telefone', serviceProvider.phone),
          ],
        ),
      ),
    );
  }

  Widget separator = Column(
    children: [
      SizedBox(
        height: 12.0,
      ),
      Container(
        width: double.maxFinite,
        height: 0.5,
        color: Colors.grey[400],
      ),
      SizedBox(
        height: 12.0,
      ),
    ],
  );

  Widget serviceProviderAttribute(String label, String value) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 8.0,
          ),
          Text(
            value,
            style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[800],
                fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
}
