import 'package:caloriespro/features/home/bloc/home_bloc.dart';
import 'package:caloriespro/features/home/presentation/widgets/calculate_nutrication.dart';

extension HomeStateNutrition on HomeState {
  double get dailyGoalCalories {
    if (this is HomeLoaded) {
      final data = (this as HomeLoaded).userInfo;
      final result = calculateNutrition(
        age: data.age,
        weightKg: data.weight,
        heightFt: data.height,
        goal: data.yourGoal,
        gender: data.gender,
        activityLevel: data.activityLevel,
      );
      return double.tryParse(result.formattedCalories) ?? 2000;
    }
    return 2000;
  }

  double get dailyGoalProtein {
    if (this is HomeLoaded) {
      final data = (this as HomeLoaded).userInfo;
      final result = calculateNutrition(
        age: data.age,
        weightKg: data.weight,
        heightFt: data.height,
        goal: data.yourGoal,
        gender: data.gender,
        activityLevel: data.activityLevel,
      );
      return double.tryParse(result.formattedProtein) ?? 50;
    }
    return 50;
  }
}
