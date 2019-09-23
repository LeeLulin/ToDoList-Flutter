import 'package:Doit/utils/ValueNotifierData.dart';
import 'package:Doit/widget/CircleProgressBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ClockPage extends StatefulWidget {
  final int wLength;
  final String title;
  ClockPage({@required this.wLength,this.title});

  @override
  _ClockPageState createState() => new _ClockPageState();

}

class _ClockPageState extends State<ClockPage>{
  double workLength = 25.0;
  double shortBreak = 5.0;
  double longBreak = 20.0;
  double frequency = 4.0;
  String _title;

  @override
  void initState() {

    workLength = (widget.wLength).toDouble();
    _title = widget.title;
    super.initState();
  }
  Widget build(BuildContext context){
    ValueNotifierData vd = ValueNotifierData('start');
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.9,
          child: Image(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            image: AssetImage("images/img_3.png"),
            fit: BoxFit.cover,
          ),
        ),

        Container(
//          decoration: BoxDecoration(
//            image: DecorationImage(
//              image: AssetImage("images/img_3.png"),
////          image: AssetImage("images/clockbg_0.png"),
//              fit: BoxFit.cover,
//            ),
//          ),
          child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: new AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(CupertinoIcons.clear_thick, color: Colors.white),
                  onPressed: (){
                    showCupertinoDialog(
                        context: context,
                        builder: (context) {
                          return CupertinoAlertDialog(
                            title: Text("提示"),
                            content: Text("关闭后番茄钟将作废，是否关闭？"),
                            actions: <Widget>[
                              CupertinoDialogAction(
                                child: Text("确定"),
                                isDefaultAction: true,
                                onPressed: () {
                                  vd.value = 'stop';
                                  Navigator.pop(context);
                                  Navigator.of(super.context).pop(true);
                                },
                              ),
                              CupertinoDialogAction(
                                child: Text("取消"),
                                isDestructiveAction: true,

                                onPressed: () => Navigator.of(super.context).pop(false),
                              ),

                            ],
                          );
                        });
                  },
                ),
                title: Text(
                  "测试",
                  style: TextStyle(color: Colors.white),
                ),
                actions: <Widget>[
                  IconButton(
                    onPressed: (){

                    },
                    icon: Icon(CupertinoIcons.music_note, color: Colors.white),
                    iconSize: 30.0,
                  )
                ],
              ),
              body: Container(
                padding: const EdgeInsets.all(10.0),
                child: Column(
//          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(Icons.access_alarm, color: Colors.white),
                            Text(
                              " 番茄总时间 0分钟",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                              ),
                            ),
                          ],
                        ),

                      ],
                    ),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.only(top: 80.0 ),
                        child: CircleProgressBar(
                          vd,
                          280.0,
                          backgroundColor: Colors.white54,
                          foreColor: Colors.white,
                          startNumber: 0,
                          maxNumber: 100,
                          duration: workLength.toInt() * 60 * 1000,
                          textPercent: true,
                          title: _title,
                        ),
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.only(left: 40.0, right: 40.0, top: 80.0 ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Opacity(
                            opacity: 1.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(" 25分钟", style: TextStyle(color: Colors.white)),
                                Divider(height: 5.0, color: Colors.transparent,),
                                Icon(FontAwesomeIcons.laptop, color: Colors.white),
                                Divider(height: 5.0, color: Colors.transparent,),
                                Text("  工作", style: TextStyle(color: Colors.white)),
                              ],
                            ),
                          ),
                          Opacity(
                            opacity: 0.6,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(" 5分钟", style: TextStyle(color: Colors.white)),
                                Divider(height: 5.0, color: Colors.transparent,),
                                Icon(FontAwesomeIcons.coffee, color: Colors.white),
                                Divider(height: 5.0, color: Colors.transparent,),
                                Text("  短时休息", style: TextStyle(color: Colors.white)),
                              ],
                            ),
                          ),
                          Opacity(
                            opacity: 0.6,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(" 20分钟", style: TextStyle(color: Colors.white)),
                                Divider(height: 5.0, color: Colors.transparent,),
                                Icon(FontAwesomeIcons.couch, color: Colors.white),
                                Divider(height: 5.0, color: Colors.transparent,),
                                Text("  长时休息", style: TextStyle(color: Colors.white)),
                              ],
                            ),
                          ),

                        ],
                      ),
                    )
                  ],
                ),
              )
          ),
        )
      ],
    );
  }
}