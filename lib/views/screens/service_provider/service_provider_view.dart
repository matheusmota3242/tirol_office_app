import 'package:flutter/material.dart';

import 'package:tirol_office_app/models/service_provider_model.dart';
import 'package:tirol_office_app/utils/page_utils.dart';

class ServiceProviderView extends StatelessWidget {
  final ServiceProvider serviceProvider;

  ServiceProviderView({Key key, this.serviceProvider}) : super(key: key);
  var sizedBoxHeight = 24.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(PageUtils.SERVICE_PROVIDER_TITLE),
      ),
      body: Container(
        padding: PageUtils.BODY_PADDING,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            serviceProviderAttribute('Nome', this.serviceProvider.name),
            SizedBox(height: sizedBoxHeight),
            serviceProviderAttribute('Categoria', serviceProvider.category),
            SizedBox(height: sizedBoxHeight),
            serviceProviderAttribute('Email', serviceProvider.email),
            SizedBox(height: sizedBoxHeight),
            serviceProviderAttribute('Telefone', serviceProvider.phone),
          ],
        ),
      ),
    );
  }

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
