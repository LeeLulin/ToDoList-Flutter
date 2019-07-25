import 'package:Doit/widget/AnimatedLoginButton.dart';
import 'package:flutter/material.dart';
import 'package:Doit/pages/RegisterPage.dart';
import 'package:data_plugin/bmob/table/bmob_user.dart';
import 'package:data_plugin/bmob/response/bmob_error.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState();
}
LoginErrorMessageController loginErrorMessageController=LoginErrorMessageController();

class _LoginPageState extends State<LoginPage> {
  bool loginSuccess;
  bool isLogin = false ;
  String _username, _password;
  FocusNode nextTextFieldNode = FocusNode();

  @override
  Widget build(BuildContext context) {

    final logo = new CircleAvatar(
      backgroundColor: Colors.transparent,
      radius: 48.0,
      child: new Image.asset('images/do_it.png'),
    );
    final userInfo = new Container(
//      height: 120.0,
      decoration: new BoxDecoration(
        color: Colors.white, // 底色
        borderRadius: new BorderRadius.circular((5.0)), // 圆角度
        boxShadow: [
          BoxShadow(color: Colors.black12,
              offset: Offset(2.0, 2.0),
              blurRadius: 2.0,
              spreadRadius: 2.0),
        ],

      ),
      child: new Center(
        child: new Padding(
          padding: new EdgeInsets.only(left: 10.0, right: 10.0),
          child: new Column(
            children: <Widget>[
              TextField(
                keyboardType: TextInputType.emailAddress,
                autofocus: false,
                decoration: new InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  labelText: '账号',
                  border: InputBorder.none,
                ),
                onChanged: (String value) => _username = value,
              ),
              Divider(height: 1.0, color: Colors.black12,),
              TextField(
                keyboardType: TextInputType.text,
                autofocus: false,
                obscureText: true,
                decoration: new InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  labelText: '密码',
                  border: InputBorder.none,
                ),
                onChanged: (String value) => _password = value,
              ),
            ],
          ),
        ),

      ),
    );

    var loginButton = new Container(
      decoration: new BoxDecoration(

        borderRadius: new BorderRadius.circular((20.0)), // 圆角度
        boxShadow: [
          BoxShadow(color: Colors.black12,
              offset: Offset(1.0, 2.0),
              blurRadius: 1.0,
              spreadRadius: 1.0),
        ],

      ),
      child: new AnimatedLoginButton(
        loginErrorMessageController: loginErrorMessageController,
        loginTip: '登录',
        buttonColorNormal: Colors.blue[300],
        buttonColorError: Colors.pink,
        textStyleNormal: TextStyle(
          color: Colors.white,
          fontSize: 18.0,
        ),
        textStyleError: TextStyle(
          color: Colors.white,
          fontSize: 18.0,
        ),
        onTap: () async {
          try {
            FocusScope.of(context).requestFocus(FocusNode());
            print(_username);

            if (_username == null || _password == null) {
              loginErrorMessageController.showErrorMessage("请输入账号或密码");
            } else {
              BmobUser bmobUserRegister = BmobUser();
              bmobUserRegister.username = _username;
              bmobUserRegister.password = _password;
              await bmobUserRegister.login().then((BmobUser bmobUser) {
                loginSuccess = true;
                isLogin = true;
                print("账号: " + bmobUser.username);
                print("用户ObjectId: " + bmobUser.getObjectId());
                saveUserInfo(bmobUser.getObjectId());
              }).catchError((e) {
                loginSuccess = false;
                print(BmobError
                    .convert(e)
                    .error);
              });

              if (loginSuccess == true) {
                Fluttertoast.showToast(
                  msg: "登陆成功",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIos: 1,
                );
                Navigator.of(context).pop("sucess");
              } else {
                loginErrorMessageController.showErrorMessage("账号或密码错误");
              }
            }
          } catch (e) {
            print(e.toString());
          }
        },

      ),
    );




    final skipLogin = new FlatButton(
      onPressed: () {
//        Navigator.of(context).pushNamed(RegisterPage.tag);
        Navigator.pop(context);
      },
      child: new Text(
        '跳过',
        style: new TextStyle(
          color: Colors.black54,
          fontSize: 16.0,
          decoration: TextDecoration.underline,),),
    );

    return Scaffold(
      body: Hero(
        tag: "login",
        child: new Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            image: DecorationImage(
              image: AssetImage("images/login_bg.png"),
              fit: BoxFit.fill,),),

          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Scaffold(
              resizeToAvoidBottomPadding: false,
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,

                actions: <Widget>[
                  new FlatButton(
                    onPressed: () {
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

              body: new Container(
                padding: new EdgeInsets.only(top: 140.0, left: 24.0, right: 24.0),

                child: new Column(
                  children: <Widget>[
                    logo,
                    SizedBox(height: 40.0),
                    userInfo,
                    SizedBox(height: 30.0,),
                    loginButton,
                    SizedBox(height: 24.0,),
                    skipLogin,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

  }


  saveUserInfo(String ObjectId) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString("ObjectId", ObjectId);
    sp.setBool("isLogin", isLogin);

  }




}
