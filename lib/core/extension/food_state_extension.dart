import 'package:caloriespro/features/foods/presentation/bloc/add_food_bloc.dart';

extension FoodStateNutrition on AddFoodState {
  double get todaysCalories {
    if (this is FoodLoaded) {
      return (this as FoodLoaded).foods.fold(0, (sum, f) => sum + f.calories);
    }
    return 0;
  }

  double get todaysProtein {
    if (this is FoodLoaded) {
      return (this as FoodLoaded).foods.fold(0, (sum, f) => sum + f.protein);
    }
    return 0;
  }
}
