import '../../domain/entities/add_food.dart';

class AddFoodModel extends AddFood {
  const AddFoodModel({
    required super.userId,
    required super.mealType,
    required super.foodName,
    required super.calories,
    required super.protein,
    required super.timeStamp,
  });

  factory AddFoodModel.fromJson(Map<String, dynamic> json) {
    return AddFoodModel(
      userId: json['userId'] ?? '',
      mealType: json['mealType'] ?? '',
      foodName: json['foodName'] ?? '',
      calories: (json['calories'] ?? 0).toDouble(),
      protein: (json['protein'] ?? 0).toDouble(),
      timeStamp: DateTime.parse(json['timeStamp']),
    );
  }

  factory AddFoodModel.fromEntity(AddFood food) {
    return AddFoodModel(
      userId: food.userId,
      mealType: food.mealType,
      foodName: food.foodName,
      calories: food.calories,
      protein: food.protein,
      timeStamp: food.timeStamp,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'mealType': mealType,
      'foodName': foodName,
      'calories': calories,
      'protein': protein,
      'timeStamp': timeStamp.toIso8601String(),
    };
  }
}
