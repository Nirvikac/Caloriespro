import 'package:caloriespro/core/network/dio_client.dart';
import 'package:caloriespro/shared/food/data/model/add_food_model.dart';
import 'package:caloriespro/shared/food/domain/entities/add_food.dart';
import 'package:fpdart/fpdart.dart';

class AddFoodRemoteDatasources {
  final DioClient dioClient;

  const AddFoodRemoteDatasources({required this.dioClient});

  Future<Either<String, void>> addFood(AddFood food) async {
    try {
      final model = AddFoodModel.fromEntity(food);

      await dioClient.dio.post('/food/addFood', data: model.toJson());

      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, List<AddFood>>> getFoods() async {
    try {
      final response = await dioClient.dio.get('/food/getFood');

      final Map<String, dynamic> data = response.data;
      final List<dynamic> foodList = data['foods'] ?? [];

      final allFoods = foodList.map((e) => AddFoodModel.fromJson(e)).toList();

      // 👉 Get today's start and end time
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

      // 👉 Filter only today's data
      final todayFoods = allFoods.where((food) {
        final time = food.timeStamp; // make sure this is DateTime
        return time.isAfter(startOfDay) && time.isBefore(endOfDay);
      }).toList();

      return Right(todayFoods);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
