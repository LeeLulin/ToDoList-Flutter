import 'package:Doit/bean/user.dart';
import 'package:data_plugin/bmob/table/bmob_object.dart';
import 'package:data_plugin/bmob/table/bmob_user.dart';
import 'package:data_plugin/bmob/type/bmob_date.dart';
import 'package:data_plugin/bmob/type/bmob_file.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Tomato.g.dart';

@JsonSerializable()
class Tomato extends BmobObject {
  factory Tomato.fromJson(Map<String, dynamic> json) => _$TomatoFromJson(json);

  Tomato.fromSql(Map<String, dynamic> json) {

    title = json['title'];
    workLength = json['workLength'];
    shortBreak = json['shotrBreak'];
    longBreak  = json['longBreak'];
    frequency = json['frequency'];
    imgId = json['imgId'];

  }

  Map<String, dynamic> toJson() => _$TodoToJson(this);

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['title'] = title;
    map['objectId'] = objectId;
    map['workLength'] = workLength;
    map['shortBreak'] = shortBreak;
    map['longBreak'] = longBreak;
    map['frequency'] = frequency;
    map['imgId'] = imgId;
    return map;
  }

  static Tomato fromMap(Map<String, dynamic> map) {
    Tomato tomatos = new Tomato();
    tomatos.title = map['title'];
    tomatos.objectId = map['objectId'];
    tomatos.workLength = map['workLength'];
    tomatos.shortBreak = map['shortBreak'];
    tomatos.longBreak = map['longBreak'];
    tomatos.frequency = map['frequency'];
    tomatos.imgId = map['imgId'];

    return tomatos;
  }


  String title;
  int imgId;
  BmobDate bmobDate;
  BmobUser user;
  String dbObjectId;
  int workLength;
  int shortBreak;
  int longBreak;
  int frequency;

  Tomato();

  @override
  Map getParams() {
    // TODO: implement getParams
    return toJson();
  }

}