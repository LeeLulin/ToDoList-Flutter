import 'package:Doit/widget/CircleProgressBar.dart';
import 'package:flutter/material.dart';

class ClockPage extends StatefulWidget {

  @override
  _ClockPageState createState() => new _ClockPageState();

}

class _ClockPageState extends State<ClockPage>{
  Widget build(BuildContext context){
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/clockbg_0.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: new AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Container(

          child: Center(
            child: CircleProgressBar(
              200.0,
              backgroundColor: Colors.grey,
              foreColor: Colors.blueAccent,
              startNumber: 0,
              maxNumber: 100,
              duration: 30000,
              textPercent: true,
            ),
          ),
        ),
      ),
    );
  }
}