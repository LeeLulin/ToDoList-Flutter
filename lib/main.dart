import 'package:flutter/material.dart';
import 'package:Doit/pages/HomePage.dart';
import 'package:Doit/pages/LoginPage.dart';
import 'package:Doit/pages/RegisterPage.dart';
import 'package:data_plugin/bmob/bmob.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  final routes = <String,WidgetBuilder>{
    LoginPage.tag:(context)=>LoginPage(),
    HomePage.tag:(context)=>HomePage(),
    RegisterPage.tag:(context)=>RegisterPage(),
  };
  @override
  Widget build(BuildContext context) {
    Bmob.initMasterKey("4e7af8281fc5fb7cda32f9ee781386d2", "4db79a59bec335699c1f920821af90e4", "");
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





