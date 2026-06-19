import 'package:caloriespro/shared/user_info/domain/entities/user_info.dart';
import 'package:caloriespro/shared/user_info/domain/repository/user_info_repository.dart';

class InfoGetUsecase {
  final UserInfoRepository repository;

  InfoGetUsecase(this.repository);

  Future<UserInfoEntity?> call() async {
    return await repository.getUserInfo();
  }
}
