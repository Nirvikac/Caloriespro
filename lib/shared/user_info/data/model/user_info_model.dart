import 'package:caloriespro/shared/user_info/domain/entities/user_info.dart';

class UserInfoModel extends UserInfoEntity {
  UserInfoModel({
    required super.userId,
    required super.age,
    required super.weight,
    required super.height,
    required super.gender,
    required super.yourGoal,
    required super.activityLevel,
  });

  factory UserInfoModel.fromEntity(UserInfoEntity entity) {
    return UserInfoModel(
      userId: entity.userId,
      age: entity.age,
      weight: entity.weight,
      height: entity.height,
      gender: entity.gender,
      yourGoal: entity.yourGoal,
      activityLevel: entity.activityLevel,
    );
  }

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    // ✅ Unwrap nested "userInfo" key if present
    final data = json['userInfo'] != null
        ? json['userInfo'] as Map<String, dynamic>
        : json;

    final ageRaw = data['age'];
    final weightRaw = data['weight'];
    final heightRaw = data['height'];

    return UserInfoModel(
      userId: data['userId']?.toString() ?? '', // ✅ null safe
      age: ageRaw is num ? ageRaw.toInt() : int.tryParse('$ageRaw') ?? 0,
      weight: weightRaw is num
          ? weightRaw.toDouble()
          : double.tryParse('$weightRaw') ?? 0.0,
      height: heightRaw is num
          ? heightRaw.toDouble()
          : double.tryParse('$heightRaw') ?? 0.0,
      gender: data['gender']?.toString() ?? '',
      yourGoal: data['yourGoal']?.toString() ?? '',
      activityLevel: data['activityLevel']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // 'userId': userId,
      'age': age,
      'weight': weight,
      'height': height,
      'gender': gender,
      'yourGoal': yourGoal,
      'activityLevel': activityLevel,
    };
  }
}
