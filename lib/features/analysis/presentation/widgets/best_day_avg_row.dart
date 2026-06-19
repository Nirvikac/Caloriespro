// best_day_avg_row.dart

import 'package:flutter/material.dart';

class BestDayAvgRow extends StatelessWidget {
  final List<double?> slots; // Mon=0…Sun=6, null = no data
  final double goal;

  const BestDayAvgRow({super.key, required this.slots, required this.goal});

  static const _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const _teal = Color(0xFF1D9E75);
  static const _tealLight = Color(0xFFE1F5EE);
  static const _blue = Color(0xFF378ADD);
  static const _blueLight = Color(0xFFE6F1FB);

  @override
  Widget build(BuildContext context) {
    final valid = slots.whereType<double>().toList();

    final bestVal = valid.isEmpty
        ? null
        : valid.reduce((a, b) => a > b ? a : b);
    final bestIdx = bestVal == null ? null : slots.indexOf(bestVal);
    final bestDay = bestIdx != null ? _days[bestIdx] : '—';

    final avg = valid.isEmpty
        ? null
        : valid.reduce((a, b) => a + b) / valid.length;

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            iconData: Icons.local_fire_department_outlined,
            iconColor: _teal,
            iconBg: _tealLight,
            label: 'BEST DAY',
            labelColor: _teal,
            value: bestVal != null ? _fmt(bestVal) : '—',
            sub: bestDay,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            iconData: Icons.show_chart_rounded,
            iconColor: _blue,
            iconBg: _blueLight,
            label: 'DAILY AVG',
            labelColor: _blue,
            value: avg != null ? _fmt(avg) : '—',
            sub: 'vs ${_fmt(goal.toDouble())} goal',
          ),
        ),
      ],
    );
  }

  String _fmt(double v) => v
      .toStringAsFixed(0)
      .replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]},');
}

class _StatCard extends StatelessWidget {
  final IconData iconData;
  final Color iconColor;
  final Color iconBg;
  final String label;
  final Color labelColor;
  final String value;
  final String sub;

  const _StatCard({
    required this.iconData,
    required this.iconColor,
    required this.iconBg,
    required this.label,
    required this.labelColor,
    required this.value,
    required this.sub,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8E8E8), width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon badge
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(iconData, color: iconColor, size: 20),
          ),
          const SizedBox(height: 10),

          // Label
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: labelColor,
            ),
          ),
          const SizedBox(height: 4),

          // Value
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A1A),
              height: 1,
            ),
          ),
          const SizedBox(height: 3),

          // Sub
          Text(
            sub,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}
