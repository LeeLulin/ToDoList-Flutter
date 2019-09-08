import 'package:Doit/bean/Todos.dart';
import 'package:Doit/bean/Tomato.dart';
import 'package:data_plugin/bmob/response/bmob_saved.dart';
import 'package:data_plugin/bmob/table/bmob_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliver_fab/sliver_fab.dart';

class NewTomatoPage extends StatefulWidget {


  @override
  _NewTomatoPageState createState() => new _NewTomatoPageState();

}
class _NewTomatoPageState extends State<NewTomatoPage>{

  String title;
  double workLength = 25.0;
  double shortBreak = 5.0;
  double longBreak = 20.0;
  double frequency = 4.0;
  Widget build(BuildContext context) {
    Tomato tomato = ModalRoute.of(context).settings.arguments;
//    ScreenUtil.instance = ScreenUtil(width: 828, height: 1792)..init(context);
    return Scaffold(
      body: new SliverFab(
        ///悬浮按钮
          floatingWidget: new FloatingActionButton(
            heroTag: 'tomato',
            tooltip: "按这么长时间干嘛",
            child: new Icon(CupertinoIcons.check_mark, size: 30,),
            onPressed: () {
              saveTomatoToBmob();

            },
          ),
          floatingPosition: FloatingPosition(right: 16),
          expandedHeight: 240.0,
          slivers: <Widget>[
            SliverAppBar(
              // 展开的高度
              expandedHeight: 240.0,
              // 强制显示阴影
//              forceElevated: true,
              // 设置该属性，当有下滑手势的时候，就会显示 AppBar
              floating: true,
              // 该属性只有在 floating 为 true 的情况下使用，不然会报错
              // 当上滑到一定的比例，会自动把 AppBar 收缩（不知道是不是 bug，当 AppBar 下面的部件没有被 AppBar 覆盖的时候，不会自动收缩）
              // 当下滑到一定比例，会自动把 AppBar 展开
              //snap: true,
              // 设置该属性使 Appbar 折叠后不消失
              pinned: true,
              // 通过这个属性设置 AppBar 的背景
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: false,
                titlePadding: EdgeInsets.only(left: 45.0, bottom: 10.0),
                title: Text(
                  '新建番茄时钟',
                  style: new TextStyle(
                    fontSize: 30.0,
                  ),
                ),
                // 背景折叠动画
                collapseMode: CollapseMode.parallax,
                background: Image.asset('images/img_0.png', fit: BoxFit.cover),
              ),
            ),


            SliverFillRemaining(

              child: new Padding(
                padding: EdgeInsets.only(left: 15.0, right: 15.0, ),

                child: SingleChildScrollView(

                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new TextField(
                        autofocus: false,
                        style: TextStyle(fontSize: 20.0),
                        decoration: new InputDecoration(
                          labelText: '标题',
                        ),
                        onChanged: (String value) => title = value,
                      ),

//                      new TextField(
//                        autofocus: false,
//                        style: TextStyle(fontSize: 20.0),
//                        decoration: new InputDecoration(
//                          labelText: '描述',
//                        ),
//                        onChanged: (String value) => desc = value,
//                      ),

                      Divider(height:20.0,indent:0.0,color: Colors.white70,),
                      Text('番茄时长'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: 330.0,
                            child: CupertinoSlider(
                              min: 0.0,
                              max: 100.0,
                              value: workLength,
                              onChanged: (double v) {
                                setState(() {
                                  workLength = v;
                                });
                              },
                            ),
                          ),
                          Text(
                            '${workLength.toInt()}分钟'
                          ),
                        ],
                      ),
                      Text('短休息时长'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: 330.0,
                            child: CupertinoSlider(
                              min: 0.0,
                              max: 100.0,
                              value: shortBreak,
                              onChanged: (double v) {
                                setState(() {
                                  shortBreak = v;
                                });
                              },
                            ),
                          ),
                          Text(
                              '${shortBreak.toInt()}分钟'
                          ),
                        ],
                      ),
                      Text('长休息时长'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: 330.0,
                            child: CupertinoSlider(
                              min: 0.0,
                              max: 100.0,
                              value: longBreak,
                              onChanged: (double v) {
                                setState(() {
                                  longBreak = v;
                                });
                              },
                            ),
                          ),
                          Text(
                              '${longBreak.toInt()}分钟'
                          ),
                        ],
                      ),
                      Text('番茄次数'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: 330.0,
                            child: CupertinoSlider(
                              min: 0.0,
                              max: 10.0,
                              value: frequency,
                              onChanged: (double v) {
                                setState(() {
                                  frequency = v;
                                });
                              },
                            ),
                          ),
                          Text(
                              '${frequency.toInt()}次'
                          ),
                        ],
                      ),
//
//                      new InkWell(
//                        child: new Row(
//                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                          children: <Widget>[
//                            new Row(
//                              children: <Widget>[
//                                new Icon(Icons.date_range, size: 25.0, color: Colors.black54),
//                                VerticalDivider(width:10.0,indent:0.0,color: Colors.transparent,),
//                                new Text("日期",
//                                  style: TextStyle(fontSize: 20.0),
//                                ),
//                              ],
//                            ),
//                            new Text(date,
//                              style: TextStyle(fontSize: 20.0),
//                            )
//                          ],
//                        ),
//                        onTap: () => _showDateTimePicker(),
//                      ),
//
//                      Divider(height:20.0,indent:0.0,color: Colors.black54),
//
//                      new InkWell(
//                        child: new Row(
//                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                          children: <Widget>[
//                            new Row(
//                              children: <Widget>[
//                                new Icon(Icons.access_time, size: 25.0, color: Colors.black54),
//                                VerticalDivider(width:10.0,indent:0.0,color: Colors.transparent,),
//                                new Text("时间",
//                                  style: TextStyle(fontSize: 20.0),
//                                ),
//                              ],
//                            ),
//                            new Text(time,
//                              style: TextStyle(fontSize: 20.0),
//                            )
//                          ],
//                        ),
//
//                        onTap: () => _showDateTimePicker(),
//                      ),
//
//                      Divider(height:20.0,indent:0.0,color: Colors.black54),
//
//                      new Row(
//                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                        children: <Widget>[
//                          new Row(
//                            children: <Widget>[
//                              new Icon(Icons.restore, size: 25.0, color: Colors.black54),
//                              VerticalDivider(width:10.0,indent:0.0,color: Colors.transparent,),
//                              new Text("重复提醒",
//                                style: TextStyle(fontSize: 20.0),
//                              ),
//                            ],
//                          ),
//
//                          new CupertinoSwitch(
//                              activeColor: Colors.blue,
//                              value: isRepeat,
//                              onChanged: (bool value){
//                                setState(() {
//                                  isRepeat = value;
//                                });
//                              }),
//                        ],
//                      ),

                    ],
                  ),
                ),
              ),
            ),
          ]
      ),

    );
  }

  ///显示日期选择器
//  _showDateTimePicker() async {
//    DatePicker.showDatePicker(context,
//        locale: DateTimePickerLocale.zh_cn,
//        pickerMode: DateTimePickerMode.datetime,
//        minDateTime: DateTime.now(),
//        maxDateTime: DateTime(2099),
//        initialDateTime: DateTime.now(),
//        dateFormat: 'yyyy年  MM月  d日  EEE H时:m分',
//        pickerTheme: new DateTimePickerTheme(
//          pickerHeight: 220.0,
//
//          confirm: Text('完成',
//            style: TextStyle(color: Colors.blue, fontSize: 18.0),
//          ),
//          cancel: Text('取消',
//            style: TextStyle(color: Colors.black, fontSize: 18.0),
//          ),
//          itemTextStyle: TextStyle(fontSize: 18.0),
//        ),
//        onConfirm: (dateTime, selectedIndex){
//          setState(() {
//            date = "${dateTime.year}年${dateTime.month}月${dateTime.day}日";
//            time = "${dateTime.hour}:${dateTime.minute}";
//            remindTime = DateTime.fromMillisecondsSinceEpoch(dateTime.millisecondsSinceEpoch).millisecondsSinceEpoch;
//            print("remindTime: $remindTime");
//          });
//        }
//    );
//
//  }


  ///保存待办事项到Bmob云
  saveTomatoToBmob() async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    String objectId = sp.get("ObjectId");
    BmobUser bmobUser = BmobUser();
    bmobUser.objectId = objectId;
    Tomato tomato = Tomato();
    tomato.user = bmobUser;
    tomato.title = title;
    tomato.workLength = workLength.toInt();
    tomato.shortBreak = shortBreak.toInt();
    tomato.longBreak = longBreak.toInt();
    tomato.frequency = frequency.toInt();
    await tomato.save().then((BmobSaved data){

    }).catchError((e){

    });
    Navigator.of(context).pop("upload");
  }


}