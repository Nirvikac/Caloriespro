import 'package:caloriespro/core/theme/gradient_button.dart';
import 'package:caloriespro/features/home/presentation/page/home.dart';
import 'package:caloriespro/shared/user_info/domain/entities/user_info.dart';
import 'package:caloriespro/features/splash/presentation/bloc/user_info_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({super.key});

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  String? _gender, _goal, _activity;
  bool _isLoadingDialogShown = false;

  @override
  void dispose() {
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _dismissLoadingDialog() {
    if (_isLoadingDialogShown && Navigator.canPop(context)) {
      Navigator.pop(context);
      _isLoadingDialogShown = false;
    }
  }

  Widget _label(String text) => Text(
    text,
    style: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      color: Colors.grey[700],
      letterSpacing: 1.2,
    ),
  );

  Widget _field(TextEditingController c, String label, IconData icon) =>
      TextField(
        controller: c,
        keyboardType: TextInputType.number,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.teal[600]),
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          filled: true,
          fillColor: Colors.grey[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.grey[200]!, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.grey[200]!, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.teal[600]!, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      );

  Widget _chip(
    String label,
    String emoji,
    String? selected,
    void Function(String) onTap,
  ) {
    final isSelected = selected == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(label),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? Colors.teal[600]! : Colors.grey[200]!,
              width: isSelected ? 2.5 : 1.5,
            ),
            borderRadius: BorderRadius.circular(14),
            color: isSelected ? Colors.teal[50] : Colors.transparent,
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.teal[600]!.withValues(alpha: 0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: Text(
              '$emoji $label',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.teal[700]! : Colors.grey[600]!,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _row(List<Widget> children) => Row(children: children);

  Widget _gap([double h = 16]) => SizedBox(height: h);

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserInfoBloc, UserInfoState>(
      listener: (context, state) {
        if (state is UserInfoLoading && !_isLoadingDialogShown) {
          _isLoadingDialogShown = true;
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(child: CircularProgressIndicator()),
          );
        } else if (state is UserInfoSuccess) {
          _dismissLoadingDialog();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
            (r) => false,
          );
        } else if (state is UserInfoFailure) {
          _dismissLoadingDialog();
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(
              SnackBar(
                content: Text('❌ ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
          title: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Your Profile",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                "Tell us about yourself",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _label("PERSONAL INFO"),
                _gap(),
                _field(_ageController, "Age in years", Icons.person_rounded),
                _gap(12),
                _field(
                  _heightController,
                  "Height in feet",
                  Icons.height_rounded,
                ),
                _gap(12),
                _field(
                  _weightController,
                  "Weight in kg",
                  Icons.sports_gymnastics,
                ),
                _gap(32),

                _label("GENDER"),
                _gap(),
                _row([
                  _chip(
                    'Male',
                    '♂',
                    _gender,
                    (v) => setState(() => _gender = v),
                  ),
                  const SizedBox(width: 16),
                  _chip(
                    'Female',
                    '♀',
                    _gender,
                    (v) => setState(() => _gender = v),
                  ),
                ]),
                _gap(32),

                _label("YOUR GOAL"),
                _gap(),
                _row([
                  _chip(
                    'Lose Weight',
                    '🔥',
                    _goal,
                    (v) => setState(() => _goal = v),
                  ),
                  const SizedBox(width: 16),
                  _chip(
                    'Maintain Weight',
                    '⚖️',
                    _goal,
                    (v) => setState(() => _goal = v),
                  ),
                ]),
                _gap(16),
                _row([
                  _chip(
                    'Gain Muscle',
                    '💪',
                    _goal,
                    (v) => setState(() => _goal = v),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(child: SizedBox()),
                ]),
                _gap(32),

                _label("ACTIVITY LEVEL"),
                _gap(),
                _row([
                  _chip(
                    'Sedentary',
                    '🛋️',
                    _activity,
                    (v) => setState(() => _activity = v),
                  ),
                  const SizedBox(width: 16),
                  _chip(
                    'Lightly Active',
                    '🚶',
                    _activity,
                    (v) => setState(() => _activity = v),
                  ),
                ]),
                _gap(16),
                _row([
                  _chip(
                    'Active',
                    '🏃',
                    _activity,
                    (v) => setState(() => _activity = v),
                  ),
                  const SizedBox(width: 16),
                  _chip(
                    'Very Active',
                    '🏋️',
                    _activity,
                    (v) => setState(() => _activity = v),
                  ),
                ]),
                _gap(40),

                GradientButton(
                  text: "Continue",
                  onPressed: () {
                    if (_ageController.text.trim().isEmpty ||
                        _heightController.text.trim().isEmpty ||
                        _weightController.text.trim().isEmpty ||
                        _gender == null ||
                        _goal == null ||
                        _activity == null) {
                      ScaffoldMessenger.of(context)
                        ..clearSnackBars()
                        ..showSnackBar(
                          const SnackBar(
                            content: Text('Please fill in all fields'),
                          ),
                        );
                      return;
                    }
                    context.read<UserInfoBloc>().add(
                      SendUserInfo(
                        userInfo: UserInfoEntity(
                          userId: '',
                          age: int.tryParse(_ageController.text.trim()) ?? 0,
                          height:
                              double.tryParse(_heightController.text.trim()) ??
                              0,
                          weight:
                              double.tryParse(_weightController.text.trim()) ??
                              0,
                          gender: _gender!,
                          yourGoal: _goal!,
                          activityLevel: _activity!,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
