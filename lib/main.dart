import 'package:caloriespro/core/network/injection.dart' as di;
import 'package:caloriespro/core/theme/light_theme.dart';
import 'package:caloriespro/core/theme/theme_cubit.dart';
import 'package:caloriespro/features/analysis/presentation/bloc/last_seven_bloc.dart';
import 'package:caloriespro/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:caloriespro/features/auth/presentation/page/sign_in_page.dart';
import 'package:caloriespro/features/foods/presentation/bloc/add_food_bloc.dart';
import 'package:caloriespro/features/home/bloc/home_bloc.dart';
import 'package:caloriespro/features/splash/presentation/bloc/user_info_bloc.dart';
import 'package:caloriespro/features/splash/presentation/page/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  di.Injection.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ThemeCubit(),
        ), // ← top of the list, no child
        BlocProvider(
          create: (_) =>
              di.Injection.getIt<AuthBloc>()..add(CheckAuthStatusEvent()),
        ),
        BlocProvider(create: (_) => di.Injection.getIt<UserInfoBloc>()),
        BlocProvider(create: (_) => di.Injection.getIt<HomeBloc>()),
        BlocProvider(create: (_) => di.Injection.getIt<AddFoodBloc>()),
        BlocProvider(create: (_) => di.Injection.getIt<LastSevenBloc>()),
      ],
      child: const CaloriesProApp(), // ← single child here
    );
  }
}

class CaloriesProApp extends StatelessWidget {
  const CaloriesProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, AppThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'CaloriesPro',
          theme: LightTheme().themeData,
          darkTheme: DarkTheme().themeData,
          themeMode: themeMode == AppThemeMode.dark
              ? ThemeMode.dark
              : ThemeMode.light,
          home: const AuthWrapper(),
        );
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthInitial) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is AuthAuthenticated) {
          return const SplashScreen();
        } else {
          return SignInPage();
        }
      },
    );
  }
}
