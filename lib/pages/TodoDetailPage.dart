import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:Doit/bean/Todos.dart';


class TodoDetailPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    Todos todos = ModalRoute.of(context).settings.arguments;
    return Hero(
      tag: todos.title,
      child: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              // 展开的高度
              expandedHeight: 240.0,
              // 强制显示阴影
//              forceElevated: true,
              // 设置该属性，当有下滑手势的时候，就会显示 AppBar
              floating: true,
              // 该属性只有在 floating 为 true 的情况下使用，不然会报错
              // 当上滑到一定的比例，会自动把 AppBar 收缩（不知道是不是 bug，当 AppBar 下面的部件没有被 AppBar 覆盖的时候，不会自动收缩）
              // 当下滑到一定比例，会自动把 AppBar 展开
              //snap: true,
              // 设置该属性使 Appbar 折叠后不消失
              pinned: true,
              // 通过这个属性设置 AppBar 的背景
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: false,
                titlePadding: EdgeInsets.only(left: 45.0, bottom: 10.0),
                title: Text(
                  todos.title,
                  style: new TextStyle(
                    fontSize: 30.0,
                  ),
                ),
                // 背景折叠动画
                collapseMode: CollapseMode.parallax,
                background: Image.asset('images/img_0.png', fit: BoxFit.cover),
              ),
            ),
            SliverFillRemaining(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      todos.desc,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  )
                ],
              ),
            ),


          ],

        ),
      ),

    );
  }
}