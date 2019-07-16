part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User()
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
    ..age = json['age'] as int
    ..gender = json['gender'] as int
    ..objectId = json['objectId'] as String
    ..nickName = json['nickName'] as String
    ..autograph = json['autograph'] as String;

}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
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
  'autograph': instance.autograph
};