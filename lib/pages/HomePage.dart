import 'package:Doit/bean/Todos.dart';
import 'package:Doit/bean/user.dart';
import 'package:Doit/db/DatabaseHelper.dart';
import 'package:Doit/pages/android/AndroidTodoPage.dart';
import 'package:Doit/pages/ios/IOSTodoPage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:data_plugin/bmob/bmob_query.dart';
import 'package:data_plugin/bmob/response/bmob_error.dart';
import 'package:data_plugin/bmob/table/bmob_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'LoginPage.dart';
import 'NewTodoPage.dart';
import 'ios/MinePage.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;
  static String tag = 'home-page';


  @override
  _HomePageState createState() => _HomePageState();

}

String nickName = "未登录";
String autograph = "点击头像以登录";
String path = "http://bmob-cdn-19979.bmobcloud.com/2018/06/22/9798869e40fe2c20809527c1bf9660fb.png";
String objectId;
String username;
String password;
bool isLogin = false;



class _HomePageState extends State<HomePage> with TickerProviderStateMixin{

  var _items = [];
  int localTodos;
  var db = DatabaseHelper();
  TabController _tabController;


  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void initState() {
    super.initState();

    _tabController = new TabController(vsync: this, length: 2);

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
      backgroundColor: Colors.white,
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
          padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 5.0 ),
          child: new SizedBox(
            height: 95.0,
            width: double.infinity,

            child: new Card(

              elevation: 5.0,
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
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();



  Widget iosTheme(BuildContext context){
    return CupertinoPageScaffold(
      child: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          border: Border.all(color: Colors.transparent),

          items: [
            BottomNavigationBarItem(title: Text("待办事项"), icon: Icon(CupertinoIcons.collections)),
            BottomNavigationBarItem(title: Text("番茄时钟"), icon: Icon(CupertinoIcons.clock)),
            BottomNavigationBarItem(title: Text("我"), icon: Icon(CupertinoIcons.person)),
          ],
        ),
        tabBuilder: (context, int index) {
          return CupertinoTabView(

            // ignore: missing_return
            builder: (context) {
              switch (index) {
                case 0:
                  return
                    IOSTodoPage();
                  break;

                case 1:

                  break;

                case 2:
                  return
                    MinePage();
                  break;
              }
            },
          );
        },

      ),


    );
  }

  Widget androidTheme(BuildContext context){
    getUserInfo();
    return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        backgroundColor: Colors.white,
          //AppBar渐变色
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[300], Colors.blue[400], Colors.blue[500], Colors.blue ],
              ),
            ),
          ),

        leading: new IconButton(
          icon: new Container(
            padding: EdgeInsets.all(3.0),
            child: new CircleAvatar(
              radius: 30.0,
              backgroundImage: new CachedNetworkImageProvider(path),
            ),
          ),
          onPressed: (){
            _scaffoldKey.currentState.openDrawer();
          },
        ),

        title: new Text(
          'Do it',

        ),
        elevation: 0,
        bottom: new TabBar(
          controller: _tabController,
          tabs: <Widget>[
            new Tab(icon: new Icon(Icons.today),),
            new Tab(icon: new Icon(Icons.access_time),),
          ],
        ),
      ),
      drawer: new Drawer(
        child: new ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.only(),
          children: <Widget>[
            new UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/img_0.png"),
                  fit: BoxFit.cover,
                ),
              ),
              accountName: new Text(
                nickName,
                style: new TextStyle(
                  fontSize: 20.0,
                ),
              ),
              accountEmail: new Text(
                autograph,
              ),
              currentAccountPicture: new GestureDetector(
                child: new CircleAvatar(
                  backgroundImage: new CachedNetworkImageProvider(path),
                ),
                ///点击头像登录
                onTap: (){
                  getIsLogin().then((bool isLogin){
                    if(isLogin){

                    } else{
                      Navigator.push<String>(context, new CupertinoPageRoute(builder: (BuildContext context){

                        return new LoginPage();

                      })).then( (String result){

                        getUserInfo();
                        getTodoFromBmob();

                      });
                    }
                  });



                },
              ),
            ),
            new ClipRect(
              child: new ListTile(
                leading: new Icon(
                  Icons.today,
                  color: Colors.black54,
                  size: 25.0,
                ),
                title: new Text('待办事项'),
                onTap: () => {},
              ),
            ),
            new ClipRect(
              child: new ListTile(
                leading: new Icon(
                  Icons.access_time,
                  color: Colors.black54,
                  size: 25.0,
                ),
                title: new Text('番茄时钟'),
                onTap: () {

                },
              ),
            ),
            new ClipRect(
              child: new ListTile(
                leading: new Icon(
                  Icons.equalizer,
                  color: Colors.black54,
                  size: 25.0,
                ),
                title: new Text('记录'),
                onTap: () => {},
              ),
            ),
            new ClipRect(
              child: new ListTile(
                leading: new Icon(
                  Icons.settings,
                  color: Colors.black54,
                  size: 25.0,
                ),
                title: new Text('设置'),
                onTap: () => {},
              ),
            ),

            new AboutListTile(
              icon: new Icon(
                Icons.info_outline,
                color: Colors.black54,
                size: 25.0,
              ),
              child: new Text("关于"),
              applicationName: "Do it",
              applicationVersion: "1.0.0",
              applicationIcon: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.asset(
                  "images/app_icon.png",
                  width: 60.0,
                  height: 60.0,

                ),
              ),
              aboutBoxChildren: <Widget>[
                new Text("Doit Flutter版本"),
                new Text("持续开发中..."),
              ],
            ),

            new ClipRect(
              child: new ListTile(
                leading: new Icon(
                  Icons.exit_to_app,
                  color: Colors.black54,
                  size: 25.0,
                ),
                title: new Text('退出登录'),
                onTap: () => {

                },
              ),
            ),

          ],
        ),
      ),

      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          new Center(
            child: AndroidTodoPage(),
          ),

          new Center(
              child: new Text('番茄时钟')
          ),
        ],
      ),


      floatingActionButton: new FloatingActionButton(
          onPressed: () async {

            await Navigator.push<String>(context, new CupertinoPageRoute(builder: (context){

              return new NewTodoPage();

            })).then((String value){
              getTodoFromBmob();
            });


          },
          tooltip: '按这么久干嘛',
          child: new Icon(Icons.add),
      ),


    );
  }


  @override
  Widget build(BuildContext context) {
//    return iosTheme(context);
//    return androidTheme(context);
    return defaultTargetPlatform == TargetPlatform.iOS
        ? iosTheme(context)
        : androidTheme(context);

  }



//  logOut() async{
//    isLogin = false;
//    print(isLogin.toString());
//    SharedPreferences sp = await SharedPreferences.getInstance();
//    sp.setBool("isLogin", false);
//  }



}



