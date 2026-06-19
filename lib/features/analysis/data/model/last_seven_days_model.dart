import 'package:caloriespro/features/analysis/domain/entity/food_last_seven_days.dart';

class LastSevenDaysModel extends FoodLastSevenDays {
  LastSevenDaysModel({required super.date, required super.calories});

  // last_seven_days_model.dart

  factory LastSevenDaysModel.fromJson(Map<String, dynamic> json) {
    return LastSevenDaysModel(
      date: json['timeStamp'] as String,
      calories: (json['calories'] as num)
          .toDouble(), // ← was: json['calories'].toDouble()
    );
  }
  Map<String, dynamic> toJson() {
    return {'timeStamp': date, 'calories': calories};
  }
}
