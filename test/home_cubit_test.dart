import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:youtube/domain_layer/domain_layer.dart';
import 'package:youtube/feature_layer/home/cubit/home_cubit.dart';

class MockYoutubeRepository extends Mock implements YoutubeRepository {}

void main() {
  group('HomeCubit', () {
    late HomeCubit homeCubit;
    late YoutubeRepository mockApi;

    setUp(() {
      mockApi = MockYoutubeRepository();
      homeCubit = HomeCubit(api: mockApi);
    });

    tearDown(() {
      homeCubit.close();
    });

    test('initial state is correct', () {
      expect(homeCubit.state, const HomeState());
    });

    blocTest<HomeCubit, HomeState>(
      'buscarVideos emits correct states',
      build: () {
        when(() => mockApi.search(any())).thenAnswer((_) async => []);
        return homeCubit;
      },
      act: (cubit) => cubit.buscarVideos('searchQuery'),
      expect: () => [
        const HomeState(loadingStatus: LoadingStatus.loading),
        const HomeState(loadingStatus: LoadingStatus.success, videos: []),
      ],
    );

    blocTest<HomeCubit, HomeState>(
      'buscarVideos handles error',
      build: () {
        when(() => mockApi.search(any())).thenThrow(Exception());
        return homeCubit;
      },
      act: (cubit) => cubit.buscarVideos('searchQuery'),
      expect: () => [
        const HomeState(loadingStatus: LoadingStatus.loading),
        const HomeState(loadingStatus: LoadingStatus.error),
      ],
    );
  });
}