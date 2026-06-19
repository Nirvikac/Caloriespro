part of 'user_info_bloc.dart';

@immutable
sealed class UserInfoEvent {}

class SendUserInfo extends UserInfoEvent {
  final UserInfoEntity userInfo;

  SendUserInfo({required this.userInfo});
}

class GetUserInfo extends UserInfoEvent {}
