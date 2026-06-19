import 'package:caloriespro/shared/food/domain/entities/add_food.dart';
import 'package:caloriespro/features/foods/presentation/bloc/add_food_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ─────────────────────────────────────────────
//  Theme constants — teal/green brand palette
// ─────────────────────────────────────────────
abstract class _AppColors {
  static const tealDark = Color(0xFF0D9488);
  static const teal = Color(0xFF14B8A6);
  static const tealSurface = Color(0xFFCCFBF1);
  static const greenDark = Color(0xFF059669);
  static const card = Color(0xFFFFFFFF);
  static const border = Color(0xFFE2E8F0);
  static const inputBg = Color(0xFFF8FAFC);
  static const textPri = Color(0xFF0F172A);
  static const textSec = Color(0xFF64748B);
  static const textHint = Color(0xFF94A3B8);
  static const chipBg = Color(0xFFF1F5F9);
  static const error = Color(0xFFEF4444);
}

// ─────────────────────────────────────────────
//  Public entry point
// ─────────────────────────────────────────────
void showAddFoodSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    useSafeArea: true,
    builder: (_) => BlocProvider.value(
      value: context.read<AddFoodBloc>(),
      child: const _AddFoodSheet(),
    ),
  );
}

// ─────────────────────────────────────────────
//  Sheet widget
// ─────────────────────────────────────────────
class _AddFoodSheet extends StatefulWidget {
  const _AddFoodSheet();

  @override
  State<_AddFoodSheet> createState() => _AddFoodSheetState();
}

class _AddFoodSheetState extends State<_AddFoodSheet>
    with SingleTickerProviderStateMixin {
  // ── state ──────────────────────────────────
  int _selectedMeal = 0;

  final _foodController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _proteinController = TextEditingController();

  final _foodFocus = FocusNode();
  final _caloriesFocus = FocusNode();
  final _proteinFocus = FocusNode();

  // ── data ───────────────────────────────────
  static const _meals = [
    ('🥞', 'Breakfast'),
    ('🌤️', 'Lunch'),
    ('🍽️', 'Dinner'),
    ('🍎', 'Snack'),
  ];

  static const _quickFoods = [
    ('🥚 Boiled Egg', 78, 6.0),
    ('🍌 Banana', 105, 1.3),
    ('🍗 Chicken', 165, 31.0),
    ('🥤 Whey Shake', 120, 24.0),
    ('🥣 Oatmeal', 150, 5.0),
    ('🥑 Avocado', 160, 2.0),
    ('🍳 Egg White', 17, 3.6),
  ];

  // ── animation ──────────────────────────────
  late final AnimationController _chipAnim;
  late final Animation<double> _chipFade;

  @override
  void initState() {
    super.initState();
    _chipAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..forward();
    _chipFade = CurvedAnimation(parent: _chipAnim, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _foodController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _foodFocus.dispose();
    _caloriesFocus.dispose();
    _proteinFocus.dispose();
    _chipAnim.dispose();
    super.dispose();
  }

  // ── helpers ────────────────────────────────
  void _selectQuickFood(String name, double calories, double protein) {
    HapticFeedback.selectionClick();
    setState(() {
      _foodController.text = name;
      _caloriesController.text = calories.toStringAsFixed(0);
      _proteinController.text = protein.toStringAsFixed(1);
    });
  }

  void _submitFood() {
    final foodName = _foodController.text.trim();
    final calories = double.tryParse(_caloriesController.text.trim());
    final protein = double.tryParse(_proteinController.text.trim());

    if (foodName.isEmpty) {
      _showError('Food name is required');
      return;
    }
    if (calories == null || calories <= 0) {
      _showError('Enter valid calories');
      return;
    }
    if (protein == null || protein < 0) {
      _showError('Enter valid protein amount');
      return;
    }

    HapticFeedback.mediumImpact();
    context.read<AddFoodBloc>().add(
      AddFoodRequested(
        AddFood(
          userId: '',
          mealType: _meals[_selectedMeal].$2,
          foodName: foodName,
          calories: calories,
          protein: protein,
          timeStamp: DateTime.now(),
        ),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 10),
            Text(
              message,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: _AppColors.error,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  BUILD
  // ─────────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddFoodBloc, AddFoodState>(
      listener: (context, state) {
        if (state is AddFoodAdded) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Text('🎉', style: TextStyle(fontSize: 16)),
                  SizedBox(width: 8),
                  Text(
                    'Meal logged successfully!',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ],
              ),
              behavior: SnackBarBehavior.floating,
              backgroundColor: _AppColors.tealDark,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              margin: const EdgeInsets.all(16),
              duration: const Duration(seconds: 2),
            ),
          );
        }
        if (state is AddFoodFailure) {
          _showError(state.message);
        }
      },
      builder: (context, state) {
        final isLoading = state is AddFoodLoading;
        return _SheetContainer(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── drag handle ──────────────────
              _DragHandle(),
              const SizedBox(height: 4),

              // ── scrollable body ──────────────
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    left: 24,
                    right: 24,
                    top: 8,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 28,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header
                      _SheetHeader(onClose: () => Navigator.pop(context)),
                      const SizedBox(height: 22),

                      // Meal tabs
                      _SectionLabel(label: 'Meal Type'),
                      const SizedBox(height: 10),
                      _MealTabRow(
                        meals: _meals,
                        selected: _selectedMeal,
                        onSelect: (i) => setState(() => _selectedMeal = i),
                      ),
                      const SizedBox(height: 24),

                      // Quick suggestions
                      _SectionLabel(label: 'Quick Suggestions'),
                      const SizedBox(height: 10),
                      FadeTransition(
                        opacity: _chipFade,
                        child: _QuickFoodRow(
                          foods: _quickFoods,
                          onSelect: _selectQuickFood,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Divider with label
                      _OrDivider(),
                      const SizedBox(height: 20),

                      // Food name field
                      _InputField(
                        controller: _foodController,
                        focusNode: _foodFocus,
                        label: 'Food Name',
                        hint: 'e.g. Grilled Chicken',
                        icon: Icons.restaurant_rounded,
                        capitalization: TextCapitalization.sentences,
                        onSubmit: () => _caloriesFocus.requestFocus(),
                      ),
                      const SizedBox(height: 14),

                      // Calories + Protein row
                      Row(
                        children: [
                          Expanded(
                            child: _InputField(
                              controller: _caloriesController,
                              focusNode: _caloriesFocus,
                              label: 'Calories',
                              hint: '0 kcal',
                              icon: Icons.local_fire_department_rounded,
                              inputType: const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              onSubmit: () => _proteinFocus.requestFocus(),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _InputField(
                              controller: _proteinController,
                              focusNode: _proteinFocus,
                              label: 'Protein',
                              hint: '0.0 g',
                              icon: Icons.fitness_center_rounded,
                              inputType: const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              textInputAction: TextInputAction.done,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),

                      // Submit button
                      _LogButton(isLoading: isLoading, onPressed: _submitFood),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Sub-components
// ─────────────────────────────────────────────────────────────────────────────

/// White rounded sheet with subtle shadow
class _SheetContainer extends StatelessWidget {
  const _SheetContainer({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _AppColors.card,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Pill drag handle
class _DragHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Center(
        child: Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: _AppColors.border,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}

/// "Track Food" title + close button
class _SheetHeader extends StatelessWidget {
  const _SheetHeader({required this.onClose});
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Gradient icon badge
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [_AppColors.teal, _AppColors.greenDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.add_circle_outline_rounded,
            color: Colors.white,
            size: 22,
          ),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Track Food',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: _AppColors.textPri,
                letterSpacing: -0.3,
              ),
            ),
            Text(
              'Log what you just ate',
              style: TextStyle(
                fontSize: 12,
                color: _AppColors.textSec,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const Spacer(),
        // Close button
        GestureDetector(
          onTap: onClose,
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _AppColors.chipBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.close_rounded,
              size: 18,
              color: _AppColors.textSec,
            ),
          ),
        ),
      ],
    );
  }
}

/// Small uppercase section label
class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w800,
        color: _AppColors.textSec,
        letterSpacing: 1.2,
      ),
    );
  }
}

/// Horizontal scrollable meal type chips
class _MealTabRow extends StatelessWidget {
  const _MealTabRow({
    required this.meals,
    required this.selected,
    required this.onSelect,
  });

  final List<(String, String)> meals;
  final int selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: meals.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final isActive = selected == i;
          return GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              onSelect(i);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isActive ? _AppColors.tealSurface : _AppColors.chipBg,
                borderRadius: BorderRadius.circular(21),
                border: Border.all(
                  color: isActive ? _AppColors.teal : Colors.transparent,
                  width: 1.5,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                '${meals[i].$1}  ${meals[i].$2}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive ? _AppColors.tealDark : _AppColors.textSec,
                  letterSpacing: -0.1,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Horizontal scrollable quick-add chips
class _QuickFoodRow extends StatelessWidget {
  const _QuickFoodRow({required this.foods, required this.onSelect});

  final List<(String, int, double)> foods;
  final void Function(String, double, double) onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: foods.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final f = foods[i];
          return _QuickChip(
            label: f.$1,
            onTap: () => onSelect(f.$1, f.$2.toDouble(), f.$3),
          );
        },
      ),
    );
  }
}

class _QuickChip extends StatefulWidget {
  const _QuickChip({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  State<_QuickChip> createState() => _QuickChipState();
}

class _QuickChipState extends State<_QuickChip> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: _pressed ? _AppColors.tealSurface : _AppColors.chipBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _pressed ? _AppColors.teal : _AppColors.border,
            width: 1,
          ),
        ),
        child: Text(
          widget.label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: _pressed ? _AppColors.tealDark : _AppColors.textPri,
          ),
        ),
      ),
    );
  }
}

/// "── or enter manually ──" divider
class _OrDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: _AppColors.border, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'or enter manually',
            style: const TextStyle(
              fontSize: 11,
              color: _AppColors.textHint,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(child: Divider(color: _AppColors.border, thickness: 1)),
      ],
    );
  }
}

/// Reusable styled text field
class _InputField extends StatelessWidget {
  const _InputField({
    required this.controller,
    required this.focusNode,
    required this.label,
    required this.hint,
    required this.icon,
    this.inputType,
    this.capitalization = TextCapitalization.none,
    this.textInputAction = TextInputAction.next,
    this.onSubmit,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType? inputType;
  final TextCapitalization capitalization;
  final TextInputAction textInputAction;
  final VoidCallback? onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: _AppColors.textSec,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 7),
        TextField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: inputType,
          textInputAction: textInputAction,
          textCapitalization: capitalization,
          onSubmitted: onSubmit != null ? (_) => onSubmit!() : null,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: _AppColors.textPri,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: _AppColors.textHint,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: Icon(icon, size: 18, color: _AppColors.textSec),
            filled: true,
            fillColor: _AppColors.inputBg,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 16,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: _AppColors.border,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: _AppColors.teal, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: _AppColors.error, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

/// Gradient "Log Meal" button with loading state
class _LogButton extends StatelessWidget {
  const _LogButton({required this.isLoading, required this.onPressed});
  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: isLoading
              ? null
              : const LinearGradient(
                  colors: [_AppColors.teal, _AppColors.greenDark],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
          color: isLoading ? _AppColors.border : null,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isLoading
              ? null
              : [
                  BoxShadow(
                    color: _AppColors.teal.withOpacity(0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            disabledBackgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: _AppColors.teal,
                    strokeWidth: 2.5,
                  ),
                )
              : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle_outline_rounded,
                      size: 20,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Log Meal',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
