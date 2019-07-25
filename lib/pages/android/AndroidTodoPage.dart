import 'package:Doit/bean/Todos.dart';
import 'package:Doit/bean/user.dart';
import 'package:Doit/db/DatabaseHelper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:data_plugin/bmob/bmob_query.dart';
import 'package:data_plugin/bmob/response/bmob_error.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:Doit/pages/HomePage.dart';
import 'package:Doit/pages/LoginPage.dart';
import 'package:Doit/pages/NewTodoPage.dart';

class AndroidTodoPage extends StatefulWidget {


  @override
  _AndroidTodoPageState createState() => new _AndroidTodoPageState();

}

class _AndroidTodoPageState extends State<AndroidTodoPage> {

  var _items = [];
  int localTodos;
  var db = DatabaseHelper();
  bool loadComplete = false;
  TabController _tabController;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  @override
  void initState() {
    super.initState();

    getUserInfo();

    getTodoFromBmob();

  }

  void getUserInfo() async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    objectId = sp.get("ObjectId");
    isLogin = sp.get("isLogin");
    if(objectId != null){
      BmobQuery<User> bmobQuery = BmobQuery();
      bmobQuery.queryObject(objectId).then((data) {

        setState(() {
          User user = User.fromJson(data);
          nickName = user.nickName;
          autograph = user.autograph;
          if(user.img.url.toString() != null){
            path = user.img.url.toString();
          }

        });


        print("昵称："+nickName+" 个性签名: "+autograph+" 头像url：" + path);
      }).catchError((e) {
        print("Error: " + BmobError.convert(e).error);
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
    print("localTodo: " + localTodos.toString() );
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
      });

    }).catchError((e) {
      print(BmobError.convert(e).error);
    });

  }

  Future<bool> getIsLogin() async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    bool isLogin = sp.get("isLogin");
    if(isLogin){
      print("登录状态：已登录");
      return true;
    } else{
      print("登录状态：未登录");
      return false;
    }
  }



  Widget todoListView(BuildContext context) {
    return new Scaffold(
      body: new ListView.builder(
          primary: true,
          physics: new BouncingScrollPhysics(),
          itemCount: _items.length,
          itemBuilder: todoItemView
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () async {

          await Navigator.push<String>(super.context, new CupertinoPageRoute(builder: (context){

            return new NewTodoPage();

          })).then((String value){
            getTodoFromBmob();
          });


        },
        tooltip: '悬浮按钮',
        child: new Icon(Icons.add),
      ),

    );
  }

  Widget todoItemView(BuildContext context, int index) {
    Todos model = this._items[_items.length-1-index];
    return new Stack(
      children: <Widget>[
        new Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0 ),
          child: new SizedBox(
            height: 95.0,
            width: double.infinity,

            child: new Card(

              elevation: 10.0,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0))
              ),

              child: new Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                    image: AssetImage("images/img_0.png"),
                    fit: BoxFit.fill,
                  ),
                ),

                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new ListTile(

                      title: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                        children: <Widget>[
                          new Text(
                            " ${model.title}",
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          new Text(
                            " ${model.desc}",
                            style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold
                            ),
                          ),

                          new Text(
                            "${model.date} ${model.time}",
                            style: TextStyle(
                              fontSize: 11.0,
                            ),
                          ),
                        ],
                      ),

                      onTap: () {
//                        showSnackBar(context, );
                      },
                    )

                  ],

                ),


              ),
            ),
          ),

        ),

//        Positioned(
//          left: 20.0,
//          child: Container(
//            height: 36.0,
//            width: 2.0,
//            color: Colors.black,
//          ),
//        ),
//
//        Positioned(
//          top: 36.0,
//          left: 13.0,
//          child: Container(
//            height: 16.0,
//            width: 16.0,
//            decoration: BoxDecoration(
//              border: new Border.all(color: Colors.black, width: 2.0),
//              shape: BoxShape.circle,
//            ),
//          ),
//        ),
//
//        Positioned(
//          top: 52.0,
//          left: 20.0,
//          child: Container(
//            height: 48.0,
//            width: 2.0,
//            color: Colors.black,
//          ),
//        ),

      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return todoListView(context);
  }
}