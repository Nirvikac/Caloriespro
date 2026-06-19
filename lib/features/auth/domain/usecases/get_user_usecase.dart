import 'package:caloriespro/features/auth/domain/entities/user.dart';
import 'package:caloriespro/features/auth/domain/repository/auth_repository.dart';

class GetUserUsecase {
  final AuthRepository authRepository;

  GetUserUsecase(this.authRepository);

  Future<User> call() async {
    return await authRepository.getUserProfile();
  }
}
