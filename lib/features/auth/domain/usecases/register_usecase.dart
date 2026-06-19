import 'package:caloriespro/features/auth/domain/entities/user.dart';
import 'package:caloriespro/features/auth/domain/repository/auth_repository.dart';

class RegisterUsecase {
  final AuthRepository repository;
  RegisterUsecase(this.repository);
  Future<User> call(String username, String email, String password) async {
    return await repository.register(username, email, password);
  }
}
