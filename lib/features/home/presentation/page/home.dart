import 'package:caloriespro/features/analysis/presentation/page/analysis_page.dart';
import 'package:caloriespro/features/home/presentation/page/home_page.dart';
import 'package:caloriespro/features/settings/settings_page.dart';
import 'package:flutter/material.dart';

// ─── Nav bar dimensions (single source of truth) ──────────────────────────────
const double kNavBarHeight = 68;
const double kNavBarBottomInset = 24;
const double kNavBarBreathing = 12;
const double kNavBarClearance =
    kNavBarHeight + kNavBarBottomInset + kNavBarBreathing; // 104

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  static const List<_NavItem> _navItems = [
    _NavItem(
      icon: Icons.home_rounded,
      outlinedIcon: Icons.home_outlined,
      label: 'Home',
    ),
    _NavItem(
      icon: Icons.analytics_rounded,
      outlinedIcon: Icons.analytics_outlined,
      label: 'Analysis',
    ),

    _NavItem(
      icon: Icons.settings_rounded,
      outlinedIcon: Icons.settings_outlined,
      label: 'Settings',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final systemBottom = MediaQuery.of(context).padding.bottom;
    // On devices with a home indicator (iOS), use the system inset;
    // on others, fall back to our fixed constant.
    final effectiveClearance = systemBottom > 0
        ? systemBottom + kNavBarHeight + kNavBarBreathing
        : kNavBarClearance;

    return Scaffold(
      extendBody: true,
      // Override bottom padding once here so EVERY child page's
      // SafeArea / ListView / SingleChildScrollView clears the nav bar
      // automatically — no per-page fix needed.
      body: MediaQuery(
        data: MediaQuery.of(context).copyWith(
          padding: MediaQuery.of(
            context,
          ).padding.copyWith(bottom: effectiveClearance),
        ),
        child: IndexedStack(
          index: _currentIndex,
          children: const [HomePage(), AnalysisPage(), SettingsPage()],
        ),
      ),
      bottomNavigationBar: _FloatingNavBar(
        currentIndex: _currentIndex,
        items: _navItems,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}

// ─── Data class ───────────────────────────────────────────────────────────────

class _NavItem {
  final IconData icon;
  final IconData outlinedIcon;
  final String label;

  const _NavItem({
    required this.icon,
    required this.outlinedIcon,
    required this.label,
  });
}

// ─── Floating Nav Bar ─────────────────────────────────────────────────────────

class _FloatingNavBar extends StatelessWidget {
  final int currentIndex;
  final List<_NavItem> items;
  final ValueChanged<int> onTap;

  const _FloatingNavBar({
    required this.currentIndex,
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final systemBottom = MediaQuery.of(context).padding.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        0,
        20,
        systemBottom > 0 ? systemBottom : kNavBarBottomInset,
      ),
      child: Container(
        height: kNavBarHeight,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 32,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: const Color(0xFF1D9E75).withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              items.length,
              (i) => _NavBarItem(
                item: items[i],
                isSelected: currentIndex == i,
                onTap: () => onTap(i),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Individual Nav Item ──────────────────────────────────────────────────────

class _NavBarItem extends StatefulWidget {
  final _NavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_NavBarItem> createState() => _NavBarItemState();
}

class _NavBarItemState extends State<_NavBarItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnim = Tween<double>(
      begin: 1.0,
      end: 1.12,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    if (widget.isSelected) _controller.value = 1.0;
  }

  @override
  void didUpdateWidget(_NavBarItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected != oldWidget.isSelected) {
      widget.isSelected ? _controller.forward() : _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return SizedBox(
            width: 72,
            height: 52,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    width: widget.isSelected ? 64 : 0,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: widget.isSelected
                          ? const LinearGradient(
                              colors: [Color(0xFF1D9E75), Color(0xFF0891b2)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                Transform.scale(
                  scale: _scaleAnim.value,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        widget.isSelected
                            ? widget.item.icon
                            : widget.item.outlinedIcon,
                        size: 22,
                        color: widget.isSelected
                            ? Colors.white
                            : Colors.grey[400],
                      ),
                      if (widget.isSelected) ...[
                        const SizedBox(height: 2),
                        Text(
                          widget.item.label,
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
