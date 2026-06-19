import 'package:caloriespro/features/analysis/presentation/bloc/last_seven_bloc.dart';
import 'package:caloriespro/features/analysis/presentation/utils/week_slots_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProtienAnalysis extends StatefulWidget {
  const ProtienAnalysis({super.key, required this.protienGoal});
  final double protienGoal;

  @override
  State<ProtienAnalysis> createState() => _ProtienAnalysisState();
}

class _ProtienAnalysisState extends State<ProtienAnalysis> {
  int _selectedIndex = _todayIndex();

  static const _teal = Color(0xFF1D9E75);
  static const _tealLight = Color(0xFFE1F5EE);
  static const _tealDark = Color(0xFF0F6E56);
  static const _blue = Color(0xFF0891b2);
  static const _coral = Color(0xFFF0997B);

  // Returns Mon=0 … Sun=6 for today
  static int _todayIndex() => (DateTime.now().weekday - 1) % 7;

  static const _dayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  String _formatAvg(List<double?> slots) {
    final valid = slots.whereType<double>().toList();
    if (valid.isEmpty) return '—';
    final avg = valid.reduce((a, b) => a + b) / valid.length;
    return avg
        .toStringAsFixed(0)
        .replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]},');
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LastSevenBloc, LastSevenState>(
      builder: (context, state) {
        if (state is LastSevenLoading || state is LastSevenInitial) {
          return _shell(child: _loadingPlaceholder());
        }
        if (state is LastSevenError) {
          return _shell(child: _errorPlaceholder(state.message));
        }
        if (state is LastSevenLoaded) {
          final slots = toWeekSlots(state.lastSevenDays);
          return _shell(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(_formatAvg(slots)),
                const SizedBox(height: 14),
                _buildChart(slots),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _shell({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8E8E8), width: 0.8),
      ),
      child: child,
    );
  }

  Widget _loadingPlaceholder() {
    return SizedBox(
      height: 126,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _shimmer(width: 70, height: 14),
              const Spacer(),
              _shimmer(width: 90, height: 22, radius: 20),
            ],
          ),
          const SizedBox(height: 14),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(
                7,
                (i) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: _shimmer(
                      width: double.infinity,
                      height: 40.0 + (i % 3) * 20,
                      radius: 6,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _shimmer({
    required double width,
    required double height,
    double radius = 6,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  Widget _errorPlaceholder(String message) {
    return SizedBox(
      height: 80,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, color: Colors.grey, size: 20),
            const SizedBox(height: 6),
            Text(
              'Could not load data',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String avgLabel) {
    return Row(
      children: [
        const Text(
          'Protien',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: _tealLight,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Avg $avgLabel g',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: _tealDark,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChart(List<double?> calories) {
    final valid = calories.whereType<double>().toList();
    final maxVal = [
      ...valid,
      widget.protienGoal.toDouble(),
    ].reduce((a, b) => a > b ? a : b);

    const tooltipHeight = 20.0;
    const barAreaHeight = 88.0;
    const gapHeight = 4.0;
    const labelHeight = 14.0;
    const totalHeight = tooltipHeight + barAreaHeight + gapHeight + labelHeight;

    return SizedBox(
      height: totalHeight,
      child: Stack(
        children: [
          // Goal dashed line
          Positioned(
            top:
                tooltipHeight +
                barAreaHeight -
                (widget.protienGoal / maxVal * barAreaHeight),
            left: 0,
            right: 0,
            height: 1,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: CustomPaint(
                    painter: _DashedLinePainter(_teal.withValues(alpha: 0.4)),
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '${(widget.protienGoal / 1000).toStringAsFixed(0)}k',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: _teal.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),

          // Bars
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(_dayLabels.length, (i) {
              final val = calories[i];
              final isSelected = i == _selectedIndex;
              final isToday = i == _todayIndex();

              final Color barColor;
              if (val == null) {
                barColor = Colors.grey.shade100;
              } else if (val > widget.protienGoal) {
                barColor = _coral;
              } else {
                barColor = const Color(0xFFD1EDE6);
              }

              final barHeight = val != null
                  ? (val / maxVal * barAreaHeight).clamp(4.0, barAreaHeight)
                  : 4.0;

              final useGradient =
                  (isToday || isSelected) &&
                  val != null &&
                  val <= widget.protienGoal;

              return Expanded(
                child: GestureDetector(
                  onTap: val != null
                      ? () => setState(() => _selectedIndex = i)
                      : null,
                  child: SizedBox(
                    height: totalHeight,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Tooltip
                        if (isSelected && val != null)
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            height: tooltipHeight,
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1A1A1A),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  val.toStringAsFixed(0),
                                  style: const TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),

                        // Bar
                        Positioned(
                          top: tooltipHeight + (barAreaHeight - barHeight),
                          left: 2,
                          right: 2,
                          height: barHeight,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                            decoration: BoxDecoration(
                              gradient: useGradient
                                  ? const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [_teal, _blue],
                                    )
                                  : null,
                              color: useGradient ? null : barColor,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(6),
                              ),
                              border: isSelected
                                  ? Border.all(color: _teal, width: 1.5)
                                  : null,
                            ),
                          ),
                        ),

                        // Day label
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          height: labelHeight,
                          child: Center(
                            child: Text(
                              _dayLabels[i],
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: isToday
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: isToday ? _teal : Colors.grey.shade400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;
  const _DashedLinePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    const dashWidth = 4.0;
    const dashSpace = 3.0;
    double x = 0;
    while (x < size.width) {
      canvas.drawLine(Offset(x, 0), Offset(x + dashWidth, 0), paint);
      x += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(_DashedLinePainter old) => false;
}
