import 'package:caloriespro/core/network/dio_client.dart';
import 'package:caloriespro/shared/user_info/data/model/user_info_model.dart';
import 'package:caloriespro/shared/user_info/domain/entities/user_info.dart';

abstract interface class UserInfoRemoteDataSource {
  Future<void> sendUserInfo(UserInfoEntity userInfo);
  Future<UserInfoEntity?> getUserInfo();
}

class UserInfoRemoteDataSourceImpl implements UserInfoRemoteDataSource {
  final DioClient dioClient;
  UserInfoRemoteDataSourceImpl(this.dioClient);
  @override
  Future<void> sendUserInfo(UserInfoEntity userInfo) async {
    try {
      final model = UserInfoModel.fromEntity(userInfo);
      // Backend route names are often lowercase in Express.
      await dioClient.dio.post('/userInfo', data: model.toJson());
    } catch (e) {
      throw Exception(
        'Failed to send user info. If you see 404 "Cannot POST /api/userInfo", '
        'check the backend route path. Details: ${e.toString()}',
      );
    }
  }

  @override
  Future<UserInfoEntity?> getUserInfo() async {
    try {
      final response = await dioClient.dio.get('/userInfo');
      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null) {
          return UserInfoModel.fromJson(data);
        }
      }
      return null;
    } catch (e) {
      throw Exception(
        'Failed to get user info. If you see 404 "Cannot GET /api/userInfo", '
        'check the backend route path. Details: ${e.toString()}',
      );
    }
  }
}
