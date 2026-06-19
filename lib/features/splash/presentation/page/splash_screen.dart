import 'package:caloriespro/core/theme/gradient_button.dart';
import 'package:caloriespro/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:caloriespro/features/home/presentation/page/home.dart';
import 'package:caloriespro/features/splash/presentation/page/user_info.dart';
import 'package:caloriespro/features/splash/presentation/bloc/user_info_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
    context.read<UserInfoBloc>().add(GetUserInfo());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void goToOnboarding() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => UserInfo()));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserInfoBloc, UserInfoState>(
      listener: (context, state) {
        if (state is UserInfoSuccess) {
          if (state.isExistingUser) {
            // Has userId → go to Home
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          }
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: FadeTransition(
            opacity: _fade,
            child: SlideTransition(
              position: _slide,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 40),

                    Image.asset('assets/screen.png', width: 80),

                    const SizedBox(height: 16),

                    Text(
                      'CaloriesPro',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),

                    const SizedBox(height: 10),

                    Text(
                      'Track your calories and achieve your fitness goals with ease.',
                      textAlign: TextAlign.center,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                    ),

                    const SizedBox(height: 40),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.asset(
                        'assets/vegies.png',
                        height: 260,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),

                    const SizedBox(height: 60),

                    GradientButton(
                      text: "Get Started",
                      onPressed: goToOnboarding,
                    ),

                    const SizedBox(height: 12),
                    GradientButton(
                      text: "Log Out",
                      onPressed: () {
                        debugPrint('🔐 Logging out...');
                        context.read<AuthBloc>().add(SignOutEvent());
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
