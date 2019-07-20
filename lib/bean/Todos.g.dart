part of 'Todos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************
Todos _$TodosFromJson(Map<String, dynamic> json) {
  return Todos()
    ..title = json['title'] as String
    ..desc = json['desc'] as String
    ..objectId = json['objectId'] as String
    ..date = json['date'] as String
    ..time = json['time'] as String
    ..remindTime = json['remindTime'] as int
    ..remindTimeNoDay = json['remindTimeNoDay'] as int
    ..imgId = json['imgId'] as int
    ..isRepeat = json['isRepeat'] as int
    ..isAlerted = json['isAlerted'] as int
    ..user = json['author'] == null
        ? null
        : BmobUser.fromJson(json['author'] as Map<String, dynamic>);

}

Map<String, dynamic> _$TodoToJson(Todos instance) => <String, dynamic>{
  'user': instance.user,
  'title': instance.title,
  'desc': instance.desc,
  'objectId': instance.objectId,
  'date': instance.date,
  'time': instance.time,
  'remindTime': instance.remindTime,
  'remindTimeNoDay': instance.remindTimeNoDay,
  'isAlerted': instance.isAlerted,
  'isRepeat': instance.isRepeat,
  'imgId': instance.imgId,
};