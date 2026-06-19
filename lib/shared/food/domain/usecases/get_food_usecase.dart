import 'package:caloriespro/shared/food/domain/entities/add_food.dart';
import 'package:caloriespro/shared/food/domain/repository/add_food_repository.dart';
import "package:fpdart/fpdart.dart";

class GetFoodUsecase {
  final AddFoodRepository repository;

  const GetFoodUsecase({required this.repository});

  Future<Either<String, List<AddFood>>> call() {
    return repository.getFoods();
  }
}
