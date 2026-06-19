import 'package:caloriespro/shared/food/data/datasources/add_food_remote_datasources.dart';
import 'package:caloriespro/shared/food/domain/entities/add_food.dart';
import 'package:caloriespro/shared/food/domain/repository/add_food_repository.dart';
import "package:fpdart/fpdart.dart";

class AddFoodRepositoryImpl implements AddFoodRepository {
  final AddFoodRemoteDatasources remote;

  const AddFoodRepositoryImpl({required this.remote});

  @override
  Future<Either<String, void>> addFood(AddFood food) {
    return remote.addFood(food);
  }

  @override
  Future<Either<String, List<AddFood>>> getFoods() {
    return remote.getFoods();
  }
}
