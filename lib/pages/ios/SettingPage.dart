import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_settings/flutter_cupertino_settings.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';

class SettingPage extends StatefulWidget{
  @override
  _SettingPageState createState() => new _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {

  double _slider = 0.5;
  bool _switchRing = true;
  bool _switchVibrator = true;
  int _index = 0;
  String _cacheSizeStr;

  @override
  void initState() {
    super.initState();
    loadCache();
  }

  ///加载缓存
  Future<Null> loadCache() async {
    try {

      Directory tempDir = await getTemporaryDirectory();
      double value = await _getTotalSizeOfFilesInDir(tempDir);
      /*tempDir.list(followLinks: false,recursive: true).listen((file){
          //打印每个缓存文件的路径
        print(file.path);
      });*/
      print('临时目录大小: ' + value.toString());
      setState(() {
        _cacheSizeStr = _renderSize(value);
      });
    } catch (err) {
      print(err);
    }
  }
  /// 递归方式 计算文件的大小
  Future<double> _getTotalSizeOfFilesInDir(final FileSystemEntity file) async {
    try {
      if (file is File) {
        int length = await file.length();
        return double.parse(length.toString());
      }
      if (file is Directory) {
        final List<FileSystemEntity> children = file.listSync();
        double total = 0;
        if (children != null)
          for (final FileSystemEntity child in children)
            total += await _getTotalSizeOfFilesInDir(child);
        return total;
      }
      return 0;
    } catch (e) {
      print(e);
      return 0;
    }
  }

  ///格式化文件大小
  _renderSize(double value) {
    if (null == value) {
      return 0;
    }
    List<String> unitArr = List()
      ..add('B')
      ..add('K')
      ..add('M')
      ..add('G');
    int index = 0;
    while (value > 1024) {
      index++;
      value = value / 1024;
    }
    String size = value.toStringAsFixed(2);
    return size + unitArr[index];
  }

  void _clearCache() async {
    //此处展示加载loading

    try {
      Directory tempDir = await getTemporaryDirectory();
      //删除缓存目录
      await delDir(tempDir);
      await loadCache();
      Fluttertoast.showToast(
        msg: "清除缓存成功",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
      );
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
        msg: "清除缓存失败",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
      );
    } finally {
      //此处隐藏加载loading
    }
  }
  ///递归方式删除目录
  Future<Null> delDir(FileSystemEntity file) async {
    try {
      if (file is Directory) {
        final List<FileSystemEntity> children = file.listSync();
        for (final FileSystemEntity child in children) {
          await delDir(child);
        }
      }
      await file.delete();
    } catch (e) {
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: CupertinoNavigationBar(
        leading: IconButton(
          icon: Icon(CupertinoIcons.clear_thick, color: Colors.black),
          onPressed: () => Navigator.of(context).pop('close'),
        ),
        middle: Text('设置'),
      ),
      body: CupertinoSettings(
        items: <Widget>[
          CSHeader('通知'),
          CSControl(
            '声音',
            CupertinoSwitch(
              activeColor: Colors.blue,
              value: _switchRing,
              onChanged: (bool value) {
                setState(() {
                  _switchRing = value;
                });
              },
            ),
            fontSize: 18.0,
          ),

          CSControl(
            '震动',
            CupertinoSwitch(
              activeColor: Colors.blue,
              value: _switchVibrator,
              onChanged: (bool value) {
                setState(() {
                  _switchVibrator = value;
                });
              },
            ),
            fontSize: 18.0,
          ),
          CSHeader('Selection'),
          CSSelection(
            ['Day mode', 'Night mode'],
                (int value) {
              setState(() {
                _index = value;
              });
            },
            currentSelection: _index,
          ),
          CSHeader(""),
          GestureDetector(

            child:CSControl(
              '清除缓存',
              Text('$_cacheSizeStr '),
              fontSize: 18.0,
            ),
            onTap: () => _clearCache(),
          ),
          GestureDetector(

            child:CSControl(
              '关于',
              Text('Version: 1.0.0'),
              fontSize: 18.0,
            ),
            onTap: () {

            },
          ),

          CSHeader(""),
          CSButton(CSButtonType.DESTRUCTIVE, "退出登录", () {}),
        ],
      ),
    );
  }
}