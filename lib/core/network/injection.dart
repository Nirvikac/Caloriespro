import 'package:caloriespro/core/network/dio_client.dart';
import 'package:caloriespro/core/network/storage.dart';
import 'package:caloriespro/features/analysis/data/datasources/last_seven_remote_datasources.dart';
import 'package:caloriespro/features/analysis/data/repository/last_seven_repository_impl.dart';
import 'package:caloriespro/features/analysis/domain/repository/food_last_seven_repository.dart';
import 'package:caloriespro/features/analysis/domain/usecases/last_calories_usecase.dart';
import 'package:caloriespro/features/analysis/presentation/bloc/last_seven_bloc.dart';
import 'package:caloriespro/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:caloriespro/features/auth/data/repository/auth_repository_impl.dart';
import 'package:caloriespro/features/auth/domain/repository/auth_repository.dart';
import 'package:caloriespro/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:caloriespro/features/auth/domain/usecases/get_user_usecase.dart';
import 'package:caloriespro/features/auth/domain/usecases/login_usecase.dart';
import 'package:caloriespro/features/auth/domain/usecases/logout_usecase.dart';
import 'package:caloriespro/features/auth/domain/usecases/register_usecase.dart';
import 'package:caloriespro/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:caloriespro/shared/food/data/datasources/add_food_remote_datasources.dart';
import 'package:caloriespro/shared/food/data/repository/add_food_repository_impl.dart';
import 'package:caloriespro/shared/food/domain/repository/add_food_repository.dart';
import 'package:caloriespro/shared/food/domain/usecases/add_food_usecase.dart';
import 'package:caloriespro/shared/food/domain/usecases/get_food_usecase.dart';
import 'package:caloriespro/features/foods/presentation/bloc/add_food_bloc.dart';
import 'package:caloriespro/features/home/bloc/home_bloc.dart';
import 'package:caloriespro/shared/user_info/data/datasource/user_info_remote_datasources.dart';
import 'package:caloriespro/shared/user_info/data/repository/user_info_repository_impl.dart';
import 'package:caloriespro/shared/user_info/domain/repository/user_info_repository.dart';
import 'package:caloriespro/shared/user_info/domain/usecase/info_get_usecase.dart';
import 'package:caloriespro/shared/user_info/domain/usecase/info_send_usecase.dart';
import 'package:caloriespro/features/splash/presentation/bloc/user_info_bloc.dart';
import 'package:get_it/get_it.dart';

class Injection {
  static final GetIt getIt = GetIt.instance;

  static void init() {
    // 🔥 CORE SINGLETONS FIRST - Order matters!
    getIt.registerLazySingleton(() => Storage());
    getIt.registerLazySingleton(() => DioClient());

    // 🔥 DATA SOURCE
    getIt.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        getIt<Storage>(), // Storage instance
        getIt<DioClient>(), // DioClient instance
      ),
    );

    // 🔥 REPOSITORY
    getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(getIt<AuthRemoteDataSource>()),
    );

    // 🔥 USE CASES
    getIt.registerLazySingleton(() => LoginUsecase(getIt<AuthRepository>()));
    getIt.registerLazySingleton(() => RegisterUsecase(getIt<AuthRepository>()));
    getIt.registerLazySingleton(
      () => CheckAuthStatusUsecase(getIt<AuthRepository>()),
    );
    getIt.registerLazySingleton(() => LogoutUsecase(getIt<AuthRepository>()));
    getIt.registerLazySingleton(() => GetUserUsecase(getIt<AuthRepository>()));
    // 🔥 BLOC
    getIt.registerFactory(
      () => AuthBloc(
        getIt<RegisterUsecase>(),
        getIt<LoginUsecase>(),
        getIt<CheckAuthStatusUsecase>(),
        getIt<LogoutUsecase>(),
        getIt<GetUserUsecase>(),
      ),
    );

    // ----------------------------
    // Splash / User Info Feature
    // ----------------------------
    getIt.registerLazySingleton<UserInfoRemoteDataSource>(
      () => UserInfoRemoteDataSourceImpl(getIt<DioClient>()),
    );
    getIt.registerLazySingleton<UserInfoRepository>(
      () => UserInfoRepositoryImpl(getIt<UserInfoRemoteDataSource>()),
    );
    getIt.registerLazySingleton(
      () => InfoSendUsecase(getIt<UserInfoRepository>()),
    );
    getIt.registerLazySingleton(
      () => InfoGetUsecase(getIt<UserInfoRepository>()),
    );
    getIt.registerFactory(
      () => UserInfoBloc(getIt<InfoSendUsecase>(), getIt<InfoGetUsecase>()),
    );

    // Home Bloc
    getIt.registerFactory(() => HomeBloc(getIt<InfoGetUsecase>()));

    // -----------------------------
    // Foods Feature - Add Food
    // -----------------------------
    //data source
    getIt.registerLazySingleton<AddFoodRemoteDatasources>(
      () => AddFoodRemoteDatasources(dioClient: getIt<DioClient>()),
    );

    //repository
    getIt.registerLazySingleton<AddFoodRepository>(
      () => AddFoodRepositoryImpl(remote: getIt<AddFoodRemoteDatasources>()),
    );

    //usecase
    getIt.registerLazySingleton(
      () => AddFoodUsecase(repository: getIt<AddFoodRepository>()),
    );
    getIt.registerLazySingleton(
      () => GetFoodUsecase(repository: getIt<AddFoodRepository>()),
    );

    //bloc
    getIt.registerFactory(
      () => AddFoodBloc(
        addFoodUsecase: getIt<AddFoodUsecase>(),
        getFoodUsecase: getIt<GetFoodUsecase>(),
      ),
    );

    // -----------------------------
    // Analysis Feature - Last Seven Days
    // -----------------------------
    //data source
    getIt.registerLazySingleton<LastSevenRemoteDatasources>(
      () => LastSevenRemoteDatasourcesImpl(dio: getIt<DioClient>()),
    );
    //repository
    getIt.registerLazySingleton<FoodLastSevenRepository>(
      () => LastSevenRepositoryImpl(
        remoteDatasources: getIt<LastSevenRemoteDatasources>(),
      ),
    );
    //usecase
    getIt.registerLazySingleton(
      () => LastCaloriesUsecase(repository: getIt<FoodLastSevenRepository>()),
    );
    //bloc
    getIt.registerFactory(
      () => LastSevenBloc(lastCaloriesUsecase: getIt<LastCaloriesUsecase>()),
    );
  }
}
