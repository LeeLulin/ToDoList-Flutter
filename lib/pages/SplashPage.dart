import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'HomePage.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashPageState();
  }
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 350.0),
      alignment: Alignment.center,
      color: Colors.white,
      child: new Column(
        children: <Widget>[
          new ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.asset(
              "images/app_icon.png",
              width: 80.0,
              height: 80.0,
            ),
          ),


          new Divider(height:10.0,indent:0.0,color: Colors.transparent,),
          new Text(
            "Do it",
            style: new TextStyle(
              color: Colors.black54,
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
                decoration: TextDecoration.none
            ),
          ),
          new Divider(height:10.0,indent:0.0,color: Colors.transparent,),
          new Text(
            "生命不息，奋斗不止",
            style: new TextStyle(
                color: Colors.black54,
                fontSize: 18.0,
                fontWeight: FontWeight.w300,
                decoration: TextDecoration.none
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    countDown();

  }

// 倒计时
  void countDown() {
    var _duration = new Duration(seconds: 1);
    new Future.delayed(_duration, go2HomePage);
  }

  void go2HomePage() {
    Navigator.pushReplacementNamed(context, HomePage.tag);
  }
}