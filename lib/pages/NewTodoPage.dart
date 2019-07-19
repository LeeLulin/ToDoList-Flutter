import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewTodoPage extends StatefulWidget {


  @override
  _NewTodoPageState createState() => new _NewTodoPageState();

}
class _NewTodoPageState extends State<NewTodoPage>{

  bool isRepeat=false;
  String date = "2019年1月1日",time = "12:00";
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: NeverScrollableScrollPhysics(),
          slivers: <Widget>[
        SliverAppBar(
//            title: Text(''),
          centerTitle: true,
          // 展开的高度
          expandedHeight: 220.0,
          // 强制显示阴影
          forceElevated: true,
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
            titlePadding: EdgeInsets.only(left: 20.0, bottom: 10.0),

            title: Text('新建待办',
              style: new TextStyle(
                fontSize: 30.0,
              ),),
            // 背景折叠动画
            collapseMode: CollapseMode.parallax,
            background: Image.asset('images/img_1.png', fit: BoxFit.cover),

          ),


        ),


        SliverFillRemaining(
          child: new Padding(
            padding: EdgeInsets.only(left: 15.0, right: 15.0, ),
            child: SingleChildScrollView(
              child: new Column(
                children: <Widget>[
                  new TextField(
                    autofocus: false,
                    style: TextStyle(fontSize: 20.0),
                    decoration: new InputDecoration(
                      labelText: '标题',
                    ),
                    onChanged: null,
                  ),

                  new TextField(
                    autofocus: false,
                    style: TextStyle(fontSize: 20.0),
                    decoration: new InputDecoration(
                      labelText: '描述',
                    ),
                    onChanged: null,
                  ),

                  Divider(height:20.0,indent:0.0,color: Colors.white70,),

                  new GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Row(
                          children: <Widget>[
                            new Icon(Icons.date_range, size: 30.0,),
                            VerticalDivider(width:10.0,indent:0.0,color: Colors.transparent,),
                            new Text("日期",
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ],
                        ),

                        new Text(date,
                          style: TextStyle(fontSize: 20.0),
                        )

                      ],
                    ),
                    onTap: () => _showDatePicker(),


                  ),


                  Divider(height:20.0,indent:0.0,color: Colors.black54),

                  new GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Row(
                          children: <Widget>[
                            new Icon(Icons.access_time, size: 30.0,),
                            VerticalDivider(width:10.0,indent:0.0,color: Colors.transparent,),
                            new Text("时间",
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ],
                        ),

                        new Text(time,
                          style: TextStyle(fontSize: 20.0),
                        )

                      ],

                    ),

                    onTap: () => _showTimePicker(),

                  ),


                  Divider(height:20.0,indent:0.0,color: Colors.black54),

                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Row(
                        children: <Widget>[
                          new Icon(Icons.restore, size: 30.0,),
                          VerticalDivider(width:10.0,indent:0.0,color: Colors.transparent,),
                          new Text("重复提醒",
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ],
                      ),

                      new Switch(
                          value: isRepeat,
                          onChanged: (bool value){
                            setState(() {
                              isRepeat = value;
                            });
                          }),

                    ],
                  ),

                  new FloatingActionButton(
                    tooltip: "按这么长时间干嘛",
                    child: new Icon(Icons.done),
                    onPressed: null,
                  ),

                ],
              ),
            ),

          ),

        ),

      ]),

    );
  }
  _showDatePicker() async {
    var picker = await showDatePicker(context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime(2119),
    );
    setState(() {
      date = picker.toString().substring(0,10);
    });
  }

  _showTimePicker() async {
    var picker = await showTimePicker(context: context,
        initialTime: TimeOfDay.now());
    setState(() {
      time = picker.toString().substring(10,15);
      print(time);
    });
  }



}