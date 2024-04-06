import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(const MainState());


  void changePage(int index) {
    emit(state.copyWith(currentIndex: index));
  }

  void changeResult(String result) {
    emit(state.copyWith(result: result));
  }
}