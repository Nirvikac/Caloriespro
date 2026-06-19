import 'package:caloriespro/core/extension/home_state_extension.dart';
import 'package:caloriespro/core/theme/gradient_button.dart';
import 'package:caloriespro/core/theme/theme_cubit.dart';
import 'package:caloriespro/features/foods/presentation/bloc/add_food_bloc.dart';
import 'package:caloriespro/features/home/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caloriespro/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:caloriespro/features/auth/presentation/page/sign_in_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notifications = true;
  bool _dailyReminder = false;

  // ── theme helpers ─────────────────────────────

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;

  Color get _scaffoldBg => Theme.of(context).scaffoldBackgroundColor;

  Color get _cardBg => _isDark ? const Color(0xFF1E1E1E) : Colors.white;

  Color get _textPrimary => _isDark ? Colors.white : const Color(0xFF1A1A1A);

  Color get _textSecondary =>
      _isDark ? Colors.white70 : const Color(0xFF9AAA9A);

  Color get _dividerColor =>
      _isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF0F0F0);

  Color get _sectionLabelColor =>
      _isDark ? const Color(0xFF6B8F71) : const Color(0xFF9AAA9A);

  Color get _inactiveTrack =>
      _isDark ? const Color(0xFF3A3A3A) : const Color(0xFFDDDDEE);

  Color get _chevronColor =>
      _isDark ? const Color(0xFF555555) : const Color(0xFFCCCCCC);

  // ── build ─────────────────────────────────────

  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(GetUserProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _scaffoldBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              _buildPageHeader(),
              const SizedBox(height: 16),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthAuthenticated) {
                    return _buildProfileCard(
                      name: state.user.username,
                      initials: state.user.username.isNotEmpty
                          ? state.user.username[0].toUpperCase()
                          : 'U',
                      email: state.user.email,
                    );
                  }
                  return _buildProfileCard(
                    name: 'User',
                    initials: 'U',
                    email: 'user@example.com',
                  );
                },
              ),
              const SizedBox(height: 16),
              BlocBuilder<HomeBloc, HomeState>(
                builder: (context, homeState) {
                  return BlocBuilder<AddFoodBloc, AddFoodState>(
                    builder: (context, foodState) {
                      return _buildStatsRow(
                        kcalGoal: homeState.dailyGoalCalories.toStringAsFixed(
                          0,
                        ),
                        protein:
                            '${homeState.dailyGoalProtein.toStringAsFixed(0)}g',
                        foodsToday: foodState is FoodLoaded
                            ? foodState.foods.length.toString()
                            : '0',
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 24),
              _buildSectionLabel('PREFERENCES'),
              const SizedBox(height: 8),
              _buildPreferencesCard(),
              const SizedBox(height: 24),
              _buildSectionLabel('ACCOUNT'),
              const SizedBox(height: 8),
              _buildAccountCard(),
              const SizedBox(height: 24),
              _buildSectionLabel('ABOUT'),
              const SizedBox(height: 8),
              _buildAboutCard(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  // ── header ────────────────────────────────────

  Widget _buildPageHeader() {
    return Row(
      children: [
        Text(
          'Settings',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: _textPrimary,
          ),
        ),
        const SizedBox(width: 8),
        const Text('⚙️', style: TextStyle(fontSize: 22)),
      ],
    );
  }

  // ── profile card ──────────────────────────────

  Widget _buildProfileCard({
    required String name,
    required String initials,
    required String email,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF1D9E75), Color(0xFF0891b2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  email,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white54, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            ),
            child: const Text(
              'Edit Profile',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  // ── stats row ─────────────────────────────────

  Widget _buildStatsRow({
    required String kcalGoal,
    required String protein,
    required String foodsToday,
  }) {
    return Row(
      children: [
        _buildStatCard(kcalGoal, 'kcal goal'),
        const SizedBox(width: 10),
        _buildStatCard(protein, 'protein'),
        const SizedBox(width: 10),
        _buildStatCard(foodsToday, 'foods today'),
      ],
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(14),
          border: _isDark ? Border.all(color: const Color(0xFF2A2A2A)) : null,
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2ECF93),
              ),
            ),
            const SizedBox(height: 3),
            Text(label, style: TextStyle(fontSize: 11, color: _textSecondary)),
          ],
        ),
      ),
    );
  }

  // ── section label ─────────────────────────────

  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
        color: _sectionLabelColor,
      ),
    );
  }

  // ── preferences card ──────────────────────────

  Widget _buildPreferencesCard() {
    return BlocBuilder<ThemeCubit, AppThemeMode>(
      builder: (context, themeMode) {
        final isDark = themeMode == AppThemeMode.dark;
        return Container(
          decoration: BoxDecoration(
            color: _cardBg,
            borderRadius: BorderRadius.circular(16),
            border: _isDark ? Border.all(color: const Color(0xFF2A2A2A)) : null,
          ),
          child: Column(
            children: [
              // Dark mode toggle — wired to ThemeCubit
              _buildToggleRow(
                emoji: isDark ? '🌙' : '☀️',
                label: 'Dark Mode',
                value: isDark,
                onChanged: (_) => context.read<ThemeCubit>().toggle(),
              ),
              _buildDivider(),
              _buildToggleRow(
                emoji: '🔔',
                label: 'Notifications',
                value: _notifications,
                onChanged: (v) => setState(() => _notifications = v),
              ),
              _buildDivider(),
              _buildToggleRow(
                emoji: '🎯',
                label: 'Daily Reminder',
                value: _dailyReminder,
                onChanged: (v) => setState(() => _dailyReminder = v),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildToggleRow({
    required String emoji,
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: _textPrimary,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: const Color(0xFF2ECF93),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: _inactiveTrack,
            trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
          ),
        ],
      ),
    );
  }

  // ── account card ──────────────────────────────

  Widget _buildAccountCard() {
    return Container(
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        border: _isDark ? Border.all(color: const Color(0xFF2A2A2A)) : null,
      ),
      child: Column(
        children: [
          _buildNavRow('👤', 'Edit Profile & Goals', () {}),
          _buildDivider(),
          _buildNavRow('📊', 'My Nutrition Results', () {}),
          _buildDivider(),
          _buildNavRow('📤', 'Export Food Log', () {}),
        ],
      ),
    );
  }

  // ── about card ────────────────────────────────

  Widget _buildAboutCard() {
    return Container(
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        border: _isDark ? Border.all(color: const Color(0xFF2A2A2A)) : null,
      ),
      child: Column(
        children: [
          _buildNavRow('ℹ️', 'About CaloriesPro', () {}),
          _buildDivider(),
          _buildNavRow('⭐', 'Rate the App', () {}),
          _buildDivider(),
          _buildNavRow('🔒', 'Privacy Policy', () {}),
          _buildDivider(),
          SizedBox(height: 12),
          GradientButton(text: 'Log Out', onPressed: () => showLogout(context)),
        ],
      ),
    );
  }

  Widget _buildNavRow(String emoji, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: _textPrimary,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: _chevronColor, size: 20),
          ],
        ),
      ),
    );
  }

  // ── logout row ────────────────────────────────

  // ── divider ───────────────────────────────────

  Widget _buildDivider() {
    return Divider(
      height: 0.5,
      thickness: 0.5,
      indent: 52,
      color: _dividerColor,
    );
  }
}

// ── logout dialog ─────────────────────────────

void showLogout(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  showDialog(
    barrierColor: Colors.black54,
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.logout_rounded,
              color: Colors.red,
              size: 26,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Log Out',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: isDark ? Colors.white : const Color(0xFF1A1A1A),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      content: Text(
        'Are you sure you want to log out of your account?',
        style: TextStyle(
          color: isDark ? Colors.white60 : Colors.grey[600],
          fontSize: 14,
        ),
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: isDark
                        ? Colors.white70
                        : const Color(0xFF1A1A1A),
                    side: BorderSide(
                      color: isDark
                          ? const Color(0xFF3A3A3A)
                          : const Color(0xFFE0E0E0),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(SignOutEvent());
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const SignInPage()),
                      (_) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Log Out',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
