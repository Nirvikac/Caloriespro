part of 'last_seven_bloc.dart';

@immutable
sealed class LastSevenState {}

final class LastSevenInitial extends LastSevenState {}

final class LastSevenLoading extends LastSevenState {}

final class LastSevenLoaded extends LastSevenState {
  final List<FoodLastSevenDays> lastSevenDays;
  LastSevenLoaded({required this.lastSevenDays});
}

final class LastSevenError extends LastSevenState {
  final String message;
  LastSevenError({required this.message});
}
