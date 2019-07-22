import 'dart:io';

import 'package:Doit/bean/user.dart';
import 'package:Doit/widget/AnimatedLoginButton.dart';
import 'package:data_plugin/bmob/bmob_file_manager.dart';
import 'package:data_plugin/bmob/response/bmob_saved.dart';
import 'package:data_plugin/bmob/response/bmob_updated.dart';
import 'package:data_plugin/bmob/type/bmob_file.dart';
import 'package:flutter/material.dart';
import 'package:data_plugin/bmob/table/bmob_user.dart';
import 'package:data_plugin/bmob/response/bmob_error.dart';
import 'package:data_plugin/bmob/response/bmob_registered.dart';
import 'package:data_plugin/utils/dialog_util.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterPage extends StatefulWidget {
  static String tag = 'register-page';
  @override
  _RegisterPageState createState() => _RegisterPageState();
}
LoginErrorMessageController loginErrorMessageController=LoginErrorMessageController();
bool registerSuccess;
String objectId;
String _username, _password;
class _RegisterPageState extends State<RegisterPage> {

  @override
  Widget build(BuildContext context) {
//    ScreenUtil.instance = ScreenUtil(width: 828, height: 1792)..init(context);
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
                  prefixIcon: Icon(Icons.person),
                  labelText: '请输入要注册的账号',
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
                  prefixIcon: Icon(Icons.lock),
                  labelText: '请输入要账号密码',
                  border: InputBorder.none,
                ),
                onChanged: (String value) => _password = value,
              ),
            ],
          ),
        ),

      ),
    );

    var registerButton = new Container(
      decoration: new BoxDecoration(

        borderRadius: new BorderRadius.circular((20.0)), // 圆角度
        boxShadow: [BoxShadow(color: Colors.black12, offset: Offset(1.0, 2.0), blurRadius: 1.0, spreadRadius: 1.0),],

      ),
      child: new AnimatedLoginButton(
        loginErrorMessageController: loginErrorMessageController,
        loginTip: '注册',
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
          try{
            FocusScope.of(context).requestFocus(FocusNode());
            print(_username);

            if(_username == null || _password == null ){

              loginErrorMessageController.showErrorMessage("账号或密码为空");

            } else {

              BmobUser user = BmobUser();
              user.username = _username;
              user.password = _password;
              user.nickName = _username;
              user.autograph = "个性签名";
              user.total = 0;
              await user.save().then((BmobSaved data) {
                registerSuccess = true;
                  //插入用户数据

              }).catchError((e) {
                registerSuccess = false;
                print(BmobError.convert(e).error);

              });

//              updateUserInfo();



              if (registerSuccess == true) {
                Fluttertoast.showToast(
                  msg: "注册成功",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIos: 1,
                );
                Navigator.pop(context);
              } else {
                loginErrorMessageController.showErrorMessage("注册失败");
              }


            }

          } catch (e){
            print(e.toString());
          }

        },

      ),
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
//            leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () {
//              //返回代码
//              Navigator.pop(context);
//            }),

//            actions: <Widget>[
//              new FlatButton(
//                onPressed: (){
//                  Navigator.of(context).pushNamed(RegisterPage.tag);
//                },
//                child: new Text(
//                  '注册',
//                  style: new TextStyle(
//                      color: Colors.white,
//                      fontSize: 20.0),
//                ),
//              ),
//            ],

          ),

          body: new Padding(padding: new EdgeInsets.only(top:120.0,left: 24.0,right: 24.0),

            child: new Column(
//                        mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                logo,
                SizedBox(height: 40.0),
                userInfo,
                SizedBox(height: 30.0,),
                registerButton,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

updateUserInfo() async{
  BmobUser user = BmobUser();
  user.objectId = objectId;
  user.nickName = _username;
  user.autograph = "个性签名";
  user.total = 0;
  await user.update().then((BmobUpdated updated){
    print("更新成功");
  }).catchError((e){
    print(BmobError.convert(e).error);
  });
}

