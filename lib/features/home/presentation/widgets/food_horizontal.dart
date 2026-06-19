import 'package:caloriespro/core/theme/gradient_button.dart';
import 'package:caloriespro/features/foods/presentation/pages/add_food.dart';
import 'package:flutter/material.dart';

class FoodHorizontal extends StatefulWidget {
  const FoodHorizontal({super.key});

  @override
  State<FoodHorizontal> createState() => _FoodHorizontalState();
}

class _FoodHorizontalState extends State<FoodHorizontal> {
  @override
  Widget build(BuildContext context) {
    return GradientButton(
      onPressed: () {
        showAddFoodSheet(context);
      },
      text: 'Add Food',
    );
  }
}
