part of 'add_food_bloc.dart';

@immutable
sealed class AddFoodState {}

final class AddFoodInitial extends AddFoodState {}

final class AddFoodLoading extends AddFoodState {}

final class AddFoodAdded extends AddFoodState {
  final AddFood food;

  AddFoodAdded(this.food);
}

final class FoodLoaded extends AddFoodState {
  final List<AddFood> foods;

  FoodLoaded(this.foods);
}

final class AddFoodFailure extends AddFoodState {
  final String message;

  AddFoodFailure(this.message);
}
