import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:youtube/feature_layer/main/cubit/main_cubit.dart';

void main() {
  group('MainCubit', () {
    late MainCubit mainCubit;

    setUp(() {
      mainCubit = MainCubit();
    });

    tearDown(() {
      mainCubit.close();
    });

    test('initial state is correct', () {
      expect(mainCubit.state, const MainState());
    });

    blocTest<MainCubit, MainState>(
      'changePage emits correct state',
      build: () => mainCubit,
      act: (cubit) => cubit.changePage(1),
      expect: () => [const MainState(currentIndex: 1)],
    );

    blocTest<MainCubit, MainState>(
      'changeResult emits correct state',
      build: () => mainCubit,
      act: (cubit) => cubit.changeResult('success'),
      expect: () => [const MainState(result: 'success')],
    );
  });
}
