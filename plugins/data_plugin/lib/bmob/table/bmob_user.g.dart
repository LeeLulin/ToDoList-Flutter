// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bmob_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BmobUser _$BmobUserFromJson(Map<String, dynamic> json) {
  return BmobUser()
    ..img = json['img'] == null
        ? null
        : BmobFile.fromJson(json['img'] as Map<String, dynamic>)
    ..createdAt = json['createdAt'] as String
    ..updatedAt = json['updatedAt'] as String
    ..objectId = json['objectId'] as String
    ..ACL = json['ACL'] as Map<String, dynamic>
    ..username = json['username'] as String
    ..password = json['password'] as String
    ..email = json['email'] as String
    ..emailVerified = json['emailVerified'] as bool
    ..mobilePhoneNumber = json['mobilePhoneNumber'] as String
    ..mobilePhoneNumberVerified = json['mobilePhoneNumberVerified'] as bool
    ..sessionToken = json['sessionToken'] as String
    ..objectId = json['objectId'] as String
    ..nickName = json['nickName'] as String
    ..autograph = json['autograph'] as String
    ..total = json['total'] as int;
}

Map<String, dynamic> _$BmobUserToJson(BmobUser instance) => <String, dynamic>{
      'img': instance.img,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'objectId': instance.objectId,
      'ACL': instance.ACL,
      'username': instance.username,
      'password': instance.password,
      'email': instance.email,
      'emailVerified': instance.emailVerified,
      'mobilePhoneNumber': instance.mobilePhoneNumber,
      'mobilePhoneNumberVerified': instance.mobilePhoneNumberVerified,
      'sessionToken': instance.sessionToken,
      'age': instance.age,
      'gender': instance.gender,
      'objectId': instance.objectId,
      'nickName': instance.nickName,
      'autograph': instance.autograph,
      'total': instance.total
    };
