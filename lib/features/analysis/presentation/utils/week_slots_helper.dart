// lib/features/analysis/presentation/utils/week_slots_helper.dart

import 'package:caloriespro/features/analysis/domain/entity/food_last_seven_days.dart';

List<double?> toWeekSlots(List<FoodLastSevenDays> days) {
  final slots = List<double?>.filled(7, null);
  for (final d in days) {
    final date = DateTime.tryParse(d.date);
    if (date == null) continue;
    final idx = (date.weekday - 1) % 7; // Mon=0 … Sun=6
    slots[idx] = (slots[idx] ?? 0) + d.calories;
  }
  return slots;
}
