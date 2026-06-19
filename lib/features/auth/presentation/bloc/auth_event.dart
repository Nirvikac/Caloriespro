part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent(this.email, this.password);
}

final class RegisterEvent extends AuthEvent {
  final String username;
  final String email;
  final String password;

  RegisterEvent(this.username, this.email, this.password);
}

final class SignOutEvent extends AuthEvent {}

final class CheckAuthStatusEvent extends AuthEvent {}

final class GetUserProfileEvent extends AuthEvent {}
