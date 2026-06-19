import 'package:caloriespro/features/analysis/domain/entity/food_last_seven_days.dart';
import 'package:caloriespro/features/analysis/domain/repository/food_last_seven_repository.dart';

class LastCaloriesUsecase {
  final FoodLastSevenRepository repository;
  LastCaloriesUsecase({required this.repository});
  Future<List<FoodLastSevenDays>> call() async {
    return repository.getCaloriesLastSevenDays();
  }
}
