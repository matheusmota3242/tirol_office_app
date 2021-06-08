import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tirol_office_app/auth/auth_service.dart';
import 'package:tirol_office_app/service/department_service.dart';
import 'package:tirol_office_app/service/process_service.dart';
import 'package:tirol_office_app/service/user_service.dart';
import 'package:tirol_office_app/views/screens/auth/login_view.dart';
import 'package:tirol_office_app/views/screens/departments/department_list_view.dart';
import 'package:tirol_office_app/views/screens/observations/observation_list_view.dart';
import 'package:tirol_office_app/views/screens/personal_info/personal_info_view.dart';
import 'package:tirol_office_app/views/screens/processes/process_list_view.dart';
import 'package:tirol_office_app/views/screens/processes/process_details_view.dart';
import 'package:tirol_office_app/views/screens/service_provider/service_provider_form_view.dart';
import 'package:tirol_office_app/views/screens/service_provider/service_provider_list_view.dart';
import 'package:tirol_office_app/views/screens/users/user_list_view.dart';

import 'screens/personal_info/personal_info_form_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp();
  var prefs = await SharedPreferences.getInstance();

  runApp(
    MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: [const Locale('pt', 'BR')],
      home: MyApp(uid: prefs.getString('uid')),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String uid;

  const MyApp({Key key, this.uid}) : super(key: key);
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
        ),
        Provider(
          create: (_) => UserService(),
        ),
        Provider(
          create: (_) => ProcessService(),
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
          backgroundColor: Color(0xFF166D97),
          textTheme: TextTheme(
            headline5: TextStyle(
                fontSize: 18.0,
                color: Colors.grey[800],
                fontWeight: FontWeight.w500),
            headline6: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[800],
                fontWeight: FontWeight.w500),
            subtitle1: TextStyle(
                fontSize: 15.0,
                color: Colors.grey[800],
                fontWeight: FontWeight.w500),
            subtitle2: TextStyle(
                fontSize: 14.0,
                color: Colors.grey[800],
                fontWeight: FontWeight.w500),
            bodyText1: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.grey[800]),
          ),
          appBarTheme: AppBarTheme(
            color: Color(0xFF166D97),
          ),

          // This makes the visual density adapt to the platform that you run
          // the app on. For desktop platforms, the controls will be smaller and
          // closer together (more dense) than on mobile platforms.
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routes: {
          'login': (_) => LoginView(),
          'processes': (_) => ProcessListView(),
          'processDetails': (_) => ProcessDetailsView(),
          'observations': (_) => ObservationListView(),
          'departments': (_) => DepartmentListView(),
          'users': (_) => UserListView(),
          'serviceProviders': (_) => ServiceProviderListView(),
          'serviceProvidersForm': (_) => ServiceProviderFormView(),
          'personalInfo': (_) => PersonalInfoView(),
          'personalInfoForm': (_) => PersonalInfoFormView()
        },
        home: uid == null ? LoginView() : ProcessListView(),
      ),
    );
  }
}
