import 'package:bloc/bloc.dart';
import 'package:caloriespro/features/auth/domain/entities/user.dart';
import 'package:caloriespro/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:caloriespro/features/auth/domain/usecases/get_user_usecase.dart';
import 'package:caloriespro/features/auth/domain/usecases/login_usecase.dart';
import 'package:caloriespro/features/auth/domain/usecases/logout_usecase.dart';
import 'package:caloriespro/features/auth/domain/usecases/register_usecase.dart';
import 'package:flutter/foundation.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterUsecase registerUsecase;
  final LoginUsecase loginUsecase;
  final CheckAuthStatusUsecase checkAuthStatusUsecase;
  final LogoutUsecase logoutUsecase;
  final GetUserUsecase? user;

  AuthBloc(
    this.registerUsecase,
    this.loginUsecase,
    this.checkAuthStatusUsecase,
    this.logoutUsecase,
    this.user,
  ) : super(AuthInitial()) {
    on<CheckAuthStatusEvent>((event, emit) async {
      try {
        debugPrint('🔍 Checking authentication status...');
        final user = await checkAuthStatusUsecase();
        if (user != null) {
          debugPrint('✅ User authenticated: ${user.email}');
          emit(AuthAuthenticated(user));
        } else {
          debugPrint('❌ No authenticated user found');
          emit(AuthUnauthenticated());
        }
      } catch (e) {
        debugPrint('❌ Error checking auth status: $e');
        emit(AuthUnauthenticated());
      }
    });

    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await loginUsecase(event.email, event.password);
        emit(AuthAuthenticated(user));
      } catch (e) {
        final errorMessage = _getErrorMessage(e);
        debugPrint('Login error: $errorMessage');
        emit(AuthError(errorMessage));
      }
    });
    on<RegisterEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await registerUsecase(
          event.username,
          event.email,
          event.password,
        );
        emit(AuthAuthenticated(user));
      } catch (e) {
        final errorMessage = _getErrorMessage(e);
        debugPrint('Register error: $errorMessage');
        emit(AuthError(errorMessage));
      }
    });
    on<SignOutEvent>((event, emit) async {
      try {
        await logoutUsecase();
        emit(AuthUnauthenticated());
      } catch (e) {
        emit(AuthError('Sign out failed: ${e.toString()}'));
      }
    });
    on<GetUserProfileEvent>((event, emit) async {
      try {
        emit(AuthLoading());
        final userProfile = await user?.call();
        if (userProfile != null) {
          emit(AuthAuthenticated(userProfile));
        } else {
          emit(AuthUnauthenticated());
        }
      } catch (e) {
        final errorMessage = _getErrorMessage(e);
        debugPrint('Get user profile error: $errorMessage');
        emit(AuthError(errorMessage));
      }
    });
  }

  String _getErrorMessage(dynamic error) {
    if (error is Exception) {
      String message = error.toString();
      // Clean up exception message format
      if (message.contains('Exception: ')) {
        message = message.replaceFirst('Exception: ', '');
      }
      return message.isNotEmpty ? message : 'An error occurred';
    }
    return error?.toString() ?? 'Unknown error';
  }
}
