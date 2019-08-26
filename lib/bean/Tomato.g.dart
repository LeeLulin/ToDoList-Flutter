part of 'Tomato.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************
Tomato _$TomatoFromJson(Map<String, dynamic> json) {
  return Tomato()
    ..title = json['title'] as String
    ..objectId = json['objectId'] as String
    ..workLength = json['workLength'] as int
    ..shortBreak = json['shortBreak'] as int
    ..longBreak = json['longBreak'] as int
    ..frequency = json['frequency'] as int
    ..imgId = json['imgId'] as int
    ..user = json['author'] == null
        ? null
        : BmobUser.fromJson(json['author'] as Map<String, dynamic>);

}

Map<String, dynamic> _$TodoToJson(Tomato instance) => <String, dynamic>{
  'user': instance.user,
  'title': instance.title,
  'objectId': instance.objectId,
  'imgId': instance.imgId,
  'workLength': instance.workLength,
  'shortBreak': instance.shortBreak,
  'longBreak': instance.longBreak,
  'frequency': instance.frequency,

};