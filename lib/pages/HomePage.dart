import 'package:Doit/bean/user.dart';
import 'package:data_plugin/bmob/bmob_query.dart';
import 'package:data_plugin/bmob/response/bmob_error.dart';
import 'package:data_plugin/bmob/table/bmob_user.dart';
import 'package:data_plugin/bmob/type/bmob_file.dart';
import 'package:flutter/material.dart';
import 'package:Doit/widget/TodoView.dart';

import 'package:Doit/model/todo.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'LoginPage.dart';

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
String isLogin;

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{

  TabController _tabController;
  final List<Todo> _allCities = Todo.allTodos();


  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);

  }

  @override
  Widget build(BuildContext context) {

    //加载用户信息
    setState(() {
      getUserInfo();
    });

    final _drawerHeader = new UserAccountsDrawerHeader(
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
          backgroundImage: new NetworkImage(path),
        ),
        onTap: (){
          if(isLogin != null){
            Navigator.push<String>(context, new MaterialPageRoute(builder: (BuildContext context){

              return new LoginPage();

            })).then( (String result){
              //处理代码
              if(result != null){
                setState(() {
                  getUserInfo();
                });
              }

            });
            print("JumpLogin");
          } else if(isLogin == null){
            Fluttertoast.showToast(
              msg: "已登录",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
            );
          }

          },
      ),
//      currentAccountPicture: new CircleAvatar(
//
//        backgroundImage: new AssetImage("images/user.png"),
//
//      ),
//      onDetailsPressed: () {},
    );



    final myDrawer = new ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(),
      children: <Widget>[
        _drawerHeader,
        new ClipRect(
          child: new ListTile(
            leading: new CircleAvatar(child: new Icon(Icons.today)),
            title: new Text('待办事项'),
            onTap: () => {},
          ),
        ),
        new ClipRect(
          child: new ListTile(
            leading: new CircleAvatar(child: new Icon(Icons.access_time)),
            title: new Text('番茄时钟'),
            onTap: () => {},
          ),
        ),
        new ClipRect(
          child: new ListTile(
            leading: new CircleAvatar(child: new Icon(Icons.equalizer)),
            title: new Text('记录'),
            onTap: () => {},
          ),
        ),
        new ClipRect(
          child: new ListTile(
            leading: new CircleAvatar(child: new Icon(Icons.settings)),
            title: new Text('设置'),
            onTap: () => {},
          ),
        ),

        new AboutListTile(
          icon: new CircleAvatar(child: new Icon(Icons.info_outline)),
          child: new Text("关于"),
          applicationName: "Do it-flutter",
          applicationVersion: "1.0",
          applicationIcon: new Image.asset(
            "images/user.png",
            width: 64.0,
            height: 64.0,
          ),
          applicationLegalese: "applicationLegalese",
          aboutBoxChildren: <Widget>[
            new Text("BoxChildren"),
            new Text("box child 2")
          ],
        ),
        new ClipRect(
          child: new ListTile(
            leading: new CircleAvatar(child: new Icon(Icons.exit_to_app)),
            title: new Text('退出登录'),
            onTap: (){
              setState(() {
//                logOut();
              });
            },
          ),
        ),
      ],
    );

    return Scaffold(
      appBar: new AppBar(
        title: new Text('Do it'),
        bottom: new TabBar(
          controller: _tabController,
          tabs: <Widget>[
            new Tab(icon: new Icon(Icons.today),),
            new Tab(icon: new Icon(Icons.access_time),),
          ],
        ),
      ),
      drawer: new Drawer(
        child: myDrawer,
      ),

      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          new Center(
              child: TodoListView(_allCities)
          ),

          new Center(
              child: new Text('番茄时钟')),
        ],
      ),

      floatingActionButton: new Builder(builder: (BuildContext context){
        return new FloatingActionButton(
          onPressed: () {
            Scaffold.of(context).showSnackBar(new SnackBar(
              content: new Text("点击了按钮"),
            ));
          },
          tooltip: '悬浮按钮',
          child: new Icon(Icons.add),
        );
      }),


    );

  }

  getUserInfo() async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    objectId = sp.get("ObjectId");
    isLogin = sp.get("login");
    if(objectId != null){
      BmobQuery<User> bmobQuery = BmobQuery();
      bmobQuery.queryObject(objectId).then((data) {
        User user = User.fromJson(data);
        nickName = user.nickName;
        autograph = user.autograph;
        path = user.img.url.toString();
        print("昵称："+nickName+" 个性签名: "+autograph+" 头像url：" + path);
      }).catchError((e) {
        print("Error: " + BmobError.convert(e).error);
      });
      sp.setString("nickname", nickName);
      sp.setString("autograph", autograph);
      sp.setString("userImg", path);

    }
//    setState(() {
//
//    });

//  else{
//    nickName = "未登录";
//    autograph = "点击头像以登录";
//    path = "http://bmob-cdn-19979.bmobcloud.com/2018/06/22/9798869e40fe2c20809527c1bf9660fb.png";
//  }
  }


}





