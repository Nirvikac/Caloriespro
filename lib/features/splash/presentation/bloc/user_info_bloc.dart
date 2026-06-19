import 'package:bloc/bloc.dart';
import 'package:caloriespro/shared/user_info/domain/entities/user_info.dart';
import 'package:caloriespro/shared/user_info/domain/usecase/info_get_usecase.dart';
import 'package:caloriespro/shared/user_info/domain/usecase/info_send_usecase.dart';
import 'package:flutter/foundation.dart';

part 'user_info_event.dart';
part 'user_info_state.dart';

class UserInfoBloc extends Bloc<UserInfoEvent, UserInfoState> {
  final InfoSendUsecase userInfoUsecase;
  final InfoGetUsecase infoGetUsecase;
  UserInfoBloc(this.userInfoUsecase, this.infoGetUsecase)
    : super(UserInfoInitial()) {
    on<SendUserInfo>((event, emit) async {
      emit(UserInfoLoading());
      try {
        await userInfoUsecase(event.userInfo);

        emit(UserInfoSuccess(event.userInfo, isExistingUser: false));
      } catch (e) {
        emit(UserInfoFailure(e.toString()));
      }
    });
    on<GetUserInfo>((event, emit) async {
      emit(UserInfoLoading());
      try {
        final userInfo = await infoGetUsecase();
        debugPrint('📦 GetUserInfo result: $userInfo');
        debugPrint('📦 userId: ${userInfo?.userId}');

        if (userInfo != null && userInfo.userId != null) {
          emit(UserInfoSuccess(userInfo, isExistingUser: true));
        } else {
          emit(UserInfoInitial());
        }
      } catch (e) {
        debugPrint('❌ GetUserInfo error: $e');
        emit(UserInfoFailure(e.toString()));
      }
    });
  }
}
