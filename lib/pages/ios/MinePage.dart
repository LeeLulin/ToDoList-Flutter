import 'package:Doit/bean/Todos.dart';
import 'package:Doit/bean/user.dart';
import 'package:Doit/db/DatabaseHelper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:data_plugin/bmob/bmob_query.dart';
import 'package:data_plugin/bmob/response/bmob_error.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../HomePage.dart';
import '../LoginPage.dart';
import 'SettingPage.dart';

class MinePage extends StatefulWidget {
  @override
  _MinePageState createState() => new _MinePageState();

}
class _MinePageState extends State<MinePage> with TickerProviderStateMixin{
  var _items = [];
  int localTodos;
  var db = DatabaseHelper();
  List<int> items = List.generate(10, (i) => i); // 产生数据

  @override
  void initState() {
    super.initState();

    getUserInfo();

//    getTodoFromBmob();


  }

  void getUserInfo() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    objectId = sp.get("ObjectId");
    isLogin = sp.get("isLogin");
    if (objectId != null) {
      BmobQuery<User> bmobQuery = BmobQuery();
      bmobQuery.queryObject(objectId).then((data) {
        setState(() {
          User user = User.fromJson(data);
          nickName = user.nickName;
          autograph = user.autograph;
          if (user.img.url.toString() != null) {
            path = user.img.url.toString();
          }
        });


        print("昵称：" + nickName + " 个性签名: " + autograph + " 头像url：" + path);
      }).catchError((e) {
        print("Error: " + BmobError
            .convert(e)
            .error);
      });
      sp.setString("nickname", nickName);
      sp.setString("autograph", autograph);
      sp.setString("userImg", path);
    }
  }

  ///查询待办事项
  void getTodoFromBmob() async {
    localTodos = await db.getCount();
//    db.clearTodo();
    print("localTodo: " + localTodos.toString());
//    db.close();
    SharedPreferences sp = await SharedPreferences.getInstance();
    String objectId = sp.get("ObjectId");
    BmobQuery<Todos> query = BmobQuery();
    query.addWhereEqualTo("user", objectId);
    query.queryObjects().then((List<dynamic> data) {
      List<Todos> netTodo = data.map((i) => Todos.fromJson(i)).toList();
      print("查询到 " + netTodo.length.toString() + " 条数据");
      int index = 0;
      for (Todos todo in netTodo) {
        index++;
        if (todo != null) {
          print(index);
          print(todo.objectId);
          print(todo.title);
          print(todo.desc);
        }
      }
//      _items = netTodo;
      setState(() {
        _items = netTodo;
//        loadComplete = true;
      });
    }).catchError((e) {
      print(BmobError
          .convert(e)
          .error);
    });
  }

  Future<bool> getIsLogin() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    bool isLogin = sp.get("isLogin");
    if (isLogin) {
      print("登录状态：已登录");
      return true;
    } else {
      print("登录状态：未登录");
      return false;
    }
  }

  Widget title(BuildContext context){
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          GestureDetector(
            onTap: (){

            },
            child: Icon(Icons.settings, size: 30.0, color: Colors.black,),
          )
        ],
      ),
    );
  }

  Widget mineHeader(BuildContext context){
    var _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    // 缩放动画
    var _animation = Tween<double>(begin: 1, end: 0.95).animate(_animationController);
    return ScaleTransition(
      scale: _animation,
      child: Hero(
        tag: "login",
        child: Material(
          borderRadius: BorderRadius.circular(12.0),
          shadowColor: Colors.black54,
          color: Colors.white,
          elevation: 12.0,
          child: Container(
            padding: const EdgeInsets.all(10.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
                image: DecorationImage(
                  image: AssetImage("images/img_0.png"),
                  fit: BoxFit.fill,
                ),
            ),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    //设置按钮
                    GestureDetector(
                      onPanDown: (details) {
                        _animationController.forward();
                      },
                      // 抬起回弹卡片
                      onPanCancel: () {
                        _animationController.reverse();
                      },
                      // 手指溢出屏幕会谈卡片
                      onPanUpdate: (detials) {
                        _animationController.reverse();
                      },
                      onTap: (){
                        Navigator.of(context,rootNavigator: true).push<String>(
                            new CupertinoPageRoute(fullscreenDialog: true, builder: (BuildContext context) {
                              return new SettingPage();
                            })
                        ).then((String result){
                          setState(() {
                            getUserInfo();
                          });
                        });
                      },
                      child: Icon(Icons.settings, size: 25.0, color: Colors.black54,),
                    )
                  ],
                ),
                GestureDetector(
                  // 按下缩放卡片
                  onPanDown: (details) {
                    _animationController.forward();
                  },
                  // 抬起回弹卡片
                  onPanCancel: () {
                    _animationController.reverse();
                  },
                  // 手指溢出屏幕会谈卡片
                  onPanUpdate: (detials) {
                    _animationController.reverse();
                  },
                  onTap: () {
                    getIsLogin().then((bool isLogin) {
                      if (isLogin) {

                      } else {
                        Navigator.of(context,rootNavigator: true).push<String>(
                            new CupertinoPageRoute(fullscreenDialog: true,builder: (BuildContext context) {
                              return new LoginPage();
                            })
                        ).then((String result){
                          getUserInfo();
//                            getTodoFromBmob();
                        });
                      }
                    });
                  },
                  child: Padding(
                      padding: const EdgeInsets.all(.0),
                      child: Material(
                        elevation: 16.0,
                        shadowColor: Colors.black,
                        shape: CircleBorder(),
                        child: CircleAvatar(
                          radius: 55.0,
                          backgroundImage: new CachedNetworkImageProvider(path),
                        ),
                      )

                  ),

                ),

                Text(nickName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                Text(autograph,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),

          ),
        ),
      ),
    );
  }

  Widget tomatoCard(BuildContext context) {
    var _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    // 缩放动画
    var _animation = Tween<double>(begin: 1, end: 0.95).animate(_animationController);
    return ScaleTransition(
      scale: _animation,
      child: GestureDetector(
        // 按下缩放卡片
        onPanDown: (details) {
          _animationController.forward();
        },
        // 抬起回弹卡片
        onPanCancel: () {
          _animationController.reverse();
        },
        // 手指溢出屏幕会谈卡片
        onPanUpdate: (detials) {
          _animationController.reverse();
        },
        onTap: (){

        },
        child: Material(
          borderRadius: BorderRadius.circular(12.0),
          shadowColor: Colors.black54,
          elevation: 12.0,
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomCenter,
                colors: [ const Color(0xffFFAFBD), const Color(0xffffc3a0) ],
              ),
            ),

            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.access_time,
                      color: Colors.black,
                      size: 25.0,
                    ),
                    Text("番茄时钟",
                      style: TextStyle(
                        fontSize: 25.0,

                      ),
                    ),

                  ],
                ),
                SizedBox(height: 10.0,),
                Text("累计：3小时52分钟",
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w300
                  ),
                ),

              ],
            ),

          ),
        ),
      ),
    );
  }

  Widget todoCard(BuildContext context) {
    var _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    // 缩放动画
    var _animation = Tween<double>(begin: 1, end: 0.95).animate(_animationController);
    return ScaleTransition(
      scale: _animation,
      child: GestureDetector(
        // 按下缩放卡片
        onPanDown: (details) {
          _animationController.forward();
        },
        // 抬起回弹卡片
        onPanCancel: () {
          _animationController.reverse();
        },
        // 手指溢出屏幕会谈卡片
        onPanUpdate: (details) {
          _animationController.reverse();
        },
        onTap: (){

        },
        child: Material(
          borderRadius: BorderRadius.circular(12.0),
          shadowColor: Colors.black54,
          color: Colors.white,
          elevation: 12.0,
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomCenter,
                colors: [ const Color(0xff56CCF2), const Color(0xffB2FEFA), ],
              ),
            ),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.format_list_bulleted,
                      color: Colors.black,
                      size: 25.0,
                    ),
                    Text("待办事项",
                      style: TextStyle(
                        fontSize: 25.0,

                      ),
                    ),

                  ],
                ),
                SizedBox(height: 10.0,),
                Text("未完成：2",
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w300
                  ),
                ),

              ],
            ),

          ),
        ),
      ),
    );
  }

  Widget rankCard(BuildContext context){
    return Material(
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: Colors.black54,
        color: Colors.white,
        elevation: 12.0,
        child: Container(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
//            gradient: LinearGradient(
//              begin: Alignment.topCenter,
//              end: Alignment.bottomCenter,
//              colors: [const Color(0xffFFFFFF), const Color(0xff6DD5FA),  ],
//            ),
          ),
          height: 400.0,
          child: Scaffold(
            appBar: AppBar(
              title: Text("排行",
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.black,
                ),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            backgroundColor: Colors.transparent,
            body: Scrollbar(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context,int index){
                    return ListTile(
                      leading: new CircleAvatar(backgroundImage: AssetImage("images/user.png"),),
                      trailing: Text("${index + 1}"),
                      title: Text("User Name"),
                    );
                  },
                ),
            ),
          ),
        ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Container(
//        decoration: BoxDecoration(
//          gradient: LinearGradient(
//            begin: Alignment.topCenter,
//            end: Alignment.bottomCenter,
//            colors: [Colors.transparent, Colors.white70 ],
//          ),
//        ),
        child: SafeArea(
            child: Container(
              padding: const EdgeInsets.only(left:25.0, right: 25.0, top: 20.0,bottom: 10.0),
              child: Column(
                children: <Widget>[
//                  title(context),
//                  SizedBox(height: 10.0),
                  mineHeader(context),
                  SizedBox(height: 15.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      tomatoCard(context),

                      todoCard(context),
                    ],
                  ),
                  SizedBox(height: 15.0),
                  rankCard(context),
                ],
              ),
            )
        ),
      )
    );
  }
}