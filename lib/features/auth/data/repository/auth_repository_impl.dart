import 'package:caloriespro/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:caloriespro/features/auth/domain/entities/user.dart';
import 'package:caloriespro/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  AuthRepositoryImpl(this.authRemoteDataSource);
  @override
  Future<User> login(String email, String password) async {
    final user = await authRemoteDataSource.login(email, password);
    return user;
  }

  @override
  Future<User> register(String username, String email, String password) async {
    final user = await authRemoteDataSource.register(username, email, password);
    return user;
  }

  @override
  Future<void> signOut() async {
    await authRemoteDataSource.signOut();
  }

  @override
  Future<User?> checkAuthStatus() async {
    final user = await authRemoteDataSource.checkAuthStatus();
    return user;
  }

  @override
  Future<User> getUserProfile() async {
    final user = await authRemoteDataSource.getUserProfile();
    return user;
  }
}
