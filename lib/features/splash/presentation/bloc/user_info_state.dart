part of 'user_info_bloc.dart';

@immutable
sealed class UserInfoState {}

class UserInfoInitial extends UserInfoState {}

class UserInfoLoading extends UserInfoState {}

class UserInfoSuccess extends UserInfoState {
  final UserInfoEntity userInfo;
  final bool isExistingUser;

  UserInfoSuccess(this.userInfo, {this.isExistingUser = false});
}

class UserInfoFailure extends UserInfoState {
  final String message;
  UserInfoFailure(this.message);
}
