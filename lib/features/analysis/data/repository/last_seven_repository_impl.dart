import 'package:caloriespro/features/analysis/data/datasources/last_seven_remote_datasources.dart';
import 'package:caloriespro/features/analysis/domain/entity/food_last_seven_days.dart';
import 'package:caloriespro/features/analysis/domain/repository/food_last_seven_repository.dart';

class LastSevenRepositoryImpl implements FoodLastSevenRepository {
  final LastSevenRemoteDatasources remoteDatasources;
  LastSevenRepositoryImpl({required this.remoteDatasources});

  @override
  Future<List<FoodLastSevenDays>> getCaloriesLastSevenDays() async {
    return remoteDatasources.getCaloriesLastSevenDays();
  }
}
