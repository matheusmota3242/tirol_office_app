import 'package:flutter/material.dart';
import 'package:tirol_office_app/models/user_model.dart';
import 'package:tirol_office_app/views/screens/departments/department_form_view.dart';
import 'package:tirol_office_app/views/widgets/appbar.dart';

class DepartmentListView extends StatelessWidget {
  //final Object title;
  //final User currentUser;

  const DepartmentListView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map args = ModalRoute.of(context).settings.arguments as Map;
    String title = args['title'];
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            onPressed: () => pushToDepartmentFormView(context),
            icon: Icon(
              Icons.add,
            ),
          )
        ],
      ),
    );
  }

  void pushToDepartmentFormView(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DepartmentFormView(),
      ),
    );
  }
}
