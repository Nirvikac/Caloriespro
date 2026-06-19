import 'package:caloriespro/features/analysis/data/model/last_seven_days_model.dart';
import 'package:caloriespro/features/analysis/domain/entity/food_last_seven_days.dart';
import 'package:caloriespro/core/network/dio_client.dart';

abstract interface class LastSevenRemoteDatasources {
  Future<List<FoodLastSevenDays>> getCaloriesLastSevenDays();
}

class LastSevenRemoteDatasourcesImpl implements LastSevenRemoteDatasources {
  final DioClient dio;
  LastSevenRemoteDatasourcesImpl({required this.dio});
  // last_seven_remote_datasources.dart

  @override
  Future<List<FoodLastSevenDays>> getCaloriesLastSevenDays() async {
    try {
      final response = await dio.dio.get('/food/getLastSevenDays');
      if (response.statusCode == 200) {
        final List<dynamic> data =
            response.data['foods'] as List<dynamic>; // ← was: response.data
        print('Received data for last seven days: $data');
        return data.map((item) => LastSevenDaysModel.fromJson(item)).toList();
      } else {
        throw Exception(
          'Failed to load last seven days data: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching last seven days data: ${e.toString()}');
    }
  }
}
