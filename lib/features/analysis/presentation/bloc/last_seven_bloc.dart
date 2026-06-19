import 'package:bloc/bloc.dart';
import 'package:caloriespro/features/analysis/domain/entity/food_last_seven_days.dart';
import 'package:caloriespro/features/analysis/domain/usecases/last_calories_usecase.dart';
import 'package:meta/meta.dart';

part 'last_seven_event.dart';
part 'last_seven_state.dart';

class LastSevenBloc extends Bloc<FetchLastSevenEvent, LastSevenState> {
  final LastCaloriesUsecase lastCaloriesUsecase;
  LastSevenBloc({required this.lastCaloriesUsecase})
    : super(LastSevenInitial()) {
    on<FetchLastSevenEvent>((event, emit) async {
      emit(LastSevenLoading());
      try {
        final result = await lastCaloriesUsecase();
        emit(LastSevenLoaded(lastSevenDays: result));
      } catch (e) {
        print('LastSevenBloc ERROR: $e');
        emit(LastSevenError(message: e.toString()));
      }
    });
  }
}
