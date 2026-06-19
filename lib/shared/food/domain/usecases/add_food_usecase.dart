import 'package:caloriespro/shared/food/domain/entities/add_food.dart';
import 'package:caloriespro/shared/food/domain/repository/add_food_repository.dart';
import "package:fpdart/fpdart.dart";

class AddFoodUsecase {
  final AddFoodRepository repository;

  const AddFoodUsecase({required this.repository});

  Future<Either<String, void>> call(AddFood food) {
    return repository.addFood(food);
  }
}
