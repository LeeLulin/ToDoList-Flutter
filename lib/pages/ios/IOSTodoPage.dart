import 'package:Doit/bean/Todos.dart';
import 'package:Doit/bean/user.dart';
import 'package:Doit/db/DatabaseHelper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:data_plugin/bmob/bmob_query.dart';
import 'package:data_plugin/bmob/response/bmob_error.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/animation.dart';

import 'package:Doit/pages/HomePage.dart';
import 'package:Doit/pages/LoginPage.dart';
import 'package:Doit/pages/NewTodoPage.dart';

import '../TodoDetailPage.dart';

class IOSTodoPage extends StatefulWidget {


  @override
  _IOSTodoPageState createState() => new _IOSTodoPageState();

}


class _IOSTodoPageState extends State<IOSTodoPage> with TickerProviderStateMixin{

  var _items = [];
  int localTodos;
  var db = DatabaseHelper();
  bool loadComplete = false;

  @override
  void initState() {
    super.initState();

    getUserInfo();

    getTodoFromBmob();


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
        loadComplete = true;
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

    Widget iosTodoView(BuildContext context) {
      return Scaffold(
        floatingActionButton: Container(
          padding: const EdgeInsets.only(bottom: 90.0),
          child: new FloatingActionButton(
            tooltip: '按这么久干嘛',
            child: new Icon(CupertinoIcons.add),
            onPressed: () async {
              await Navigator.push<String>(
                  context, new CupertinoPageRoute(builder: (context) {
                return new NewTodoPage();
              })).then((String value) {
                getTodoFromBmob();
              });
            },
          ),
        ),


        body: CustomScrollView(
          slivers: <Widget>[
            CupertinoSliverNavigationBar(
              border: Border.all(color: Colors.transparent),
//              backgroundColor: CupertinoColors.white,
              largeTitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Text("待办事项"),
                  ),
//                  FloatingActionButton(
//                    onPressed: () async {
//                      await Navigator.push<String>(
//                          context, new CupertinoPageRoute(builder: (context) {
//                        return new NewTodoPage();
//                      })).then((String value) {
//                        getTodoFromBmob();
//                      });
//                    },
//                    tooltip: '悬浮按钮',
//                    child: new Icon(Icons.add),
//                  ),
//                  FlatButton(
//
//                    shape: CircleBorder(),
//                    color: Colors.black87,
//                    child: Icon(Icons.add,color: Colors.white, size: 20.0,),
//                    onPressed: () async {
//                      await Navigator.push<String>(
//                          context, new CupertinoPageRoute(builder: (context) {
//                        return new NewTodoPage();
//                      })).then((String value) {
//                        getTodoFromBmob();
//                      });
//                    },
//                  ),
                  iosUserImg(context),
                ],
              ),
            ),
            ///加载指示器
            loadComplete
                ? _dataLoadComplete(context)
                : _beforeDataLoaded()
          ],
        ),
      );
    }

    Widget iosUserImg(BuildContext context) {
      return Padding(
          padding: const EdgeInsets.only(right: 16.0),

          child: GestureDetector(
            child: CircleAvatar(
              radius: 18.0,
              backgroundImage: new CachedNetworkImageProvider(path),
            ),
            onTap: () {
              getIsLogin().then((bool isLogin) {
                if (isLogin) {

                } else {
                  Navigator.push<String>(context,
                      new CupertinoPageRoute(builder: (BuildContext context) {
                        return new LoginPage();
                      })).then((String result) {
                    getUserInfo();
                    getTodoFromBmob();
                  });
                }
              });
            },
          )

      );
    }

    ///加载前
    Widget _beforeDataLoaded(){
    if(_items == null){
      return new SliverFillRemaining(
        child: Center(
          child: Text("点击右下角按钮新建待办"),
        )
      );
    } else{
      return new SliverFillRemaining(
        child:  new Container(
          child: new Center(
            child: new CupertinoActivityIndicator(),
          ),
        ),
      );
    }
  }

    ///加载后
    Widget _dataLoadComplete(BuildContext context) {
      return SliverSafeArea(
        top: false,
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate((context, int index) {
            Todos model = this._items[_items.length - 1 - index];
            var _animationController = AnimationController(
              vsync: this,
              duration: Duration(milliseconds: 200),
            );
            // 卡片缩放动画
            var _animation = Tween<double>(begin: 1, end: 0.95).animate(_animationController);
            return new GestureDetector(
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
                Navigator.of(context).push(
                  CupertinoPageRoute(
                      builder: (context) {
                        return TodoDetailPage();
                      },
                      fullscreenDialog: true,
                      settings: RouteSettings(arguments: model),
                  )
                );
              },
              child: Container(
                child: ScaleTransition(
                  scale: _animation,
                  child: Hero(
                    tag: model.title,
                    child: Stack(
                      children: <Widget>[
                        new Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10, bottom: 10.0),
                          child: new SizedBox(
                            height: 155,
                            width: double.infinity,
                            child: new Material(
                              color: Colors.white,
                              elevation: 12.0,
                              shadowColor: Colors.black54,
                              borderRadius: BorderRadius.all(Radius.circular(12.0)),
                              child: new Column(
                                children: <Widget>[

                                  new AspectRatio(
                                    aspectRatio: 3.8,
                                    child: new Container(
                                      padding: const EdgeInsets.only(left: 14.0),
                                      alignment: Alignment.centerLeft,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(12.0),
                                          topRight: Radius.circular(12.0),
                                        ),
                                        image: DecorationImage(
                                          image: AssetImage("images/img_0.png"),
                                          fit: BoxFit.cover,
                                        ),
                                      ),

                                      child: new Text(
                                        model.title == null
                                            ? " "
                                            : model.title,
                                        style: TextStyle(
                                            fontSize: 35.0,
                                            fontWeight: FontWeight.w400
                                        ),
                                      ),
                                    ),
                                  ),
                                  new Material(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12.0),
                                    child: new Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        new ListTile(
                                          title: new Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[

                                              new Text(
                                                model.desc == null
                                                    ? " "
                                                    : model.desc,
                                                style: TextStyle(
                                                    fontSize: 15.0,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),

                                              new Text(
                                                model.date == null
                                                    ? " "
                                                    : "${model.date} ${model
                                                    .time}",
                                                style: TextStyle(
                                                  fontSize: 11.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )

                                      ],
                                    ),

                                  ),
                                ],
                              ),
                            ),
                          ),

                        ),

                      ],
                    ),
                  ),

                ),
              ),

            );
            },
            childCount: _items.length,
          ),
        ),
      );
  }


  @override
  Widget build(BuildContext context) {
      return iosTodoView(context);
  }

}