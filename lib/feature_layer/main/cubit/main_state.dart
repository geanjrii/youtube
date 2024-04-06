part of 'main_cubit.dart';

class MainState extends Equatable {
  final int currentIndex;

  final String result;

  const MainState({
    this.currentIndex = 0,
    this.result = '',
  });

  MainState copyWith({
    int? currentIndex,
    String? result,
  }) {
    return MainState(
      currentIndex: currentIndex ?? this.currentIndex,
      result: result ?? this.result,
    );
  }

  @override
  List<Object> get props => [currentIndex, result];
}
