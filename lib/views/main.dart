import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tirol_office_app/auth/auth_service.dart';
import 'package:tirol_office_app/service/department_service.dart';

import 'package:tirol_office_app/views/screens/auth/login_view.dart';
import 'package:tirol_office_app/views/screens/departments/department_list_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (_) => AuthService(),
        ),
        Provider(
          create: (_) => DepartmentService(),
        )
      ],
      child: MaterialApp(
        title: 'Tirol Office App',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
          primaryColor: Color(0xFFBF1E2E),
          buttonColor: Color(0xFF166D97),
          textTheme: TextTheme(
            headline6: TextStyle(
                fontSize: 18.0,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500),
            subtitle1: TextStyle(
                fontSize: 17.0,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500),
            subtitle2: TextStyle(
                fontSize: 15.0,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500),
            bodyText1: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.grey[700]),
          ),
          appBarTheme: AppBarTheme(
            color: Color(0xFF7999B7),
          ),

          // This makes the visual density adapt to the platform that you run
          // the app on. For desktop platforms, the controls will be smaller and
          // closer together (more dense) than on mobile platforms.
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routes: {
          'departments': (_) => DepartmentListView(),
        },
        home: LoginView(),
      ),
    );
  }
}
