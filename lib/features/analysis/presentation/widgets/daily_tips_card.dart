// daily_tips_card.dart

import 'package:flutter/material.dart';

class DailyTipsCard extends StatefulWidget {
  const DailyTipsCard({super.key});

  @override
  State<DailyTipsCard> createState() => _DailyTipsCardState();
}

class _DailyTipsCardState extends State<DailyTipsCard> {
  int? _expandedIndex = 0; // first tip open by default

  static const _tips = [
    _Tip(
      icon: Icons.balance_outlined,
      iconColor: Color(0xFF1D9E75),
      iconBg: Color(0xFFE1F5EE),
      tag: 'Habit',
      tagColor: Color(0xFF0F6E56),
      tagBg: Color(0xFFE1F5EE),
      title: 'Stay consistent',
      body: 'Track weekly, not daily. Small variations are completely normal.',
      detail:
          'Obsessing over single-day swings creates anxiety without insight. Weekly averages smooth out water retention, meal timing, and natural fluctuation — giving you a cleaner signal on whether your approach is working.',
    ),
    _Tip(
      icon: Icons.egg_outlined,
      iconColor: Color(0xFF378ADD),
      iconBg: Color(0xFFE6F1FB),
      tag: 'Nutrition',
      tagColor: Color(0xFF185FA5),
      tagBg: Color(0xFFE6F1FB),
      title: 'Protein-rich foods',
      body: 'Chicken, eggs, Greek yogurt, legumes. Hit your daily target.',
      detail:
          'Protein keeps you fuller longer and preserves muscle during a deficit. Spread it across meals — your body can only synthesise so much at once. Aim for 25–40g per meal rather than front-loading at dinner.',
    ),
    _Tip(
      icon: Icons.water_drop_outlined,
      iconColor: Color(0xFF7F77DD),
      iconBg: Color(0xFFEEEDFE),
      tag: 'Energy',
      tagColor: Color(0xFF534AB7),
      tagBg: Color(0xFFEEEDFE),
      title: 'Hydration matters',
      body: 'Drink 2L+ daily for optimal metabolism and energy levels.',
      detail:
          'Even mild dehydration (1–2%) reduces cognitive performance and is often misread as hunger. Start your morning with a full glass before coffee — it jumpstarts digestion and reduces unnecessary snacking.',
    ),
    _Tip(
      icon: Icons.bedtime_outlined,
      iconColor: Color(0xFFBA7517),
      iconBg: Color(0xFFFAEEDA),
      tag: 'Recovery',
      tagColor: Color(0xFF854F0B),
      tagBg: Color(0xFFFAEEDA),
      title: 'Quality sleep',
      body: '7–9 hrs regulates hunger hormones, supporting your goals.',
      detail:
          'Poor sleep raises ghrelin (hunger) and lowers leptin (fullness) — making you consume ~300 extra calories the next day on average. Consistent sleep timing matters as much as duration.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section label with line
        Row(
          children: [
            const Text(
              'DAILY TIPS',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
                color: Color(0xFF1D9E75),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                height: 0.8,
                color: const Color(0xFF1D9E75).withValues(alpha: 0.2),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Tips
        ...List.generate(_tips.length, (i) {
          final tip = _tips[i];
          final isOpen = _expandedIndex == i;

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: GestureDetector(
              onTap: () => setState(() => _expandedIndex = isOpen ? null : i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isOpen ? const Color(0xFFFAFFFE) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isOpen
                        ? const Color(0xFF1D9E75)
                        : const Color(0xFFEBEBEB),
                    width: isOpen ? 1.2 : 0.8,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon badge
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: tip.iconBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(tip.icon, color: tip.iconColor, size: 20),
                    ),
                    const SizedBox(width: 14),

                    // Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title row
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  tip.title,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1A1A1A),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Tag pill
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: tip.tagBg,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  tip.tag,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: tip.tagColor,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              // Chevron
                              AnimatedRotation(
                                turns: isOpen ? 0.5 : 0,
                                duration: const Duration(milliseconds: 200),
                                child: const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  size: 18,
                                  color: Color(0xFFCCCCCC),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),

                          // Body
                          Text(
                            tip.body,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF888888),
                              height: 1.5,
                            ),
                          ),

                          // Expanded detail
                          AnimatedCrossFade(
                            firstChild: const SizedBox.shrink(),
                            secondChild: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                Container(
                                  height: 0.5,
                                  color: const Color(0xFFF0F0F0),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  tip.detail,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF555555),
                                    height: 1.6,
                                  ),
                                ),
                              ],
                            ),
                            crossFadeState: isOpen
                                ? CrossFadeState.showSecond
                                : CrossFadeState.showFirst,
                            duration: const Duration(milliseconds: 200),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _Tip {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String tag;
  final Color tagColor;
  final Color tagBg;
  final String title;
  final String body;
  final String detail;

  const _Tip({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.tag,
    required this.tagColor,
    required this.tagBg,
    required this.title,
    required this.body,
    required this.detail,
  });
}
