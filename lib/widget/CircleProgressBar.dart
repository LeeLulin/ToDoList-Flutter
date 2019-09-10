import 'dart:async';

import 'package:Doit/bean/user.dart';
import 'package:Doit/utils/ValueNotifierData.dart';
import 'package:common_utils/common_utils.dart';
import 'package:data_plugin/bmob/response/bmob_error.dart';
import 'package:data_plugin/bmob/response/bmob_updated.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CircleProgressBar extends StatefulWidget {
  final Color backgroundColor;
  final Color foreColor;
  final int duration;
  final double size;
  final bool textPercent;
  final double strokeWidth;
  final double startNumber;
  final double maxNumber;
  final TextStyle textStyle;
  final ValueNotifierData data;

  const CircleProgressBar(
      this.data,
      this.size, {
        this.backgroundColor = Colors.grey,
        this.foreColor = Colors.blueAccent,
        this.duration = 3000,
        this.strokeWidth = 10.0,
        this.textStyle,
        this.startNumber = 0.0,
        this.maxNumber = 360,
        this.textPercent = true,
      });

  @override
  State<StatefulWidget> createState() {
    return CircleProgressBarState();
  }
}

class CircleProgressBarState extends State<CircleProgressBar> with SingleTickerProviderStateMixin {
  Animation<double> _doubleAnimation;
  AnimationController _animationController;
  CurvedAnimation curve;
  bool _play = false, _stop = true;
  Timer _timer;
  int seconds;
  String info;
  int total;
  String objectId;


  @override
  void initState() {
    super.initState();
    getUserTotal();
    _animationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: widget.duration));

    curve = new CurvedAnimation(parent: _animationController, curve: Curves.decelerate);
    _doubleAnimation = new Tween(begin: widget.startNumber, end: widget.maxNumber).animate(curve);

    _animationController.addListener(() {
      setState(() {});
    });
    seconds = widget.duration ~/ 1000;
    widget.data.addListener(_handleValueChanged);
//    onAnimationStart();
  }

//  @override
//  void reassemble() {
//    onAnimationStart();
//  }

  onAnimationStart() {
    _animationController.forward(from: widget.startNumber);
  }

  @override
  void dispose() {
    _animationController.dispose();
    cancelTimer();
    super.dispose();
  }

  void startTimer() {
    //设置 1 秒回调一次
    const period = const Duration(seconds: 1);
    _timer = Timer.periodic(period, (timer) {
      //更新界面
      setState(() {
        //秒数减一，因为一秒回调一次
        seconds--;
      });
      if (seconds == 0) {
        //倒计时秒数为0，取消定时器
        cancelTimer();

        User user = User();
        user.objectId = objectId;
        user.total = total + (widget.duration ~/ 1000 ~/ 60);
        user.update().then((BmobUpdated bmobUpdated){
          print("update success");
        }).catchError((e){
          print(BmobError.convert(e).error);
        });

      }
    });
  }

  void cancelTimer() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
  }

  void _handleValueChanged() {
    cancelTimer();
  }

  void getUserTotal() async{
  SharedPreferences sp = await SharedPreferences.getInstance();
  objectId = sp.getString("ObjectId");
  total = sp.getInt("total");
  print("ObjectId: " + objectId + " Total: $total");
}

  @override
  Widget build(BuildContext context) {
    var percent = (_doubleAnimation.value / widget.maxNumber * 100).round();
    var countDownTime = widget.duration - (widget.duration * percent * 0.01);
    return Column(
      children: <Widget>[
        Container(
          width: widget.size,
          height: widget.size,
          child: CustomPaint(
            painter: CircleProgressBarPainter(
                widget.backgroundColor,
                widget.foreColor,
                widget.startNumber / widget.maxNumber * 360,
                _doubleAnimation.value / widget.maxNumber * 360,
                widget.maxNumber / widget.maxNumber * 360,
                widget.strokeWidth),
            size: Size(widget.size, widget.size),
            child: Center(
              child: Text(
                "${DateUtil.formatDateMs(
                    seconds * 1000,
                    format: "mm:ss")}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 50.0,
                ),
//                "${_doubleAnimation.value.round() == widget.maxNumber ? "完成" : "${widget.textPercent ? "$percent%" : "${_doubleAnimation.value.round()}/${widget.maxNumber.round()}"}"}",
//                style: widget.textStyle == null
//                    ? TextStyle(color: Colors.black, fontSize: 20)
//                    : widget.textStyle,
              ),
            ),
          ),
        ),
        Center(
          child: Stack(
            children: <Widget>[
              Offstage(
                offstage: _play,
                child: Container(
                  padding: const EdgeInsets.only(top: 80.0 ),
                  child: IconButton(
                    onPressed: (){
                      onAnimationStart();
                      startTimer();
                      setState(() {
                        _play = true;
                        _stop = false;
                      });
                    },
                    icon: Icon(CupertinoIcons.play_arrow_solid, color: Colors.white),
                    iconSize: 40.0,
                  ),
                ),
              ),
              Offstage(
                offstage: _stop,
                child: Container(
                  padding: const EdgeInsets.only(top: 80.0 ),
                  child: IconButton(
                    onPressed: (){
                      showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoAlertDialog(
                              title: Text("提示"),
                              content: Text("番茄钟将作废"),
                              actions: <Widget>[
                                CupertinoDialogAction(
                                  child: Text("确定"),
                                  isDefaultAction: true,
                                  onPressed: () {
                                    cancelTimer();
                                    Navigator.pop(context);
                                    Navigator.of(super.context).pop(true);
                                  },
                                ),
                                CupertinoDialogAction(
                                  child: Text("取消"),
                                  isDestructiveAction: true,

                                  onPressed: () => Navigator.of(super.context).pop(false),
                                ),

                              ],
                            );
                          });
                    },
                    icon: Icon(Icons.stop, color: Colors.white),
                    iconSize: 40.0,
                  ),
                ),
              ),
            ],
          )
        ),
      ],
    );
  }
}

class CircleProgressBarPainter extends CustomPainter {
  var _paintBckGround;
  var _paintFore;

  final _strokeWidth;
  final _backgroundColor;
  final _foreColor;
  final _startAngle;
  final _sweepAngle;
  final _endAngle;

  CircleProgressBarPainter(this._backgroundColor, this._foreColor,
      this._startAngle, this._sweepAngle, this._endAngle, this._strokeWidth) {
    _paintBckGround = new Paint()
      ..color = _backgroundColor
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round
      ..strokeWidth = _strokeWidth
      ..style = PaintingStyle.stroke;

    _paintFore = new Paint()
      ..color = _foreColor
      ..isAntiAlias = true
      ..strokeWidth = _strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var radius = size.width > size.height ? size.width / 2 : size.height / 2;
    Rect rect = Rect.fromCircle(center: Offset(radius, radius), radius: radius);

    canvas.drawCircle(Offset(radius, radius), radius, _paintBckGround);
    canvas.drawArc(rect,
        -3.14/2,
//        _startAngle / 180 * 3.14,
        _sweepAngle / 180 * 3.14,
        false, _paintFore);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return _sweepAngle != _endAngle;
  }
}