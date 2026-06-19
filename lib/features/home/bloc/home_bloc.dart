import 'package:bloc/bloc.dart';
import 'package:caloriespro/shared/user_info/domain/entities/user_info.dart';
import 'package:caloriespro/shared/user_info/domain/usecase/info_get_usecase.dart';
import 'package:flutter/foundation.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final InfoGetUsecase infoGetUsecase;
  HomeBloc(this.infoGetUsecase) : super(HomeInitial()) {
    on<LoadHomeData>((event, emit) async {
      try {
        emit(HomeLoading());
        final userInfo = await infoGetUsecase();
        if (userInfo == null) {
          emit(HomeError('User info not found'));
          return;
        }
        emit(HomeLoaded(userInfo));
      } on Exception catch (e) {
        emit(HomeError(e.toString()));
      }
    });
  }
}
