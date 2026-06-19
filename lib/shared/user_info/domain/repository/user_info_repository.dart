import 'package:caloriespro/shared/user_info/domain/entities/user_info.dart';

abstract class UserInfoRepository {
  Future<void> sendUserInfo(UserInfoEntity userInfo);
  Future<UserInfoEntity?> getUserInfo();
}
