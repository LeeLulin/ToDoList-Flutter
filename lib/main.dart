import 'package:Doit/pages/SplashPage.dart';
import 'package:auto_size/auto_size.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:Doit/pages/HomePage.dart';
import 'package:Doit/pages/LoginPage.dart';
import 'package:Doit/pages/RegisterPage.dart';
import 'package:data_plugin/bmob/bmob.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'dart:ui' as ui show window;
import 'dart:ui' as ui show window, PointerDataPacket;

import 'db/DatabaseHelper.dart';

//void main() => runApp(MyApp());
void main() => runAutoSizeApp(MyApp(), width: 414, height: 896);

class MyApp extends StatelessWidget {

  final routes = <String,WidgetBuilder>{
//    LoginPage.tag:(context)=>LoginPage(),
    HomePage.tag:(context)=>HomePage(),
    RegisterPage.tag:(context)=>RegisterPage(),
  };

  Widget iosAppTheme(BuildContext context){
    return new CupertinoApp(
      localizationsDelegates: [                             //此处
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        const FallbackCupertinoLocalisationsDelegate(),
      ],
      supportedLocales: [                                   //此处
        const Locale('zh','CH'),
//        const Locale('en','US'),
      ],
      title: 'Do it',
      theme: new CupertinoThemeData(
        brightness: Brightness.light,
      ),

      home: SplashPage(),
//      home: HomePage(title: 'Do it'),

      routes: routes,

    );
  }

  Widget androidAppTheme(BuildContext context){
    return new MaterialApp(
      localizationsDelegates: [                             //此处
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        const FallbackCupertinoLocalisationsDelegate(),
      ],
      supportedLocales: [                                   //此处
        const Locale('zh','CH'),
//        const Locale('en','US'),
      ],
      title: 'Do it',
      theme: new ThemeData(

      ),

      home: SplashPage(),
//      home: HomePage(title: 'Do it'),

      routes: routes,

    );
  }



  @override
  Widget build(BuildContext context) {
    Bmob.initMasterKey("1c54d5b204e98654778c77547afc7a66", "6cb8cd3e55e7c64c70452c1a89b072b7", "");

    return defaultTargetPlatform == TargetPlatform.iOS
        ? iosAppTheme(context)
        : androidAppTheme(context);


  }
}

class FallbackCupertinoLocalisationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalisationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      DefaultCupertinoLocalizations.load(locale);

  @override
  bool shouldReload(FallbackCupertinoLocalisationsDelegate old) => false;
}
