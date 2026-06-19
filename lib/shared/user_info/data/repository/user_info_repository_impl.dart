import 'package:caloriespro/shared/user_info/data/datasource/user_info_remote_datasources.dart';
import 'package:caloriespro/shared/user_info/domain/entities/user_info.dart';
import 'package:caloriespro/shared/user_info/domain/repository/user_info_repository.dart';

class UserInfoRepositoryImpl implements UserInfoRepository {
  final UserInfoRemoteDataSource remoteDataSource;
  UserInfoRepositoryImpl(this.remoteDataSource);
  @override
  Future<void> sendUserInfo(UserInfoEntity userInfo) async {
    await remoteDataSource.sendUserInfo(userInfo);
  }

  @override
  Future<UserInfoEntity?> getUserInfo() async {
    return await remoteDataSource.getUserInfo();
  }
}
