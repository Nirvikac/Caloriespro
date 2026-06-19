part of 'add_food_bloc.dart';

@immutable
sealed class AddFoodEvent {}

final class LoadFoodsRequested extends AddFoodEvent {}

final class AddFoodRequested extends AddFoodEvent {
  final AddFood food;

  AddFoodRequested(this.food);
}
