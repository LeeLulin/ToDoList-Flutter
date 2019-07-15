import 'package:flutter/material.dart';
import 'package:Doit/pages/LoginPage.dart';

class DrawerBuilder {

  static Widget _drawerHeader(BuildContext context) {
    return new UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/img_0.png"),
          fit: BoxFit.cover,
        ),
      ),
      accountName: new Text(
        "Lulin",
        style: new TextStyle(
          fontSize: 20.0,
        ),
      ),
      accountEmail: new Text(
        "此时此地此身",
      ),
      currentAccountPicture: new GestureDetector(
        child: new CircleAvatar(
          backgroundImage: new AssetImage("images/user.png"),
        ),
        onTap: (){
          Navigator.of(context).pushNamed(LoginPage.tag);
          print("JumpLogin");
        },
      ),
//      currentAccountPicture: new CircleAvatar(
//
//        backgroundImage: new AssetImage("images/user.png"),
//
//      ),
//      onDetailsPressed: () {},
    );
  }

  static Widget myDrawer(BuildContext context) {
    return new ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.only(),
        children: <Widget>[
      _drawerHeader(context),
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
    ]);
  }

}