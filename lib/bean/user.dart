import 'package:data_plugin/bmob/table/bmob_user.dart';
import 'package:data_plugin/bmob/type/bmob_file.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends BmobUser {
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  int age;
  int gender;
  String objectId;
  String nickName;
  String autograph;
  BmobFile img;
  int total;

  User();

  @override
  Map getParams() {
    // TODO: implement getParams
    return toJson();
  }

}