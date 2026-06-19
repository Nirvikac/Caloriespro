import 'package:caloriespro/core/extension/home_state_extension.dart';
import 'package:caloriespro/features/analysis/presentation/bloc/last_seven_bloc.dart';
import 'package:caloriespro/features/analysis/presentation/utils/week_slots_helper.dart';
import 'package:caloriespro/features/analysis/presentation/widgets/best_day_avg_row.dart';
import 'package:caloriespro/features/analysis/presentation/widgets/calories_analysis.dart';
import 'package:caloriespro/features/analysis/presentation/widgets/daily_tips_card.dart';
import 'package:caloriespro/features/home/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AnalysisPage extends StatefulWidget {
  const AnalysisPage({super.key});

  @override
  State<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  void _fetch() {
    context.read<LastSevenBloc>().add(FetchLastSevenEvent());
  }

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final start = now.subtract(const Duration(days: 6));

    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weekly Analysis',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 4),
            Text(
              'Week of ${DateFormat('MMM d').format(start)} – ${DateFormat('MMM d').format(now)}',
              style: const TextStyle(fontSize: 13, color: Color(0xFF888888)),
            ),
          ],
        ),
        elevation: 1,
      ),
      body: RefreshIndicator(
        color: const Color(0xFF1D9E75),
        onRefresh: () async {
          _fetch();
          await context.read<LastSevenBloc>().stream.firstWhere(
            (s) => s is LastSevenLoaded || s is LastSevenError,
          );
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: 104,
          ),
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, homeState) {
              final goalCalories = homeState.dailyGoalCalories;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Center(
                    child: Text(
                      "This Week's Calories",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Calories chart ──────────────────
                  CaloriesAnalysis(caloriesGoal: goalCalories),
                  const SizedBox(height: 16),

                  // ── Best day + avg ──────────────────
                  BlocBuilder<LastSevenBloc, LastSevenState>(
                    builder: (context, state) {
                      if (state is! LastSevenLoaded) {
                        return const SizedBox.shrink();
                      }
                      final slots = toWeekSlots(state.lastSevenDays);
                      return BestDayAvgRow(slots: slots, goal: goalCalories);
                    },
                  ),
                  DailyTipsCard(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
