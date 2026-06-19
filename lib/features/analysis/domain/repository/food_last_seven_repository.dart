import 'package:caloriespro/features/analysis/domain/entity/food_last_seven_days.dart';

abstract interface class FoodLastSevenRepository {
  Future<List<FoodLastSevenDays>> getCaloriesLastSevenDays();
}
