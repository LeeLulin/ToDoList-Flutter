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

class MinePage extends StatefulWidget {
  @override
  _MinePageState createState() => new _MinePageState();

}
class _MinePageState extends State<MinePage> with TickerProviderStateMixin{
  var _items = [];
  int localTodos;
  var db = DatabaseHelper();

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

  Widget buildCells(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          GestureDetector(
            child: Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: <Widget>[
                        Icon(CupertinoIcons.info),
                        SizedBox(width: 20),
                        Text("关于", style: TextStyle(fontSize: 18)),
                        Expanded(child: Container()),
                        Icon(CupertinoIcons.right_chevron, color: Colors.black54,),
                      ],
                    ),
                  ),
                  Container(
                    height: 1,
                    color: Colors.black54,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget iosUserInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: CircleAvatar(
        radius: 40.0,
        backgroundImage: new CachedNetworkImageProvider(path),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    // 缩放动画
    var _animation = Tween<double>(begin: 1, end: 0.95).animate(_animationController);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            ScaleTransition(
              scale: _animation,
              child: Hero(
                tag: "login",
                child: Container(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                  child: Material(
                    color: Colors.white,
                    elevation: 16.0,
                    shadowColor: Colors.black54,
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    child: Container(
                      padding: const EdgeInsets.all(15.0),
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
//                                    getTodoFromBmob();
                                  });
                                }
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: CircleAvatar(
                                radius: 40.0,
                                backgroundImage: new CachedNetworkImageProvider(path),
                              ),
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
              ),
            ),

          ],
        ),
      ),
    );
  }
}