import 'package:caloriespro/core/ads/banner_ad_widget.dart';
import 'package:caloriespro/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:caloriespro/features/foods/presentation/bloc/add_food_bloc.dart';
import 'package:caloriespro/features/home/bloc/home_bloc.dart';
import 'package:caloriespro/features/home/presentation/page/home.dart';
import 'package:caloriespro/features/home/presentation/widgets/food_card.dart';
import 'package:caloriespro/features/home/presentation/widgets/food_horizontal.dart';
import 'package:caloriespro/features/home/presentation/widgets/greeting_profile.dart';
import 'package:caloriespro/features/home/presentation/widgets/todays_progress.dart';
import 'package:caloriespro/features/settings/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caloriespro/core/extension/food_state_extension.dart';
import 'package:caloriespro/core/extension/home_state_extension.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(LoadHomeData());
    context.read<AuthBloc>().add(GetUserProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    // Use a plain widget tree — no nested Scaffold.
    // HomeScreen's Scaffold already owns the app chrome.
    return SafeArea(
      // bottom: false because HomeScreen's MediaQuery override
      // already reserves the right amount of space.
      bottom: false,
      child: SingleChildScrollView(
        // Extra bottom padding so the last card isn't hidden
        // behind the floating nav bar.
        padding: const EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
          bottom: kNavBarClearance,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top bar ───────────────────────────
            Row(
              children: [
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is AuthAuthenticated) {
                      return GreetingProfile(name: state.user.username);
                    }
                    return const GreetingProfile();
                  },
                ),
                const Spacer(),
                _ProfileButton(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SettingsPage()),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ── Today's progress ──────────────────
            BlocBuilder<AddFoodBloc, AddFoodState>(
              builder: (context, foodState) {
                return BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, homeState) {
                    return TodaysProgress(
                      todaysCalories: foodState.todaysCalories,
                      dailyGoalCalories: homeState.dailyGoalCalories,
                      todaysProtein: foodState.todaysProtein,
                      dailyGoalProtein: homeState.dailyGoalProtein,
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 12),

            // ── Food log ──────────────────────────
            const FoodCard(),
            const SizedBox(height: 12),
            const BannerAdWidget(),
            const SizedBox(height: 12),
            // ── Horizontal food suggestions ───────
            const FoodHorizontal(),
          ],
        ),
      ),
    );
  }
}

// ─── Profile button ───────────────────────────────────────────────────────────

class _ProfileButton extends StatelessWidget {
  final VoidCallback onTap;

  const _ProfileButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4DD9AC), Color(0xFF45B8D8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.person_rounded, size: 22, color: Colors.white),
      ),
    );
  }
}
