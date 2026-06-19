import 'package:caloriespro/features/auth/domain/entities/user.dart';
import 'package:caloriespro/features/auth/domain/repository/auth_repository.dart';

class CheckAuthStatusUsecase {
  final AuthRepository authRepository;
  CheckAuthStatusUsecase(this.authRepository);

  Future<User?> call() async {
    return await authRepository.checkAuthStatus();
  }
}
