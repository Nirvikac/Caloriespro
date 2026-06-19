class NutritionResult {
  final double dailyCalories;
  final double dailyProtein;

  const NutritionResult({
    required this.dailyCalories,
    required this.dailyProtein,
  });

  // Helper to format to 1 decimal if needed
  String get formattedCalories => _formatNumber(dailyCalories);
  String get formattedProtein => _formatNumber(dailyProtein);

  static String _formatNumber(double value) {
    if (value == value.toInt()) {
      return value.toInt().toString(); // No decimal if whole number
    }
    return value.toStringAsFixed(1); // 1 decimal otherwise
  }
}

NutritionResult calculateNutrition({
  required int age,
  required double weightKg,
  required double heightFt,
  required String gender,
  required String goal,
  required String activityLevel,
}) {
  // Convert height from feet to cm
  final heightCm = heightFt * 30.48;

  // Mifflin-St Jeor BMR
  double bmr = (10 * weightKg) + (6.25 * heightCm) - (5 * age);
  bmr += gender == 'Male' ? 5 : -161;

  // TDEE with activity multiplier
  final double activityMultiplier = switch (activityLevel) {
    'Sedentary' => 1.2,
    'Lightly Active' => 1.375,
    'Active' => 1.55,
    'Very Active' => 1.725,
    _ => 1.375, // Default to Lightly Active
  };

  final tdee = bmr * activityMultiplier;

  // Calories by goal
  final double calories = switch (goal) {
    'Lose Weight' => tdee - 500,
    'Gain Muscle' => tdee + 300,
    _ => tdee, // Maintain Weight
  };

  // Protein by goal (g per kg bodyweight)
  final double proteinMultiplier = switch (goal) {
    'Lose Weight' => 2.2,
    'Gain Muscle' => 2.5,
    _ => 1.8,
  };
  final protein = weightKg * proteinMultiplier;

  return NutritionResult(
    dailyCalories: calories.clamp(1200, 4000),
    dailyProtein: protein,
  );
}
