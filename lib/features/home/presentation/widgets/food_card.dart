import 'package:caloriespro/features/foods/presentation/bloc/add_food_bloc.dart';
import 'package:caloriespro/shared/food/domain/entities/add_food.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FoodCard extends StatefulWidget {
  const FoodCard({super.key});

  @override
  State<FoodCard> createState() => _FoodCardState();
}

class _FoodCardState extends State<FoodCard> {
  @override
  void initState() {
    super.initState();
    context.read<AddFoodBloc>().add(LoadFoodsRequested());
  }

  static const _mealMeta = {
    'Breakfast': (
      Icons.wb_sunny_outlined,
      Color(0xFF1D9E75), // teal accent
      Color(0xFFE1F5EE), // teal light bg
    ),
    'Lunch': (
      Icons.light_mode_outlined,
      Color(0xFF378ADD), // blue accent
      Color(0xFFE6F1FB), // blue light bg
    ),
    'Dinner': (
      Icons.nights_stay_outlined,
      Color(0xFF7F77DD), // purple accent
      Color(0xFFEEEDFE), // purple light bg
    ),
    'Snack': (
      Icons.eco_outlined,
      Color(0xFFBA7517), // amber accent
      Color(0xFFFAEEDA), // amber light bg
    ),
  };

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddFoodBloc, AddFoodState>(
      listener: (context, state) {
        if (state is AddFoodAdded) {
          context.read<AddFoodBloc>().add(LoadFoodsRequested());
        }
      },
      child: BlocBuilder<AddFoodBloc, AddFoodState>(
        builder: (context, state) {
          if (state is AddFoodLoading) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: CircularProgressIndicator(color: Color(0xFF1D9E75)),
              ),
            );
          }
          if (state is FoodLoaded) {
            return _FoodLogBody(foods: state.foods, mealMeta: _mealMeta);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

// ── Body ──────────────────────────────────────────────────────────────────────

class _FoodLogBody extends StatelessWidget {
  const _FoodLogBody({required this.foods, required this.mealMeta});

  final List<AddFood> foods;
  final Map<String, (IconData, Color, Color)> mealMeta;

  @override
  Widget build(BuildContext context) {
    final grouped = <String, List<AddFood>>{};
    for (final f in foods) {
      grouped.putIfAbsent(f.mealType, () => []).add(f);
    }

    // Total macros
    final totalCal = foods.fold(0.0, (s, f) => s + f.calories);
    final totalProt = foods.fold(0.0, (s, f) => s + f.protein);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),

        // ── Header ──────────────────────────────
        Row(
          children: [
            Text(
              'Food log',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const Spacer(),
            if (foods.isNotEmpty) _Pill(label: '${foods.length} items'),
          ],
        ),
        const SizedBox(height: 14),

        // ── Inline macro strip ───────────────────
        if (foods.isNotEmpty)
          _MacroStrip(totalCal: totalCal, totalProt: totalProt),

        const SizedBox(height: 18),

        // ── Empty state ─────────────────────────
        if (foods.isEmpty) const _EmptyState(),

        // ── Grouped meal sections ───────────────
        ...grouped.entries.map((entry) {
          final meta =
              mealMeta[entry.key] ??
              (
                Icons.restaurant_outlined,
                const Color(0xFF888780),
                const Color(0xFFF1EFE8),
              );
          return _MealSection(
            mealType: entry.key,
            foods: entry.value,
            icon: meta.$1,
            accentColor: meta.$2,
            bgColor: meta.$3,
          );
        }),
      ],
    );
  }
}

// ── Macro strip ───────────────────────────────────────────────────────────────

class _MacroStrip extends StatelessWidget {
  const _MacroStrip({required this.totalCal, required this.totalProt});
  final double totalCal;
  final double totalProt;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _MacroChip(
            icon: Icons.local_fire_department_outlined,
            label: 'Total calories',
            value: '${totalCal.toStringAsFixed(0)} kcal',
            accentColor: const Color(0xFF1D9E75),
            bgColor: const Color(0xFFE1F5EE),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _MacroChip(
            icon: Icons.fitness_center_outlined,
            label: 'Total protein',
            value: '${totalProt.toStringAsFixed(1)} g',
            accentColor: const Color(0xFF378ADD),
            bgColor: const Color(0xFFE6F1FB),
          ),
        ),
      ],
    );
  }
}

class _MacroChip extends StatelessWidget {
  const _MacroChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.accentColor,
    required this.bgColor,
  });

  final IconData icon;
  final String label, value;
  final Color accentColor, bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: accentColor, size: 18),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: accentColor.withValues(alpha: 0.75),
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: accentColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Meal section ──────────────────────────────────────────────────────────────

class _MealSection extends StatelessWidget {
  const _MealSection({
    required this.mealType,
    required this.foods,
    required this.icon,
    required this.accentColor,
    required this.bgColor,
  });

  final String mealType;
  final List<AddFood> foods;
  final IconData icon;
  final Color accentColor;
  final Color bgColor;

  double get _totalCal => foods.fold(0.0, (s, f) => s + f.calories);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section label row
        Row(
          children: [
            Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: accentColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              mealType.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: accentColor,
                letterSpacing: 0.8,
              ),
            ),
            const Spacer(),
            Text(
              '${_totalCal.toStringAsFixed(0)} kcal',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: accentColor.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...foods.map(
          (f) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: _FoodItem(
              food: f,
              icon: icon,
              iconBg: bgColor,
              accentColor: accentColor,
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

// ── Food item row ─────────────────────────────────────────────────────────────
class _FoodItem extends StatelessWidget {
  const _FoodItem({
    required this.food,
    required this.icon,
    required this.iconBg,
    required this.accentColor,
  });

  final AddFood food;
  final IconData icon;
  final Color iconBg;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: iconBg, // per-meal tinted background
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.15),
          width: 0.8,
        ),
      ),
      child: Row(
        children: [
          // Icon badge
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: accentColor, size: 18),
          ),
          const SizedBox(width: 12),

          // Name + meal tag
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  food.foodName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  food.mealType,
                  style: TextStyle(
                    fontSize: 11,
                    color: accentColor.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),

          // Calories + protein
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${food.calories.toStringAsFixed(0)} kcal',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: accentColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${food.protein.toStringAsFixed(1)} g protein',
                style: TextStyle(
                  fontSize: 11,
                  color: accentColor.withValues(alpha: 0.55),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
// ── Small components ──────────────────────────────────────────────────────────

class _Pill extends StatelessWidget {
  const _Pill({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFE1F5EE),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Color(0xFF0F6E56),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200, width: 0.8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            // height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFE1F5EE),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.restaurant_outlined,
              size: 24,
              color: Color(0xFF1D9E75),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'No foods logged yet',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            'Tap + to add your first meal',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }
}
