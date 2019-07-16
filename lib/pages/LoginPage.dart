import 'package:flutter/material.dart';
import 'package:Doit/pages/HomePage.dart';
import 'package:Doit/pages/RegisterPage.dart';
import 'package:data_plugin/bmob/table/bmob_user.dart';
import 'package:data_plugin/bmob/response/bmob_error.dart';
import 'package:data_plugin/utils/dialog_util.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _username, _password;
  @override
  Widget build(BuildContext context) {

    final logo = new Hero(
      tag: 'hero',
      child: new CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: new Image.asset('images/do_it.png'),
      ),
    );

    final userInfo = new Container(
//      height: 120.0,
      decoration: new BoxDecoration(
        color: Colors.white, // 底色
        borderRadius: new BorderRadius.circular((5.0)), // 圆角度
        boxShadow: [BoxShadow(color: Colors.black12, offset: Offset(2.0, 2.0), blurRadius: 2.0, spreadRadius: 2.0),],

    ),
      child: new Center(
        child: new Padding(padding: new EdgeInsets.only(left: 24.0,right: 24.0),
          child: new Column(
            children: <Widget>[
              TextField(
                keyboardType: TextInputType.emailAddress,
                autofocus: false,
                decoration: new InputDecoration(
                  hintText: '账号',
                  border: InputBorder.none,
                ),
                onChanged: (String value) => _username = value,
              ),
              Divider(height: 1.0,color: Colors.black12,),
              TextField(
                keyboardType: TextInputType.text,
                autofocus: false,
                obscureText: true,
                decoration:  new InputDecoration(
                  hintText: '密码',
                  border: InputBorder.none,
                ),
                onChanged: (String value) => _password = value,
              ),
            ],
          ),
        ),

      ),
    );

    final loginButton = new Padding(
      padding: new EdgeInsets.symmetric(vertical: 16.0),
        child: new MaterialButton(
          shape: RoundedRectangleBorder(
              side: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(32.0))
          ),
          minWidth: 220.0,
          height: 45.0,
          elevation: 5.0,
          color: Colors.blue[300],
          onPressed: (){
            FocusScope.of(context).requestFocus(FocusNode());
            BmobUser bmobUserRegister = BmobUser();
            bmobUserRegister.username = _username;
            bmobUserRegister.password = _password;
            print(_username);
            if(_username != null && _password != null){
              bmobUserRegister.login().then((BmobUser bmobUser) {

              print("username: " + bmobUser.username);
                Fluttertoast.showToast(
                  msg: "登陆成功",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIos: 1,
                );
                print("用户ObjectId: "+ bmobUser.getObjectId());
                saveUserInfo(bmobUser.getObjectId());
                Navigator.of(context).pop("sucess");

              }).catchError((e) {

                Fluttertoast.showToast(
                  msg: "账号或密码不正确！",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIos: 1,
                );
                print(BmobError.convert(e).error);

              });

            } else{
              Fluttertoast.showToast(
                msg: "账号或密码不能为空！",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIos: 1,
              );
            }


          },

          child: new Text(
            '登录',
            style: new TextStyle(
                color: Colors.white,
                fontSize: 20.0),
          ),
        ),

    );

    final skipLogin = new FlatButton(
      onPressed: (){
//        Navigator.of(context).pushNamed(RegisterPage.tag);
        Navigator.pop(context);
      },
      child: new Text(
        '跳过',
        style: new TextStyle(
          color: Colors.black54,
          fontSize: 20.0,
          decoration: TextDecoration.underline,),),
    );

    return new Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        image: DecorationImage(
          image: AssetImage("images/login_bg.png"),
          fit: BoxFit.fill,),),

            child: GestureDetector(
              onTap: (){
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Scaffold(
                resizeToAvoidBottomPadding: false,
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: Text(""),
//                    leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () {
//                      //返回代码
//
//                    }),

                  actions: <Widget>[
                    new FlatButton(
                      onPressed: (){
                        Navigator.of(context).pushNamed(RegisterPage.tag);
                      },
                      child: new Text(
                        '注册',
                        style: new TextStyle(
                            color: Colors.white,
                            fontSize: 20.0),
                      ),
                    ),
                  ],

                ),

                body: new Padding(padding: new EdgeInsets.only(top:120.0,left: 24.0,right: 24.0),

                    child: new Column(
//                        mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        logo,
                        SizedBox(height: 40.0),
                        userInfo,
                        SizedBox(height: 24.0,),
                        loginButton,
                        skipLogin,
                      ],
                    ),
                ),
              ),
            ),
    );

  }
  saveUserInfo(String ObjectId) async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString("ObjectId", ObjectId);
    sp.setString("username", _username);
    sp.setString("password", _password);
    sp.setString("isLogin", "login");
  }
}






