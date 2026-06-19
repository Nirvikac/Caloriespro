import 'package:caloriespro/shared/user_info/domain/entities/user_info.dart';
import 'package:caloriespro/shared/user_info/domain/repository/user_info_repository.dart';

class InfoSendUsecase {
  final UserInfoRepository userInfoRepository;
  InfoSendUsecase(this.userInfoRepository);
  Future<void> call(UserInfoEntity userInfo) async {
    await userInfoRepository.sendUserInfo(userInfo);
  }
}
