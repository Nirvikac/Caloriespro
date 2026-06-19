// import 'package:flutter/material.dart';

// class TodaysProgress extends StatelessWidget {
//   const TodaysProgress({
//     super.key,
//     required this.todaysCalories,
//     required this.dailyGoalCalories,
//     required this.todaysProtein,
//     required this.dailyGoalProtein,
//   });

//   final double todaysCalories;
//   final double dailyGoalCalories;
//   final double todaysProtein;
//   final double dailyGoalProtein;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           colors: [Color(0xFF4DD9AC), Color(0xFF45B8D8)],
//           begin: Alignment.centerLeft,
//           end: Alignment.centerRight,
//         ),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text(
//                 "TODAY'S PROGRESS",
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 13,
//                   letterSpacing: 1.1,
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 12,
//                   vertical: 6,
//                 ),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withValues(alpha: 0.25),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: const Row(
//                   children: [
//                     Text(
//                       'On Track',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 12,
//                       ),
//                     ),
//                     SizedBox(width: 4),
//                     Text('🎯', style: TextStyle(fontSize: 12)),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           _progressRow(
//             emoji: '🔥',
//             label: 'Calories',
//             value: '$todaysCalories / ${dailyGoalCalories} kcal',
//           ),
//           const SizedBox(height: 12),
//           _progressRow(
//             emoji: '💪',
//             label: 'Protein',
//             value: '$todaysProtein / ${dailyGoalProtein}g',
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _progressRow({
//     required String emoji,
//     required String label,
//     required String value,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               children: [
//                 Text(emoji, style: const TextStyle(fontSize: 20)),
//                 const SizedBox(width: 8),
//                 Text(
//                   label,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.w500,
//                     fontSize: 14,
//                   ),
//                 ),
//               ],
//             ),
//             Text(
//               value,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.w600,
//                 fontSize: 14,
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 6),
//         ClipRRect(
//           borderRadius: BorderRadius.circular(10),
//           child: LinearProgressIndicator(
//             value: 0,
//             minHeight: 5,
//             backgroundColor: Colors.white.withValues(alpha: 0.3),
//             valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'dart:math' as math;

class TodaysProgress extends StatelessWidget {
  const TodaysProgress({
    super.key,
    required this.todaysCalories,
    required this.dailyGoalCalories,
    required this.todaysProtein,
    required this.dailyGoalProtein,
  });

  final double todaysCalories;
  final double dailyGoalCalories;
  final double todaysProtein;
  final double dailyGoalProtein;

  double get _calPct =>
      (dailyGoalCalories > 0 ? todaysCalories / dailyGoalCalories : 0.0).clamp(
        0.0,
        1.0,
      );

  double get _protPct =>
      (dailyGoalProtein > 0 ? todaysProtein / dailyGoalProtein : 0.0).clamp(
        0.0,
        1.0,
      );

  String get _statusLabel {
    if (_calPct >= 1.0) return 'Goal Reached';
    if (_calPct >= 0.7) return 'Almost There';
    if (_calPct >= 0.3) return 'On Track';
    return 'Just Started';
  }

  @override
  Widget build(BuildContext context) {
    final remainingCal = (dailyGoalCalories - todaysCalories).clamp(
      0,
      double.infinity,
    );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1D9E75), Color(0xFF0891b2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top row ───────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "TODAY'S PROGRESS",
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.8,
                ),
              ),
              _StatusBadge(label: _statusLabel),
            ],
          ),
          const SizedBox(height: 14),

          // ── Ring + calorie summary ─────────────
          Row(
            children: [
              _CalorieRing(percent: _calPct),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Calories consumed',
                      style: TextStyle(color: Colors.white60, fontSize: 11),
                    ),
                    const SizedBox(height: 3),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: todaysCalories.toStringAsFixed(0),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              height: 1.1,
                            ),
                          ),
                          const TextSpan(
                            text: ' kcal',
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Goal: ${dailyGoalCalories.toStringAsFixed(0)} kcal',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${remainingCal.toStringAsFixed(0)} kcal remaining',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // ── Divider ───────────────────────────
          Divider(color: Colors.white.withValues(alpha: 0.15), thickness: 0.5),
          const SizedBox(height: 12),

          // ── Progress bars ─────────────────────
          _ProgressRow(
            icon: Icons.local_fire_department_outlined,
            label: 'Calories',
            current: todaysCalories,
            goal: dailyGoalCalories,
            unit: 'kcal',
            fillColor: Colors.white.withValues(alpha: 0.9),
          ),
          const SizedBox(height: 10),
          _ProgressRow(
            icon: Icons.fitness_center_outlined,
            label: 'Protein',
            current: todaysProtein,
            goal: dailyGoalProtein,
            unit: 'g',
            fillColor: const Color(0xFFFFDC64).withValues(alpha: 0.9),
          ),
        ],
      ),
    );
  }
}

// ── Ring ──────────────────────────────────────────────────────────────────────

class _CalorieRing extends StatelessWidget {
  const _CalorieRing({required this.percent});
  final double percent;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 74,
      height: 74,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(74, 74),
            painter: _RingPainter(percent: percent),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${(percent * 100).toStringAsFixed(0)}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
              ),
              const Text(
                'of goal',
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 9,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({required this.percent});
  final double percent;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    const strokeW = 6.0;
    final radius = (size.width - strokeW) / 2;
    final rect = Rect.fromCircle(center: Offset(cx, cy), radius: radius);

    canvas.drawArc(
      rect,
      0,
      math.pi * 2,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeW
        ..color = Colors.white.withValues(alpha: 0.2),
    );

    if (percent > 0) {
      canvas.drawArc(
        rect,
        -math.pi / 2,
        math.pi * 2 * percent,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeW
          ..strokeCap = StrokeCap.round
          ..color = Colors.white.withValues(alpha: 0.9),
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.percent != percent;
}

// ── Progress row ──────────────────────────────────────────────────────────────

class _ProgressRow extends StatelessWidget {
  const _ProgressRow({
    required this.icon,
    required this.label,
    required this.current,
    required this.goal,
    required this.unit,
    required this.fillColor,
  });

  final IconData icon;
  final String label, unit;
  final double current, goal;
  final Color fillColor;

  @override
  Widget build(BuildContext context) {
    final pct = (goal > 0 ? current / goal : 0.0).clamp(0.0, 1.0);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.white, size: 14),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Text(
              '${current.toStringAsFixed(0)} / ${goal.toStringAsFixed(0)} $unit',
              style: const TextStyle(color: Colors.white60, fontSize: 11),
            ),
          ],
        ),
        const SizedBox(height: 5),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: pct,
            minHeight: 6,
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(fillColor),
          ),
        ),
      ],
    );
  }
}

// ── Status badge ──────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
