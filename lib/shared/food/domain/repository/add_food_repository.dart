import 'package:fpdart/fpdart.dart';
import '../entities/add_food.dart';

abstract interface class AddFoodRepository {
  Future<Either<String, void>> addFood(AddFood food);

  Future<Either<String, List<AddFood>>> getFoods();
}
