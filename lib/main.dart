import 'package:flutter/material.dart';
import 'package:Doit/pages/HomePage.dart';
import 'package:Doit/pages/LoginPage.dart';
import 'package:Doit/pages/RegisterPage.dart';
import 'package:data_plugin/bmob/bmob.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  final routes = <String,WidgetBuilder>{
//    LoginPage.tag:(context)=>LoginPage(),
    HomePage.tag:(context)=>HomePage(),
    RegisterPage.tag:(context)=>RegisterPage(),
  };
  @override
  Widget build(BuildContext context) {
    Bmob.initMasterKey("1c54d5b204e98654778c77547afc7a66", "6cb8cd3e55e7c64c70452c1a89b072b7", "");
    return MaterialApp(
      title: 'Do it',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(title: 'Do it'),
      routes: routes,
    );
  }
}





