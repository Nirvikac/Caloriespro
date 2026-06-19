import 'package:flutter_bloc/flutter_bloc.dart';

enum AppThemeMode { light, dark }

class ThemeCubit extends Cubit<AppThemeMode> {
  ThemeCubit() : super(AppThemeMode.light);

  void setLight() => emit(AppThemeMode.light);
  void setDark() => emit(AppThemeMode.dark);
  void toggle() => emit(
    state == AppThemeMode.light ? AppThemeMode.dark : AppThemeMode.light,
  );

  bool get isDark => state == AppThemeMode.dark;
}
