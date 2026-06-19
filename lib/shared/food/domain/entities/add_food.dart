class AddFood {
  final String userId;
  final String mealType;
  final String foodName;
  final double calories;
  final double protein;
  final DateTime timeStamp;

  const AddFood({
    required this.userId,
    required this.mealType,
    required this.foodName,
    required this.calories,
    required this.protein,
    required this.timeStamp,
  });
}
