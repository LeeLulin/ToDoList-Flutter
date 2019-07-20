import 'package:Doit/bean/user.dart';
import 'package:data_plugin/bmob/table/bmob_object.dart';
import 'package:data_plugin/bmob/table/bmob_user.dart';
import 'package:data_plugin/bmob/type/bmob_date.dart';
import 'package:data_plugin/bmob/type/bmob_file.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Todos.g.dart';

@JsonSerializable()
class Todos extends BmobObject {
  factory Todos.fromJson(Map<String, dynamic> json) => _$TodosFromJson(json);

  Todos.fromSql(Map<String, dynamic> json) {

    id = json['id'];
    title = json['title'];
    desc = json['udescrl'];
    date = json['date'];
    time = json['time'];
    objectId = json['objectId'];
    remindTime = json['remindTime'];
    remindTimeNoDay = json['remindTimeNoDay'];
    imgId = json['imgId'];
    isRepeat = json['isRepeat'];
    isAlerted = json['isAlerted'];
  }

  Map<String, dynamic> toJson() => _$TodoToJson(this);

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['id'] = id;
    map['title'] = title;
    map['desc'] = desc;
    map['date'] = date;
    map['time'] = time;
    map['objectId'] = objectId;
    map['remindTime'] = remindTime;
    map['remindTimeNoDay'] = remindTimeNoDay;
    map['imgId'] = imgId;
    map['isRepeat'] = isRepeat;
    map['isAlerted'] = isAlerted;
    return map;
  }

  static Todos fromMap(Map<String, dynamic> map) {
    Todos todos = new Todos();
    todos.id = map['id'];
    todos.title = map['title'];
    todos.desc = map['desc'];
    todos.date = map['date'];
    todos.time = map['time'];
    todos.objectId = map['objectId'];
    todos.remindTime = map['remindTime'];
    todos.remindTimeNoDay = map['remindTimeNoDay'];
    todos.imgId = map['imgId'];
    todos.isRepeat = map['isRepeat'];
    todos.isAlerted = map['isAlerted'];
    return todos;
  }


  String title;
  String desc;
  String date;
  String time;
  int remindTime,remindTimeNoDay;
  int id,isAlerted,isRepeat,imgId;
  BmobDate bmobDate;
  BmobUser user;
  String dbObjectId;

  Todos();

  @override
  Map getParams() {
    // TODO: implement getParams
    return toJson();
  }

}