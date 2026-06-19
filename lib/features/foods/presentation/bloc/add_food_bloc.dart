import 'package:bloc/bloc.dart';
import 'package:caloriespro/shared/food/domain/entities/add_food.dart';
import 'package:caloriespro/shared/food/domain/usecases/add_food_usecase.dart';
import 'package:caloriespro/shared/food/domain/usecases/get_food_usecase.dart';
import 'package:meta/meta.dart';

part 'add_food_event.dart';
part 'add_food_state.dart';

class AddFoodBloc extends Bloc<AddFoodEvent, AddFoodState> {
  final AddFoodUsecase addFoodUsecase;
  final GetFoodUsecase getFoodUsecase;

  AddFoodBloc({required this.addFoodUsecase, required this.getFoodUsecase})
    : super(AddFoodInitial()) {
    on<AddFoodRequested>(_onAddFood);

    on<LoadFoodsRequested>(_onLoadFoods);
  }

  Future<void> _onAddFood(
    AddFoodRequested event,
    Emitter<AddFoodState> emit,
  ) async {
    emit(AddFoodLoading());

    final result = await addFoodUsecase(event.food);

    result.fold(
      (failure) => emit(AddFoodFailure(failure)),
      (_) => emit(AddFoodAdded(event.food)),
    );
  }

  Future<void> _onLoadFoods(
    LoadFoodsRequested event,
    Emitter<AddFoodState> emit,
  ) async {
    emit(AddFoodLoading());

    final result = await getFoodUsecase();

    result.fold(
      (failure) => emit(AddFoodFailure(failure)),
      (foods) => emit(FoodLoaded(foods)),
    );
  }
}
